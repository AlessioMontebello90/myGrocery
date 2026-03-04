import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var items: [ShoppingItem]
    
    @State private var showAddItem = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.product.name)
                                .font(.headline)
                            
                            Text(quantityText(for: item))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button {
                            item.isPurchased.toggle()
                        } label: {
                            Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isPurchased ? .green : .gray)
                        }
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Lista Spesa")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddItemView()
            }
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            context.delete(items[index])
        }
    }
    
    private func quantityText(for item: ShoppingItem) -> String {
        switch item.unit {
        case .pieces:
            return "Quantità: \(Int(item.quantity)) pz"
        case .grams:
            return "Quantità: \(Int(item.quantity)) g"
        case .kilograms:
            return "Quantità: \(String(format: "%.2f", item.quantity)) kg"
        }
    }
}
