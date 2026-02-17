import Foundation

@MainActor
final class DimensionViewModel: ObservableObject {
    @Published private(set) var availableDimensions: [Dimension] = [
        DimensionFactory.makeDimension(id: 1),
        DimensionFactory.makeDimension(id: 2),
        DimensionFactory.makeDimension(id: 3),
        DimensionFactory.makeDimension(id: 4),
        DimensionFactory.makeDimension(id: 5),
    ]

    func dimensionName(id: Int) -> String {
        availableDimensions.first(where: { $0.id == id })?.name ?? "Unknown"
    }
}
