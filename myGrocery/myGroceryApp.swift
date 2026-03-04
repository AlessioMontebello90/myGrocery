import SwiftUI
import SwiftData

@main
struct myGroceryApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Product.self,
            ShoppingItem.self,
            Purchase.self
        ])
        
        let configuration = ModelConfiguration(schema: schema)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Errore creazione ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
