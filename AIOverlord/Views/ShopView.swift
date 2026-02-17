import SwiftUI
import StoreKit

struct ShopView: View {
    @ObservedObject var gameVM: GameViewModel
    @ObservedObject var shopVM: ShopViewModel

    var body: some View {
        NavigationView {
            List {
                Section("Subscription") {
                    Text(shopVM.subscriptionActive ? "Active" : "Not active")
                    Text("Benefits: No forced ads, +25% income, +50% offline, 500 tokens/month")
                        .font(.caption)
                        .opacity(0.8)
                }
                Section("Products") {
                    if shopVM.isLoading {
                        ProgressView()
                    } else {
                        ForEach(shopVM.products, id: \.id) { p in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(p.displayName).font(.headline)
                                Text(p.description).font(.caption).opacity(0.8)
                                HStack {
                                    Text(p.displayPrice).bold()
                                    Spacer()
                                    Button("Buy") {
                                        Task {
                                            let ok = await shopVM.buy(p)
                                            if ok {
                                                applyTokenGrantIfNeeded(productID: p.id)
                                                gameVM.state.subscriptionActive = shopVM.subscriptionActive
                                                gameVM.saveNow()
                                            }
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            Divider()
                        }
                    }
                }
                Section("Restore") {
                    Button("Restore Purchases") { Task { await shopVM.restore() } }
                }
            }
            .navigationTitle("Shop")
            .task { await shopVM.load() }
        }
    }

    private func applyTokenGrantIfNeeded(productID: String) {
        switch productID {
        case PurchaseService.ProductID.tokensSmall: gameVM.state.tokens += 100
        case PurchaseService.ProductID.tokensMedium: gameVM.state.tokens += 500
        case PurchaseService.ProductID.tokensLarge: gameVM.state.tokens += 1200
        case PurchaseService.ProductID.tokensXL: gameVM.state.tokens += 2500
        case PurchaseService.ProductID.tokensXXL: gameVM.state.tokens += 6000
        case PurchaseService.ProductID.tokensWhale: gameVM.state.tokens += 15000
        default: break
        }
        gameVM.state.firstPurchaseMade = true
        FirebaseService.shared.logEvent("first_purchase")
    }
}
