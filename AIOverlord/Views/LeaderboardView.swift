import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var gameVM: GameViewModel
    @ObservedObject var lbVM: LeaderboardViewModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Submit My Score") {
                        Task { await gameVM.submitLeaderboardIfAllowed() }
                    }
                    Button("Refresh") {
                        Task { await lbVM.refresh() }
                    }
                }
                Section("Top Players") {
                    if lbVM.entries.isEmpty {
                        Text("No data yet. Add Firebase to enable global leaderboard.")
                            .font(.caption)
                            .opacity(0.8)
                    } else {
                        ForEach(Array(lbVM.entries.enumerated()), id: \.element.id) { idx, e in
                            HStack {
                                Text("#\(idx+1)").frame(width: 40, alignment: .leading)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(e.playerName).font(.headline)
                                    Text("Lifetime: \(NumberFormat.format(e.lifetimeEarnings)) | AI \(e.aiLevel)")
                                        .font(.caption).opacity(0.8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .task { await lbVM.refresh() }
        }
    }
}
