import Foundation
import SwiftData

@Model
class ShoppingItem {
    var product: Product
    var quantity: Double
    var unitRaw: String
    var isPurchased: Bool
    
    var unit: UnitType {
        get { UnitType(rawValue: unitRaw) ?? .pieces }
        set { unitRaw = newValue.rawValue }
    }
    
    init(product: Product,
         quantity: Double = 1,
         unit: UnitType = .pieces,
         isPurchased: Bool = false) {
        self.product = product
        self.quantity = quantity
        self.unitRaw = unit.rawValue
        self.isPurchased = isPurchased
    }
}
