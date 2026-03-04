import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var items: [ShoppingItem]
    
    @State private var showAddItem = false

    private var totalAmount: Double {
    items
        .filter { $0.isPurchased }
        .reduce(0) { $0 + $1.totalPrice }
}

    
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
                
                if item.pricePerUnit > 0 {
                    Text("€ \(item.totalPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button {
                item.isPurchased.toggle()
            } label: {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isPurchased ? .green : .gray)
                    .font(.title3)
            }
        }
        .padding(.vertical, 4)
    }
    .onDelete(perform: deleteItem)
    
    if totalAmount > 0 {
        HStack {
            Text("Totale")
                .font(.headline)
            Spacer()
            Text("€ \(totalAmount, specifier: "%.2f")")
                .font(.title3.bold())
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
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
