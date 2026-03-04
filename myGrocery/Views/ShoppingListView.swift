import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Query
    private var items: [ShoppingItem]
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.product.name)
                                .font(.headline)
                            
                            Text("Quantità: \(item.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isPurchased ? .green : .gray)
                            .onTapGesture {
                                item.isPurchased.toggle()
                            }
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("myGougery")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addSampleItem()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func addSampleItem() {
        let product = Product(name: "Prodotto esempio", category: "Altro")
        let item = ShoppingItem(product: product)
        context.insert(product)
        context.insert(item)
    }
    
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            context.delete(items[index])
        }
    }
}
