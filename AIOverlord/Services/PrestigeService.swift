import Foundation

protocol PrestigeServiceType {
    func prestigeGain(lifetimeEarnings: Double) -> Int
    func performPrestige(state: inout PlayerState, dimension: inout Dimension)
}

final class PrestigeService: PrestigeServiceType {
    func prestigeGain(lifetimeEarnings: Double) -> Int {
        let gain = sqrt(max(0, lifetimeEarnings) / GameConstants.prestigeDivisor)
        return max(0, Int(gain.rounded(.down)))
    }

    func performPrestige(state: inout PlayerState, dimension: inout Dimension) {
        let gainTokens = prestigeGain(lifetimeEarnings: state.lifetimeEarnings)
        state.tokens += gainTokens
        state.prestigeCount += 1
        state.coins = GameConstants.startCoins
        dimension.businesses = dimension.businesses.map { biz in
            var b = biz
            b.level = 0
            return b
        }
        state.spinsSinceMythic = 0
    }
}
