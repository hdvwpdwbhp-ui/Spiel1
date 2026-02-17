import Foundation

@MainActor
final class SpinWheelViewModel: ObservableObject {
    @Published var lastRewardText: String = ""
    @Published var lastRewardRarity: SkinRarity? = nil

    func describe(reward: SpinReward) -> String {
        switch reward {
        case .coins(let c):
            return "+\(NumberFormat.format(c)) Coins"
        case .tokens(let t):
            return "+\(t) Tokens"
        case .boost(let m, let s):
            return "\(Int(m))x Boost for \(s/3600)h"
        case .skin(let skin):
            return "Skin: \(skin.name) (\(skin.rarity.displayName))"
        }
    }
}
