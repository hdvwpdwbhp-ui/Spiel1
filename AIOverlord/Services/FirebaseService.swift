import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif

final class FirebaseService {
    static let shared = FirebaseService()
    private init() {}

    func configureIfAvailable() {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
        #endif
    }

    func logEvent(_ name: String, params: [String: Any]? = nil) {
        #if canImport(FirebaseAnalytics)
        Analytics.logEvent(name, parameters: params)
        #endif
    }

    struct LeaderboardEntry: Identifiable {
        let id: String
        let playerName: String
        let lifetimeEarnings: Double
        let aiLevel: Int
        let updatedAt: Date
    }

    func submitLeaderboard(playerName: String, lifetimeEarnings: Double, aiLevel: Int, dimension: Int) async {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "playerName": playerName,
            "lifetimeEarnings": lifetimeEarnings,
            "aiLevel": aiLevel,
            "dimension": dimension,
            "updatedAt": Date()
        ]
        do {
            try await db.collection("leaderboard").document(playerName).setData(data, merge: true)
        } catch { }
        #endif
    }

    func fetchTopLeaderboard(limit: Int = 50) async -> [LeaderboardEntry] {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        do {
            let snap = try await db.collection("leaderboard")
                .order(by: "lifetimeEarnings", descending: true)
                .limit(to: limit)
                .getDocuments()
            return snap.documents.compactMap { doc in
                let d = doc.data()
                let name = (d["playerName"] as? String) ?? doc.documentID
                let lifetime = (d["lifetimeEarnings"] as? Double) ?? 0
                let ai = (d["aiLevel"] as? Int) ?? 1
                let date = (d["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                return LeaderboardEntry(id: doc.documentID, playerName: name, lifetimeEarnings: lifetime, aiLevel: ai, updatedAt: date)
            }
        } catch {
            return []
        }
        #else
        return []
        #endif
    }

    func submitFeedback(playerName: String, text: String) async {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "playerName": playerName,
            "text": text,
            "createdAt": Date()
        ]
        do { try await db.collection("feedback").addDocument(data: data) } catch { }
        #endif
    }
}
