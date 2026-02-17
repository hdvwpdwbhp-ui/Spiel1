import Foundation
import StoreKit

@MainActor
final class ShopViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var subscriptionActive: Bool = false
    @Published var isLoading: Bool = false
    @Published var lastError: String? = nil

    func load() async {
        isLoading = true
        defer { isLoading = false }
        await PurchaseService.shared.refreshEntitlements()
        subscriptionActive = PurchaseService.shared.subscriptionActive
        products = await PurchaseService.shared.loadProducts()
    }

    func buy(_ product: Product) async -> Bool {
        let ok = await PurchaseService.shared.purchase(product)
        subscriptionActive = PurchaseService.shared.subscriptionActive
        return ok
    }

    func restore() async {
        await PurchaseService.shared.restore()
        subscriptionActive = PurchaseService.shared.subscriptionActive
    }
}
