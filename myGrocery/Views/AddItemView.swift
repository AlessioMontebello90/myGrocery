import SwiftUI
import SwiftData

struct AddItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var quantity: Double = 1
    @State private var selectedUnit: UnitType = .pieces
    @State private var pricePerUnit: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        productSection
                        quantitySection
                        priceSection
                        saveButton
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("Nuovo Prodotto")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Sezioni
    
    private var productSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Prodotto")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("Nome prodotto", text: $name)
                .padding()
                .background(cardBackground)
        }
    }
    
    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Quantità")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 16) {
                
                Picker("Unità", selection: $selectedUnit) {
                    ForEach(UnitType.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedUnit) { _, newValue in
                    switch newValue {
                    case .pieces:
                        quantity = 1
                    case .grams:
                        quantity = 100
                    case .kilograms:
                        quantity = 1.0
                    }
                }
                
                HStack {
                    Button {
                        decreaseQuantity()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Text(quantityText)
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    Button {
                        increaseQuantity()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(cardBackground)
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Prezzo per unità")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("€")
                    .foregroundColor(.secondary)
                
                TextField("0.00", value: $pricePerUnit, format: .number)
                    .keyboardType(.decimalPad)
            }
            .padding()
            .background(cardBackground)
        }
    }
    
    private var saveButton: some View {
        Button {
            saveItem()
        } label: {
            Text("Aggiungi alla lista")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(name.isEmpty ? Color.gray : Color.green)
                .cornerRadius(16)
        }
        .disabled(name.isEmpty)
        .padding(.top, 10)
    }
    
    // MARK: - Helpers
    
    private var quantityText: String {
        switch selectedUnit {
        case .pieces:
            return "\(Int(quantity)) pz"
        case .grams:
            return "\(Int(quantity)) g"
        case .kilograms:
            return "\(String(format: "%.1f", quantity)) kg"
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func increaseQuantity() {
        switch selectedUnit {
        case .pieces:
            quantity += 1
        case .grams:
            quantity += 100
        case .kilograms:
            quantity += 0.5
        }
    }
    
    private func decreaseQuantity() {
        switch selectedUnit {
        case .pieces:
            if quantity > 1 { quantity -= 1 }
        case .grams:
            if quantity > 100 { quantity -= 100 }
        case .kilograms:
            if quantity > 0.5 { quantity -= 0.5 }
        }
    }
    
    private func saveItem() {
        let product = Product(name: name, category: .altro)
        
        let newItem = ShoppingItem(
            product: product,
            quantity: quantity,
            unit: selectedUnit,
            pricePerUnit: pricePerUnit
        )
        
        context.insert(newItem)
        dismiss()
    }
}
