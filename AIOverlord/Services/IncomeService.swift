import Foundation

protocol IncomeServiceType {
    func globalMultiplier(state: PlayerState, dimension: Dimension, activeSkins: [Skin]) -> Double
    func totalIncomePerSecond(state: PlayerState, dimension: Dimension, activeSkins: [Skin]) -> Double
    func secondsToNextCheapestUpgrade(state: PlayerState, dimension: Dimension) -> TimeInterval?
}

final class IncomeService: IncomeServiceType {
    func globalMultiplier(state: PlayerState, dimension: Dimension, activeSkins: [Skin]) -> Double {
        let base = GameConstants.baseGlobalMultiplier
        let aiMult = 1.0 + Double(state.aiLevel) * GameConstants.aiMultPerLevel
        let prestigeMult = 1.0 + Double(state.prestigeCount) * GameConstants.prestigeMultPerCount
        let dimensionMult = 1.0 + (dimension.exponent - 1.0) * 0.5
        let skinAdd = activeSkins.reduce(0.0) { $0 + $1.bonusMultiplier }
        let skinCapped = min(GameConstants.skinBonusCap, skinAdd)
        let skinMult = 1.0 + skinCapped
        let skillAddGlobal = state.skills
            .filter { $0.purchased && $0.effectType == .globalIncomeAdd }
            .reduce(0.0) { $0 + $1.effectValue }
        let skillsMult = 1.0 + skillAddGlobal
        let subMult = 1.0 + (state.subscriptionActive ? GameConstants.subscriptionIncomeBoost : 0.0)
        return base * aiMult * prestigeMult * dimensionMult * skinMult * skillsMult * subMult
    }

    func totalIncomePerSecond(state: PlayerState, dimension: Dimension, activeSkins: [Skin]) -> Double {
        let g = globalMultiplier(state: state, dimension: dimension, activeSkins: activeSkins)
        return dimension.businesses.reduce(0.0) { partial, biz in
            partial + biz.incomePerSecond(globalMultiplier: g)
        }
    }

    func secondsToNextCheapestUpgrade(state: PlayerState, dimension: Dimension) -> TimeInterval? {
        let costs = dimension.businesses.map { $0.nextCost() }.filter { $0 > 0 }
        guard let cheapest = costs.min() else { return nil }
        let income = max(0.0001, totalIncomePerSecond(state: state, dimension: dimension, activeSkins: []))
        let missing = max(0, cheapest - state.coins)
        return missing / income
    }
}
