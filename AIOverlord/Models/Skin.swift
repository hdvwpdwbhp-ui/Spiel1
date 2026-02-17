import Foundation

enum SkinRarity: String, Codable, CaseIterable {
    case common, rare, epic, legendary, mythic, transcendent

    var displayName: String {
        switch self {
        case .common: return "Common"
        case .rare: return "Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        case .mythic: return "Mythic"
        case .transcendent: return "Transcendent"
        }
    }
}

struct Skin: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var rarity: SkinRarity
    var bonusMultiplier: Double

    init(id: UUID = UUID(), name: String, rarity: SkinRarity, bonusMultiplier: Double) {
        self.id = id
        self.name = name
        self.rarity = rarity
        self.bonusMultiplier = bonusMultiplier
    }
}
