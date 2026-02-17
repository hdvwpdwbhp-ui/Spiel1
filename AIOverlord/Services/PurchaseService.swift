import Foundation
import StoreKit

final class PurchaseService: ObservableObject {
    static let shared = PurchaseService()

    @Published var subscriptionActive: Bool = false

    enum ProductID {
        static let tokensSmall = "aioverlord.tokens.small"
        static let tokensMedium = "aioverlord.tokens.medium"
        static let tokensLarge = "aioverlord.tokens.large"
        static let tokensXL = "aioverlord.tokens.xl"
        static let tokensXXL = "aioverlord.tokens.xxl"
        static let tokensWhale = "aioverlord.tokens.whale"
        static let subscriptionMonthly = "aioverlord.sub.monthly"
    }

    private init() {}

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let t) = result else { continue }
            if t.productID == ProductID.subscriptionMonthly {
                subscriptionActive = true
            }
        }
    }

    func loadProducts() async -> [Product] {
        do {
            return try await Product.products(for: [
                ProductID.tokensSmall,
                ProductID.tokensMedium,
                ProductID.tokensLarge,
                ProductID.tokensXL,
                ProductID.tokensXXL,
                ProductID.tokensWhale,
                ProductID.subscriptionMonthly
            ])
        } catch {
            return []
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                guard case .verified(let transaction) = verification else { return false }
                await transaction.finish()
                await refreshEntitlements()
                return true
            default:
                return false
            }
        } catch {
            return false
        }
    }

    func restore() async {
        _ = try? await AppStore.sync()
        await refreshEntitlements()
    }
}
