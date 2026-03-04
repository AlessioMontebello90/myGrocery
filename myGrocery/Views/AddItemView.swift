import SwiftUI
import SwiftData

struct AddItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var quantity: Double = 1
    @State private var selectedCategory: Category = .altro
    @State private var selectedUnit: UnitType = .pieces
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("Prodotto")) {
                    TextField("Nome prodotto", text: $name)
                    
                    Picker("Unità", selection: $selectedUnit) {
                        ForEach(UnitType.allCases) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    
                    if selectedUnit == .pieces {
                        Stepper("Quantità: \(Int(quantity))",
                                value: $quantity,
                                in: 1...100,
                                step: 1)
                    } else {
                        Stepper(
                            selectedUnit == .grams ?
                            "Grammi: \(Int(quantity)) g" :
                            "Kg: \(quantity, specifier: "%.2f") kg",
                            value: $quantity,
                            in: selectedUnit == .grams ? 50...5000 : 0.1...10,
                            step: selectedUnit == .grams ? 50 : 0.1
                        )
                    }
                    
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
                    Button("Annulla") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") { saveItem() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveItem() {
        let product = Product(name: name, category: selectedCategory)
        let item = ShoppingItem(product: product,
                                quantity: quantity,
                                unit: selectedUnit)
        
        context.insert(product)
        context.insert(item)
        
        dismiss()
    }
}
