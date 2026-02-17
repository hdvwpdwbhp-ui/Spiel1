import SwiftUI

struct UpgradesView: View {
    @ObservedObject var gameVM: GameViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Skill Trees").font(.title2).bold()
                    SkillTreeView(gameVM: gameVM, path: .profit)
                    SkillTreeView(gameVM: gameVM, path: .meme)
                    SkillTreeView(gameVM: gameVM, path: .overlord)
                    Divider().padding(.vertical, 10)
                    Text("Skins").font(.title2).bold()
                    skinsSection
                }
                .padding()
            }
            .navigationTitle("Upgrades")
        }
    }

    private var skinsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Active skins max: \(GameConstants.maxActiveSkins). Tap to activate/deactivate.")
                .font(.caption)
                .opacity(0.8)
            let pool = SkinFactory.makeLaunchPool()
            Button("Grant Launch Skins (Dev)") {
                for s in pool where !gameVM.state.unlockedSkins.contains(s) {
                    gameVM.state.unlockedSkins.append(s)
                }
                gameVM.saveNow()
            }
            .buttonStyle(.bordered)
            ForEach(gameVM.state.unlockedSkins) { skin in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(skin.name)
                        Text("\(skin.rarity.displayName)  (+\(Int(skin.bonusMultiplier*100))%)")
                            .font(.caption2).opacity(0.7)
                    }
                    Spacer()
                    let isActive = gameVM.state.activeSkinIds.contains(skin.id)
                    Button(isActive ? "Active" : "Equip") {
                        gameVM.toggleSkinActive(skin)
                    }
                    .buttonStyle(.borderedProminent)
                }
                Divider()
            }
            mergeButtons
        }
    }

    private var mergeButtons: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Merge: 3x same rarity -> next tier, 10% skip chance").font(.caption).opacity(0.8)
            ForEach(SkinRarity.allCases, id: \.self) { r in
                Button("Merge \(r.displayName)") { _ = gameVM.mergeSkins(of: r) }
                    .buttonStyle(.bordered)
            }
        }
        .padding(.top, 8)
    }
}
