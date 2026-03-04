import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var items: [ShoppingItem]
    
    @State private var showAddItem = false
    @State private var showPurchased = true
    
    private var notPurchasedItems: [ShoppingItem] {
        items.filter { !$0.isPurchased }
    }
    
    private var purchasedItems: [ShoppingItem] {
        items.filter { $0.isPurchased }
    }
    
    private var totalAmount: Double {
        purchasedItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        if items.isEmpty {
                            emptyState
                        } else {
                            
                            // MARK: - Da comprare
                            
                            if !notPurchasedItems.isEmpty {
                                sectionHeader(title: "Da comprare", systemImage: "cart")
                                
                                ForEach(notPurchasedItems) { item in
                                    itemCard(for: item)
                                }
                            }
                            
                            // MARK: - Acquistati
                            
                            if !purchasedItems.isEmpty {
                                
                                Button {
                                    withAnimation {
                                        showPurchased.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Label("Acquistati", systemImage: "checkmark.circle")
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        Image(systemName: showPurchased ? "chevron.up" : "chevron.down")
                                    }
                                }
                                .padding(.top, 8)
                                
                                if showPurchased {
                                    ForEach(purchasedItems) { item in
                                        itemCard(for: item)
                                    }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                    }
                    .padding()
                }
                
                // MARK: - Totale fisso
                
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
    
    // MARK: - Sezione Header
    
    private func sectionHeader(title: String, systemImage: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.headline)
            Spacer()
        }
    }
    
    // MARK: - Card
    
    private func itemCard(for item: ShoppingItem) -> some View {
        let categoryColor = item.product.category.color
        
        return HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(item.product.name)
                    .font(.headline)
                
                Text(quantityText(for: item))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Badge dinamico
                Text(item.product.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor.opacity(0.15))
                    .foregroundColor(categoryColor)
                    .cornerRadius(8)
                
                if item.pricePerUnit > 0 {
                    Text("€ \(item.totalPrice, specifier: "%.2f")")
                        .font(.subheadline.bold())
                        .foregroundColor(.green)
                }
            }
            .opacity(item.isPurchased ? 0.5 : 1.0)
            
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
    
    // MARK: - Empty State
    
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
    
    // MARK: - Helpers
    
    private func quantityText(for item: ShoppingItem) -> String {
        switch item.unit {
        case .pieces:
            return "Quantità: \(Int(item.quantity)) pz"
        case .grams:
            return "Quantità: \(Int(item.quantity)) g"
        case .kilograms:
            return "Quantità: \(String(format: "%.1f", item.quantity)) kg"
        }
    }
}
