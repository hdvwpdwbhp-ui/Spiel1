import SwiftUI

struct DimensionView: View {
    @ObservedObject var gameVM: GameViewModel
    @StateObject private var dimVM = DimensionViewModel()

    var body: some View {
        NavigationView {
            List {
                Section("Current") {
                    Text("Dimension: \(dimVM.dimensionName(id: gameVM.state.currentDimensionId))")
                }
                Section("Switch") {
                    ForEach(dimVM.availableDimensions) { d in
                        Button {
                            gameVM.switchDimension(to: d.id)
                        } label: {
                            HStack {
                                Text("\(d.id). \(d.name)")
                                Spacer()
                                if d.id == gameVM.state.currentDimensionId {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dimensions")
        }
    }
}
