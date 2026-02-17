import Foundation

enum GameConstants {
    static let appName = "AIOverlord"
    static let minIOSVersion = "16.0"
    static let tickInterval: TimeInterval = 1.0
    static let autosaveIntervalSeconds: Int = 10
    static let offlineCapSeconds: TimeInterval = 8 * 60 * 60
    static let startCoins: Double = 50
    static let baseGlobalMultiplier: Double = 1.0
    static let aiMultPerLevel: Double = 0.05
    static let aiBaseCost: Double = 1000
    static let aiCostGrowth: Double = 1.15
    static let prestigeDivisor: Double = 1_000_000
    static let prestigeMultPerCount: Double = 0.10
    static let maxActiveSkins = 3
    static let skinBonusCap: Double = 0.40
    static let subscriptionIncomeCap: Double = 0.25
    static let subscriptionIncomeBoost: Double = 0.25
    static let subscriptionOfflineBoost: Double = 0.50
    static let subscriptionMonthlyTokens: Int = 500
    static let freeSpinCooldownSeconds: TimeInterval = 8 * 60 * 60
    static let maxStoredFreeSpins = 3
    static let softPityStartSpins = 40
    static let softPityMythicBonusPerSpin: Double = 0.01
    static let softStuckSecondsThreshold: TimeInterval = 120
    static let maxTickIncomeFactor: Double = 10.0
    static let maxPushPerDay = 2
}
