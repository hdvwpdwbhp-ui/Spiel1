import Foundation

protocol AntiCheatServiceType {
    func validateTick(state: PlayerState, expectedIncome: Double, actualIncome: Double) -> Bool
    func validatePrestigeGain(lifetimeEarnings: Double, gainTokens: Int) -> Bool
}

final class AntiCheatService: AntiCheatServiceType {
    func validateTick(state: PlayerState, expectedIncome: Double, actualIncome: Double) -> Bool {
        let maxAllowed = expectedIncome * GameConstants.maxTickIncomeFactor + 1
        return actualIncome <= maxAllowed
    }

    func validatePrestigeGain(lifetimeEarnings: Double, gainTokens: Int) -> Bool {
        let expected = Int(sqrt(max(0, lifetimeEarnings) / GameConstants.prestigeDivisor))
        return gainTokens >= 0 && gainTokens <= expected + 5
    }
}
