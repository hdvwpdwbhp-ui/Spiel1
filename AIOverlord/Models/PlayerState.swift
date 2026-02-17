import Foundation

struct PlayerState: Codable, Equatable {
    var playerName: String
    var coins: Double
    var lifetimeEarnings: Double
    var aiLevel: Int
    var prestigeCount: Int
    var tokens: Int
    var currentDimensionId: Int
    var storedFreeSpins: Int
    var lastFreeSpinAt: Date?
    var totalSpins: Int
    var spinsSinceMythic: Int
    var unlockedSkins: [Skin]
    var activeSkinIds: [UUID]
    var skills: [SkillNode]
    var firstPurchaseMade: Bool
    var subscriptionActive: Bool
    var lastActiveAt: Date
    var cheatFlagged: Bool

    static func fresh(playerName: String) -> PlayerState {
        PlayerState(
            playerName: playerName,
            coins: GameConstants.startCoins,
            lifetimeEarnings: 0,
            aiLevel: 1,
            prestigeCount: 0,
            tokens: 0,
            currentDimensionId: 1,
            storedFreeSpins: 1,
            lastFreeSpinAt: nil,
            totalSpins: 0,
            spinsSinceMythic: 0,
            unlockedSkins: [],
            activeSkinIds: [],
            skills: SkillNodeFactory.makeDefaultSkills(),
            firstPurchaseMade: false,
            subscriptionActive: false,
            lastActiveAt: TimeUtil.now(),
            cheatFlagged: false
        )
    }
}
