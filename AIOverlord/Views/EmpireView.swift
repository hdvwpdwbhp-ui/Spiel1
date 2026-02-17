import SwiftUI

struct EmpireView: View {
    @ObservedObject var gameVM: GameViewModel

    var theme: Theme { Theme(type: gameVM.dimension.theme) }

    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                VStack(spacing: 12) {
                    VStack(spacing: 6) {
                        Text("Coins: \(NumberFormat.format(gameVM.state.coins))").font(.headline)
                        Text("Income/s: \(NumberFormat.format(gameVM.incomePerSecond))").font(.subheadline).opacity(0.8)
                        Text("Tokens: \(gameVM.state.tokens)  |  AI Lv \(gameVM.state.aiLevel)").font(.caption).opacity(0.7)
                    }
                    SingularityEyeView(theme: theme, aiLevel: gameVM.state.aiLevel, prestige: gameVM.state.prestigeCount)
                        .frame(height: 180)
                    HStack(spacing: 12) {
                        Button {
                            gameVM.buyAILevel()
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Upgrade AI").font(.headline)
                                Text("Cost: \(NumberFormat.format(gameVM.aiNextCost()))").font(.caption)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(.thinMaterial)
                            .cornerRadius(12)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Lifetime").font(.headline)
                            Text(NumberFormat.format(gameVM.state.lifetimeEarnings)).font(.caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    List {
                        ForEach(gameVM.dimension.businesses) { biz in
                            BusinessRowView(
                                business: biz,
                                coins: gameVM.state.coins,
                                globalIncomePerSec: gameVM.incomePerSecond,
                                onBuy: { gameVM.buyBusinessLevel(businessId: biz.id) }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.top, 8)
            }
            .navigationTitle("AI Overlord")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Prestige") { gameVM.prestige() }
                }
            }
            .alert("Offer", isPresented: $gameVM.showSoftStuckOffer) {
                Button("OK") { gameVM.showSoftStuckOffer = false }
            } message: {
                Text("Singularity instability detected... a boost might help.")
            }
        }
    }
}
