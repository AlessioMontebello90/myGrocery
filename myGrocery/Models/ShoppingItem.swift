import Foundation
import SwiftData

@Model
class ShoppingItem {
    var product: Product
    var quantity: Double
    var unitRaw: String
    var pricePerUnit: Double
    var isPurchased: Bool
    
    var unit: UnitType {
        get { UnitType(rawValue: unitRaw) ?? .pieces }
        set { unitRaw = newValue.rawValue }
    }
    
    var totalPrice: Double {
        quantity * pricePerUnit
    }
    
    init(product: Product,
         quantity: Double = 1,
         unit: UnitType = .pieces,
         pricePerUnit: Double = 0,
         isPurchased: Bool = false) {
        self.product = product
        self.quantity = quantity
        self.unitRaw = unit.rawValue
        self.pricePerUnit = pricePerUnit
        self.isPurchased = isPurchased
    }
}
