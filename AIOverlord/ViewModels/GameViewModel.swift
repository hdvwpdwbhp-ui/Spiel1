import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    private let persistence: PersistenceServiceType
    private let incomeService: IncomeServiceType
    private let prestigeService: PrestigeServiceType
    private let spinService: SpinServiceType
    private let antiCheat: AntiCheatServiceType

    @Published private(set) var state: PlayerState
    @Published private(set) var dimension: Dimension
    @Published private(set) var incomePerSecond: Double = 0
    @Published var activeBoostMultiplier: Double = 1.0
    @Published var boostEndsAt: Date? = nil
    @Published var showSoftStuckOffer: Bool = false
    @Published var lastSoftStuckAt: Date? = nil

    private var timerCancellable: AnyCancellable?
    private var autosaveCounter: Int = 0

    init(
        persistence: PersistenceServiceType = PersistenceService(),
        incomeService: IncomeServiceType = IncomeService(),
        prestigeService: PrestigeServiceType = PrestigeService(),
        spinService: SpinServiceType = SpinService(),
        antiCheat: AntiCheatServiceType = AntiCheatService()
    ) {
        self.persistence = persistence
        self.incomeService = incomeService
        self.prestigeService = prestigeService
        self.spinService = spinService
        self.antiCheat = antiCheat

        if let loaded = try? persistence.load(), let st = loaded {
            self.state = st
        } else {
            self.state = PlayerState.fresh(playerName: "Overlord")
        }
        self.dimension = DimensionFactory.makeDimension(id: self.state.currentDimensionId)

        FirebaseService.shared.configureIfAvailable()
        FirebaseService.shared.logEvent("session_start")
        applyOfflineEarnings()
        recalcDerived()
        startTimer()
    }

    func setPlayerName(_ name: String) {
        state.playerName = name
        saveNow()
    }

    func startTimer() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: GameConstants.tickInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    private func tick() {
        guard !state.cheatFlagged else { return }

        if let ends = boostEndsAt, TimeUtil.now() >= ends {
            activeBoostMultiplier = 1.0
            boostEndsAt = nil
        }

        let activeSkins = getActiveSkins()
        let baseIncome = incomeService.totalIncomePerSecond(state: state, dimension: dimension, activeSkins: activeSkins)
        let boostedIncome = baseIncome * activeBoostMultiplier
        let expectedTick = boostedIncome * GameConstants.tickInterval
        let actualTick = expectedTick

        if !antiCheat.validateTick(state: state, expectedIncome: expectedTick, actualIncome: actualTick) {
            state.cheatFlagged = true
            FirebaseService.shared.logEvent("cheat_detected")
            return
        }

        state.coins += actualTick
        state.lifetimeEarnings += actualTick
        state.lastActiveAt = TimeUtil.now()

        autosaveCounter += 1
        if autosaveCounter >= GameConstants.autosaveIntervalSeconds {
            autosaveCounter = 0
            saveNow()
        }

        recalcDerived()
        evaluateSoftStuck()
    }

    private func recalcDerived() {
        let activeSkins = getActiveSkins()
        incomePerSecond = incomeService.totalIncomePerSecond(state: state, dimension: dimension, activeSkins: activeSkins) * activeBoostMultiplier
    }

    private func evaluateSoftStuck() {
        guard let seconds = incomeService.secondsToNextCheapestUpgrade(state: state, dimension: dimension) else { return }
        if seconds > GameConstants.softStuckSecondsThreshold {
            if let last = lastSoftStuckAt, TimeUtil.now().timeIntervalSince(last) < 180 { return }
            lastSoftStuckAt = TimeUtil.now()
            showSoftStuckOffer = true
            FirebaseService.shared.logEvent("soft_stuck_detected", params: ["seconds": seconds])
        }
    }

    func buyBusinessLevel(businessId: UUID) {
        guard let idx = dimension.businesses.firstIndex(where: { $0.id == businessId }) else { return }
        let cost = dimension.businesses[idx].nextCost()
        guard state.coins >= cost else { return }
        state.coins -= cost
        dimension.businesses[idx].level += 1
        Haptics.light()
        FirebaseService.shared.logEvent("upgrade_business", params: ["name": dimension.businesses[idx].name])
        recalcDerived()
    }

    func aiNextCost() -> Double {
        GameConstants.aiBaseCost * pow(GameConstants.aiCostGrowth, Double(state.aiLevel))
    }

    func buyAILevel() {
        let cost = aiNextCost()
        guard state.coins >= cost else { return }
        state.coins -= cost
        state.aiLevel += 1
        Haptics.success()
        FirebaseService.shared.logEvent("ai_level_up", params: ["level": state.aiLevel])
        recalcDerived()
    }

    func prestige() {
        var dim = dimension
        var st = state
        let gain = prestigeService.prestigeGain(lifetimeEarnings: st.lifetimeEarnings)
        if !antiCheat.validatePrestigeGain(lifetimeEarnings: st.lifetimeEarnings, gainTokens: gain) {
            st.cheatFlagged = true
            FirebaseService.shared.logEvent("cheat_detected")
            state = st
            return
        }
        prestigeService.performPrestige(state: &st, dimension: &dim)
        state = st
        dimension = dim
        FirebaseService.shared.logEvent("prestige_triggered", params: ["prestigeCount": state.prestigeCount])
        Task { await submitLeaderboardIfAllowed() }
        saveNow()
        recalcDerived()
    }

    func switchDimension(to id: Int) {
        state.currentDimensionId = id
        dimension = DimensionFactory.makeDimension(id: id)
        saveNow()
        FirebaseService.shared.logEvent("dimension_unlocked", params: ["id": id])
        recalcDerived()
    }

    func refreshFreeSpins() {
        var st = state
        spinService.refreshFreeSpinStorage(state: &st, now: TimeUtil.now())
        state = st
        saveNow()
    }

    func canSpinFree() -> Bool {
        refreshFreeSpins()
        return state.storedFreeSpins > 0
    }

    func spinOnce(skinPool: [Skin]) -> SpinReward {
        var st = state
        let reward = spinService.spin(state: &st, skinPool: skinPool)
        state = st
        applySpinReward(reward)
        FirebaseService.shared.logEvent("spin_used")
        saveNow()
        return reward
    }

    private func applySpinReward(_ reward: SpinReward) {
        switch reward {
        case .coins(let c): state.coins += c
        case .tokens(let t): state.tokens += t
        case .boost(let m, let seconds):
            activeBoostMultiplier = m
            boostEndsAt = TimeUtil.now().addingTimeInterval(TimeInterval(seconds))
        case .skin(let skin):
            if !state.unlockedSkins.contains(where: { $0.id == skin.id }) { state.unlockedSkins.append(skin) }
        }
        Haptics.success()
        recalcDerived()
    }

    func getActiveSkins() -> [Skin] {
        let set = Set(state.activeSkinIds)
        return state.unlockedSkins.filter { set.contains($0.id) }
    }

    func toggleSkinActive(_ skin: Skin) {
        var ids = state.activeSkinIds
        if let i = ids.firstIndex(of: skin.id) {
            ids.remove(at: i)
        } else {
            if ids.count >= GameConstants.maxActiveSkins { return }
            ids.append(skin.id)
        }
        state.activeSkinIds = ids
        recalcDerived()
        saveNow()
    }

    func mergeSkins(of rarity: SkinRarity) -> Bool {
        let skins = state.unlockedSkins.filter { $0.rarity == rarity }
        guard skins.count >= 3 else { return false }
        let toRemove = Array(skins.prefix(3))
        state.unlockedSkins.removeAll { s in toRemove.contains(where: { $0.id == s.id }) }
        let next = nextRarity(after: rarity)
        let skipChance = Double.random(in: 0...1) < 0.10
        let finalRarity = skipChance ? nextRarity(after: next) : next
        let newSkin = SkinFactory.randomSkin(rarity: finalRarity)
            ?? Skin(name: "\(finalRarity.displayName) Skin", rarity: finalRarity, bonusMultiplier: SkinFactory.defaultBonus(for: finalRarity))
        state.unlockedSkins.append(newSkin)
        FirebaseService.shared.logEvent("merge_skin", params: ["rarity": rarity.rawValue])
        saveNow()
        recalcDerived()
        return true
    }

    private func nextRarity(after r: SkinRarity) -> SkinRarity {
        switch r {
        case .common: return .rare
        case .rare: return .epic
        case .epic: return .legendary
        case .legendary: return .mythic
        case .mythic: return .transcendent
        case .transcendent: return .transcendent
        }
    }

    func buySkill(_ node: SkillNode) {
        guard !node.purchased else { return }
        guard state.tokens >= node.costTokens else { return }
        state.tokens -= node.costTokens
        if let idx = state.skills.firstIndex(where: { $0.id == node.id }) {
            state.skills[idx].purchased = true
        }
        saveNow()
        recalcDerived()
    }

    private func applyOfflineEarnings() {
        let now = TimeUtil.now()
        let elapsed = TimeUtil.secondsBetween(state.lastActiveAt, now)
        let capped = TimeUtil.clamp(elapsed, min: 0, max: GameConstants.offlineCapSeconds)
        let activeSkins = getActiveSkins()
        let base = incomeService.totalIncomePerSecond(state: state, dimension: dimension, activeSkins: activeSkins)
        let offlineSkillAdd = state.skills
            .filter { $0.purchased && $0.effectType == .offlineEfficiencyAdd }
            .reduce(0.0) { $0 + $1.effectValue }
        let subOffline = state.subscriptionActive ? GameConstants.subscriptionOfflineBoost : 0.0
        let offlineMult = 0.50 + offlineSkillAdd + subOffline
        let gain = base * capped * offlineMult
        if gain > 0 {
            state.coins += gain
            state.lifetimeEarnings += gain
        }
        state.lastActiveAt = now
    }

    func submitLeaderboardIfAllowed() async {
        guard !state.cheatFlagged else { return }
        await FirebaseService.shared.submitLeaderboard(
            playerName: state.playerName,
            lifetimeEarnings: state.lifetimeEarnings,
            aiLevel: state.aiLevel,
            dimension: state.currentDimensionId
        )
    }

    func submitFeedback(_ text: String) async {
        await FirebaseService.shared.submitFeedback(playerName: state.playerName, text: text)
    }

    func saveNow() {
        do { try persistence.save(state) } catch { }
    }
}
