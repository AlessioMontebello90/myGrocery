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
            ZStack {
                
              
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    
                    if items.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(items) { item in
                                    itemCard(for: item)
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                
                VStack {
                    Spacer()
                    
                    if totalAmount > 0 {
                        HStack {
                            Text("Totale")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("€ \(totalAmount, specifier: "%.2f")")
                                .font(.title2.bold())
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                    }
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
    
    
    
    private func itemCard(for item: ShoppingItem) -> some View {
        HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(item.product.name)
                    .font(.headline)
                
                Text(quantityText(for: item))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if item.pricePerUnit > 0 {
                    Text("€ \(item.totalPrice, specifier: "%.2f")")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    item.isPurchased.toggle()
                }
            } label: {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isPurchased ? .green : .gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    
    
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "cart")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.4))
            
            Text("Nessun prodotto")
                .foregroundColor(.secondary)
            
            Text("Aggiungi il primo articolo")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.top, 80)
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
