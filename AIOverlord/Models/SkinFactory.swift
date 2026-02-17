import Foundation

enum SkinFactory {
    static func defaultBonus(for rarity: SkinRarity) -> Double {
        switch rarity {
        case .common: return 0.02
        case .rare: return 0.03
        case .epic: return 0.05
        case .legendary: return 0.08
        case .mythic: return 0.12
        case .transcendent: return 0.20
        }
    }

    static func randomSkin(rarity: SkinRarity) -> Skin? {
        let pool = makeLaunchPool().filter { $0.rarity == rarity }
        return pool.randomElement()
    }

    static func makeLaunchPool() -> [Skin] {
        [
            Skin(name: "Friendly Glitch", rarity: .common, bonusMultiplier: 0.02),
            Skin(name: "Bright Lens", rarity: .common, bonusMultiplier: 0.02),
            Skin(name: "Data Smirk", rarity: .common, bonusMultiplier: 0.02),
            Skin(name: "Servo Wink", rarity: .common, bonusMultiplier: 0.02),
            Skin(name: "Pixel Pupil", rarity: .common, bonusMultiplier: 0.02),
            Skin(name: "Neural Grin", rarity: .rare, bonusMultiplier: 0.03),
            Skin(name: "Overclock Aura", rarity: .rare, bonusMultiplier: 0.03),
            Skin(name: "Meme Magnet", rarity: .rare, bonusMultiplier: 0.03),
            Skin(name: "Signal Hunter", rarity: .rare, bonusMultiplier: 0.03),
            Skin(name: "Sly Operator", rarity: .rare, bonusMultiplier: 0.03),
            Skin(name: "Dark Protocol", rarity: .epic, bonusMultiplier: 0.05),
            Skin(name: "Quantum Blink", rarity: .epic, bonusMultiplier: 0.05),
            Skin(name: "Viral Architect", rarity: .epic, bonusMultiplier: 0.05),
            Skin(name: "Shadow Router", rarity: .epic, bonusMultiplier: 0.05),
            Skin(name: "Neon Overlord", rarity: .legendary, bonusMultiplier: 0.08),
            Skin(name: "Void Observer", rarity: .legendary, bonusMultiplier: 0.08),
            Skin(name: "Reality Hacker", rarity: .legendary, bonusMultiplier: 0.08),
            Skin(name: "Multiverse Eye", rarity: .mythic, bonusMultiplier: 0.12),
            Skin(name: "Planet Binder", rarity: .mythic, bonusMultiplier: 0.12),
            Skin(name: "Ascended Core", rarity: .transcendent, bonusMultiplier: 0.20),
        ]
    }
}
