import SwiftUI

struct BusinessRowView: View {
    let business: Business
    let coins: Double
    let globalIncomePerSec: Double
    let onBuy: () -> Void

    var body: some View {
        let cost = business.nextCost()
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(business.name).font(.headline)
                Text("Level \(business.level)").font(.caption).opacity(0.8)
                Text("Cost: \(NumberFormat.format(cost))").font(.caption2).opacity(0.7)
            }
            Spacer()
            Button("Buy") { onBuy() }
                .buttonStyle(.borderedProminent)
                .disabled(coins < cost)
        }
        .padding(.vertical, 6)
    }
}
