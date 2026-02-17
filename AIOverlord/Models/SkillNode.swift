import Foundation

enum SkillPath: String, Codable, CaseIterable {
    case profit
    case meme
    case overlord

    var displayName: String {
        switch self {
        case .profit: return "Profit AI"
        case .meme: return "Meme AI"
        case .overlord: return "Overlord AI"
        }
    }
}

enum SkillEffectType: String, Codable {
    case globalIncomeAdd
    case viralChanceAdd
    case offlineEfficiencyAdd
    case ultimateUnlock
}

struct SkillNode: Identifiable, Codable, Equatable {
    var id: UUID
    var path: SkillPath
    var index: Int
    var title: String
    var description: String
    var costTokens: Int
    var purchased: Bool
    var effectType: SkillEffectType
    var effectValue: Double

    init(
        id: UUID = UUID(),
        path: SkillPath,
        index: Int,
        title: String,
        description: String,
        costTokens: Int,
        purchased: Bool = false,
        effectType: SkillEffectType,
        effectValue: Double
    ) {
        self.id = id
        self.path = path
        self.index = index
        self.title = title
        self.description = description
        self.costTokens = costTokens
        self.purchased = purchased
        self.effectType = effectType
        self.effectValue = effectValue
    }
}
