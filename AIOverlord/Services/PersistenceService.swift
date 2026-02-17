import Foundation

protocol PersistenceServiceType {
    func load() throws -> PlayerState?
    func save(_ state: PlayerState) throws
}

final class PersistenceService: PersistenceServiceType {
    private let fileURL: URL

    init(filename: String = "player_state.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = dir.appendingPathComponent(filename)
    }

    func load() throws -> PlayerState? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(PlayerState.self, from: data)
    }

    func save(_ state: PlayerState) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(state)
        try data.write(to: fileURL, options: [.atomic])
    }
}
