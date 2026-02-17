import SwiftUI

struct RootTabView: View {
    @StateObject private var gameVM = GameViewModel()
    @StateObject private var shopVM = ShopViewModel()
    @StateObject private var lbVM = LeaderboardViewModel()

    var body: some View {
        TabView {
            EmpireView(gameVM: gameVM)
                .tabItem { Label("Empire", systemImage: "eye") }
            UpgradesView(gameVM: gameVM)
                .tabItem { Label("Upgrades", systemImage: "arrow.up.circle") }
            DimensionView(gameVM: gameVM)
                .tabItem { Label("Dimensions", systemImage: "globe") }
            RewardsView(gameVM: gameVM)
                .tabItem { Label("Rewards", systemImage: "gift") }
            ShopView(gameVM: gameVM, shopVM: shopVM)
                .tabItem { Label("Shop", systemImage: "cart") }
            LeaderboardView(gameVM: gameVM, lbVM: lbVM)
                .tabItem { Label("Rank", systemImage: "trophy") }
            SettingsView(gameVM: gameVM)
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
