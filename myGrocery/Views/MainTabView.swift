import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            ShoppingListView()
                .tabItem {
                    Label("Lista", systemImage: "cart")
                }
            
            HistoryView()
                .tabItem {
                    Label("Storico", systemImage: "clock")
                }
            
            SettingsView()
                .tabItem {
                    Label("Impostazioni", systemImage: "gearshape")
                }
        }
    }
}
