import Foundation

enum SpinReward: Codable, Equatable {
    case coins(Double)
    case tokens(Int)
    case boost(multiplier: Double, seconds: Int)
    case skin(Skin)
}

protocol SpinServiceType {
    func canUseFreeSpin(state: PlayerState, now: Date) -> Bool
    func refreshFreeSpinStorage(state: inout PlayerState, now: Date)
    func spin(state: inout PlayerState, skinPool: [Skin]) -> SpinReward
}

final class SpinService: SpinServiceType {
    private let baseWeights: [(SkinRarity, Double)] = [
        (.common, 45.0),
        (.rare, 25.0),
        (.epic, 15.0),
        (.legendary, 8.0),
        (.mythic, 6.8),
        (.transcendent, 0.2),
    ]

    func canUseFreeSpin(state: PlayerState, now: Date) -> Bool {
        var s = state
        refreshFreeSpinStorage(state: &s, now: now)
        return s.storedFreeSpins > 0
    }

    func refreshFreeSpinStorage(state: inout PlayerState, now: Date) {
        let last = state.lastFreeSpinAt ?? now
        if state.lastFreeSpinAt == nil { state.lastFreeSpinAt = now }
        let elapsed = now.timeIntervalSince(last)
        guard elapsed > 0 else { return }
        let gained = Int(elapsed / GameConstants.freeSpinCooldownSeconds)
        if gained > 0 {
            state.storedFreeSpins = min(GameConstants.maxStoredFreeSpins, state.storedFreeSpins + gained)
            let advanced = last.addingTimeInterval(GameConstants.freeSpinCooldownSeconds * Double(gained))
            state.lastFreeSpinAt = advanced
        }
    }

    func spin(state: inout PlayerState, skinPool: [Skin]) -> SpinReward {
        refreshFreeSpinStorage(state: &state, now: TimeUtil.now())
        if state.storedFreeSpins > 0 { state.storedFreeSpins -= 1 }
        state.totalSpins += 1
        state.spinsSinceMythic += 1

        let rarity = pickRarityWithSoftPity(state: state)
        switch rarity {
        case .common:
            return .coins(150)
        case .rare:
            return .coins(500)
        case .epic:
            return .tokens(30)
        case .legendary:
            return .boost(multiplier: 2.0, seconds: 4 * 60 * 60)
        case .mythic:
            state.spinsSinceMythic = 0
            return .skin(pickSkin(rarity: .mythic, pool: skinPool) ?? Skin(name: "Mythic Eye", rarity: .mythic, bonusMultiplier: 0.12))
        case .transcendent:
            state.spinsSinceMythic = 0
            return .skin(pickSkin(rarity: .transcendent, pool: skinPool) ?? Skin(name: "Ascended Core", rarity: .transcendent, bonusMultiplier: 0.20))
        }
    }

    private func pickRarityWithSoftPity(state: PlayerState) -> SkinRarity {
        var weights = baseWeights
        if state.spinsSinceMythic >= GameConstants.softPityStartSpins {
            let extraSpins = state.spinsSinceMythic - GameConstants.softPityStartSpins
            let bonusFactor = 1.0 + Double(extraSpins) * GameConstants.softPityMythicBonusPerSpin
            weights = weights.map { pair in
                if pair.0 == .mythic { return (pair.0, pair.1 * bonusFactor) }
                return pair
            }
        }
        let total = weights.reduce(0.0) { $0 + $1.1 }
        let r = Double.random(in: 0..<total)
        var cum = 0.0
        for (rar, w) in weights {
            cum += w
            if r <= cum { return rar }
        }
        return .common
    }

    private func pickSkin(rarity: SkinRarity, pool: [Skin]) -> Skin? {
        let candidates = pool.filter { $0.rarity == rarity }
        return candidates.randomElement()
    }
}
