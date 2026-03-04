import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    @Query
    private var items: [ShoppingItem]
    
    @Environment(\.modelContext) private var context
    
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.product.name)
                                .font(.headline)
                            
                            Text(item.product.category.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
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
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemView()
            }
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            context.delete(items[index])
        }
    }
}
