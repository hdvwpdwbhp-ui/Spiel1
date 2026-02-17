import Foundation

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published var entries: [FirebaseService.LeaderboardEntry] = []
    @Published var isLoading: Bool = false

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        entries = await FirebaseService.shared.fetchTopLeaderboard(limit: 50)
    }
}
