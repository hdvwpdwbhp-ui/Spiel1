import Foundation

struct Business: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var level: Int
    var baseIncome: Double
    var baseCost: Double
    var costGrowth: Double
    var unlockRequirement: Double

    init(
        id: UUID = UUID(),
        name: String,
        level: Int = 0,
        baseIncome: Double,
        baseCost: Double,
        costGrowth: Double,
        unlockRequirement: Double
    ) {
        self.id = id
        self.name = name
        self.level = level
        self.baseIncome = baseIncome
        self.baseCost = baseCost
        self.costGrowth = costGrowth
        self.unlockRequirement = unlockRequirement
    }

    func nextCost() -> Double {
        baseCost * pow(costGrowth, Double(level))
    }

    func incomePerSecond(globalMultiplier: Double) -> Double {
        guard level > 0 else { return 0 }
        return baseIncome * Double(level) * globalMultiplier
    }
}
