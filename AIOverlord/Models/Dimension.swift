import Foundation

struct Dimension: Identifiable, Codable, Equatable {
    var id: Int
    var name: String
    var theme: ThemeType
    var exponent: Double
    var businesses: [Business]

    init(id: Int, name: String, theme: ThemeType, exponent: Double, businesses: [Business]) {
        self.id = id
        self.name = name
        self.theme = theme
        self.exponent = exponent
        self.businesses = businesses
    }
}
