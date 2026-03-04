import SwiftUI
import SwiftData

struct AddItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var quantity: Int = 1
    @State private var selectedCategory: Category = .altro
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("Prodotto")) {
                    TextField("Nome prodotto", text: $name)
                    
                    Stepper("Quantità: \(quantity)", value: $quantity, in: 1...50)
                    
                    Picker("Categoria", selection: $selectedCategory) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
            }
            .navigationTitle("Nuovo Prodotto")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") {
                        saveItem()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveItem() {
        let product = Product(name: name, category: selectedCategory)
        let item = ShoppingItem(product: product, quantity: quantity)
        
        context.insert(product)
        context.insert(item)
        
        dismiss()
    }
}
