import Foundation
import SwiftData

@Model
class ShoppingItem {
    var product: Product
    var quantity: Int
    var isPurchased: Bool
    
    init(product: Product,
         quantity: Int = 1,
         isPurchased: Bool = false) {
        self.product = product
        self.quantity = quantity
        self.isPurchased = isPurchased
    }
}
