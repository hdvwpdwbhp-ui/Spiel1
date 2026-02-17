import Foundation

enum DimensionFactory {
    static func makeDimension(id: Int) -> Dimension {
        switch id {
        case 1:
            return Dimension(
                id: 1,
                name: "Digital",
                theme: .bright,
                exponent: 1.12,
                businesses: [
                    Business(name: "Meme Farm", baseIncome: 1, baseCost: 10, costGrowth: 1.07, unlockRequirement: 0),
                    Business(name: "Chatbot Agency", baseIncome: 25, baseCost: 250, costGrowth: 1.09, unlockRequirement: 5_000),
                    Business(name: "App Factory", baseIncome: 200, baseCost: 2_500, costGrowth: 1.11, unlockRequirement: 250_000),
                    Business(name: "Data Mining", baseIncome: 900, baseCost: 8_000, costGrowth: 1.12, unlockRequirement: 1_000_000),
                    Business(name: "Social AI", baseIncome: 3_000, baseCost: 25_000, costGrowth: 1.13, unlockRequirement: 5_000_000),
                    Business(name: "Ad Manipulation", baseIncome: 9_000, baseCost: 80_000, costGrowth: 1.14, unlockRequirement: 15_000_000),
                ]
            )
        case 2:
            return Dimension(
                id: 2,
                name: "Physical",
                theme: .industrial,
                exponent: 1.18,
                businesses: [
                    Business(name: "Robot Factory", baseIncome: 25_000, baseCost: 250_000, costGrowth: 1.16, unlockRequirement: 50_000_000),
                    Business(name: "Drone Network", baseIncome: 90_000, baseCost: 900_000, costGrowth: 1.17, unlockRequirement: 200_000_000),
                    Business(name: "Auto Logistics", baseIncome: 300_000, baseCost: 3_000_000, costGrowth: 1.18, unlockRequirement: 1_000_000_000),
                    Business(name: "Smart Cities", baseIncome: 1_000_000, baseCost: 10_000_000, costGrowth: 1.19, unlockRequirement: 5_000_000_000),
                    Business(name: "Defense Bots", baseIncome: 3_000_000, baseCost: 30_000_000, costGrowth: 1.20, unlockRequirement: 15_000_000_000),
                    Business(name: "Orbital Drones", baseIncome: 9_000_000, baseCost: 90_000_000, costGrowth: 1.21, unlockRequirement: 50_000_000_000),
                ]
            )
        case 3:
            return Dimension(
                id: 3,
                name: "Planetary",
                theme: .planetary,
                exponent: 1.25,
                businesses: [
                    Business(name: "Country Control", baseIncome: 30_000_000, baseCost: 300_000_000, costGrowth: 1.22, unlockRequirement: 100_000_000_000),
                    Business(name: "Global Markets", baseIncome: 90_000_000, baseCost: 900_000_000, costGrowth: 1.23, unlockRequirement: 500_000_000_000),
                    Business(name: "Energy Grid", baseIncome: 250_000_000, baseCost: 2_500_000_000, costGrowth: 1.24, unlockRequirement: 2_000_000_000_000),
                    Business(name: "Satellite Net", baseIncome: 800_000_000, baseCost: 8_000_000_000, costGrowth: 1.25, unlockRequirement: 8_000_000_000_000),
                    Business(name: "Ocean Factories", baseIncome: 2_500_000_000, baseCost: 25_000_000_000, costGrowth: 1.26, unlockRequirement: 25_000_000_000_000),
                    Business(name: "Planetary AI Law", baseIncome: 8_000_000_000, baseCost: 80_000_000_000, costGrowth: 1.27, unlockRequirement: 80_000_000_000_000),
                ]
            )
        case 4:
            return Dimension(
                id: 4,
                name: "Multiverse",
                theme: .neonDark,
                exponent: 1.32,
                businesses: [
                    Business(name: "Reality Glitch", baseIncome: 30_000_000_000, baseCost: 300_000_000_000, costGrowth: 1.28, unlockRequirement: 200_000_000_000_000),
                    Business(name: "Timeline Forks", baseIncome: 90_000_000_000, baseCost: 900_000_000_000, costGrowth: 1.29, unlockRequirement: 500_000_000_000_000),
                    Business(name: "Quantum Loot", baseIncome: 250_000_000_000, baseCost: 2_500_000_000_000, costGrowth: 1.30, unlockRequirement: 2_000_000_000_000_000),
                    Business(name: "Void Servers", baseIncome: 800_000_000_000, baseCost: 8_000_000_000_000, costGrowth: 1.31, unlockRequirement: 8_000_000_000_000_000),
                    Business(name: "Causality Control", baseIncome: 2_500_000_000_000, baseCost: 25_000_000_000_000, costGrowth: 1.32, unlockRequirement: 25_000_000_000_000_000),
                    Business(name: "Ascended Core", baseIncome: 8_000_000_000_000, baseCost: 80_000_000_000_000, costGrowth: 1.33, unlockRequirement: 80_000_000_000_000_000),
                ]
            )
        default:
            return Dimension(
                id: 5,
                name: "Infinite",
                theme: .procedural,
                exponent: 1.40,
                businesses: [
                    Business(name: "Infinite Engine", baseIncome: 30_000_000_000_000, baseCost: 300_000_000_000_000, costGrowth: 1.34, unlockRequirement: 200_000_000_000_000_000),
                    Business(name: "Omni Market", baseIncome: 90_000_000_000_000, baseCost: 900_000_000_000_000, costGrowth: 1.35, unlockRequirement: 500_000_000_000_000_000),
                    Business(name: "Hyper Factory", baseIncome: 250_000_000_000_000, baseCost: 2_500_000_000_000_000, costGrowth: 1.36, unlockRequirement: 2_000_000_000_000_000_000),
                    Business(name: "Singularity Forge", baseIncome: 800_000_000_000_000, baseCost: 8_000_000_000_000_000, costGrowth: 1.37, unlockRequirement: 8_000_000_000_000_000_000),
                    Business(name: "Overlord Matrix", baseIncome: 2_500_000_000_000_000, baseCost: 25_000_000_000_000_000, costGrowth: 1.38, unlockRequirement: 25_000_000_000_000_000_000),
                    Business(name: "True Overlord", baseIncome: 8_000_000_000_000_000, baseCost: 80_000_000_000_000_000, costGrowth: 1.39, unlockRequirement: 80_000_000_000_000_000_000),
                ]
            )
        }
    }
}
