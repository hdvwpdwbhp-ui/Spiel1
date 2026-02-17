import SwiftUI

struct SkillTreeView: View {
    @ObservedObject var gameVM: GameViewModel
    let path: SkillPath

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(path.displayName).font(.headline)
            let nodes = gameVM.state.skills
                .filter { $0.path == path }
                .sorted { $0.index < $1.index }
            ForEach(nodes) { node in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(node.title).font(.subheadline)
                        Text(node.description).font(.caption2).opacity(0.7)
                    }
                    Spacer()
                    if node.purchased {
                        Text("Owned").font(.caption).opacity(0.8)
                    } else {
                        Button("\(node.costTokens) T") { gameVM.buySkill(node) }
                            .buttonStyle(.borderedProminent)
                            .disabled(gameVM.state.tokens < node.costTokens)
                    }
                }
                Divider()
            }
        }
        .padding(12)
        .background(.thinMaterial)
        .cornerRadius(16)
    }
}
