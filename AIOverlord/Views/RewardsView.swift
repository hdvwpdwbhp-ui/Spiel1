import SwiftUI

struct RewardsView: View {
    @ObservedObject var gameVM: GameViewModel
    @StateObject private var wheelVM = SpinWheelViewModel()
    @State private var showResult = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Free spins stored: \(gameVM.state.storedFreeSpins)")
                    .font(.headline)
                SpinWheelView()
                    .frame(height: 260)
                Button(gameVM.canSpinFree() ? "Spin" : "No Free Spin") {
                    let reward = gameVM.spinOnce(skinPool: SkinFactory.makeLaunchPool())
                    wheelVM.lastRewardText = wheelVM.describe(reward: reward)
                    if case .skin(let s) = reward { wheelVM.lastRewardRarity = s.rarity }
                    showResult = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(!gameVM.canSpinFree())
                Text(wheelVM.lastRewardText)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
            .navigationTitle("Rewards")
            .alert("Result", isPresented: $showResult) {
                Button("OK") { }
            } message: {
                Text(wheelVM.lastRewardText)
            }
        }
    }
}
