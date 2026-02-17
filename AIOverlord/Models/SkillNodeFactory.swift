import Foundation

enum SkillNodeFactory {
    static func makeDefaultSkills() -> [SkillNode] {
        var nodes: [SkillNode] = []
        for path in SkillPath.allCases {
            for idx in 1...20 {
                let baseCost = 20 + idx * 10
                let title = "\(path.displayName) \(idx)"
                let desc = "Upgrade \(idx) for \(path.displayName)."
                let effect: SkillEffectType
                let value: Double
                if idx == 20 {
                    effect = .ultimateUnlock
                    value = 1
                } else {
                    switch path {
                    case .profit:
                        effect = .globalIncomeAdd
                        value = 0.01
                    case .meme:
                        effect = .viralChanceAdd
                        value = 0.005
                    case .overlord:
                        effect = .offlineEfficiencyAdd
                        value = 0.01
                    }
                }
                nodes.append(
                    SkillNode(
                        path: path,
                        index: idx,
                        title: title,
                        description: desc,
                        costTokens: baseCost,
                        purchased: false,
                        effectType: effect,
                        effectValue: value
                    )
                )
            }
        }
        return nodes
    }
}
