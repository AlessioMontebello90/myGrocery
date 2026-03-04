import Foundation
import SwiftData

@Model
class Product {
    var name: String
    var categoryRaw: String
    var barcode: String?
    var calories: Double?
    
    var category: Category {
        get { Category(rawValue: categoryRaw) ?? .altro }
        set { categoryRaw = newValue.rawValue }
    }
    
    init(name: String,
         category: Category,
         barcode: String? = nil,
         calories: Double? = nil) {
        self.name = name
        self.categoryRaw = category.rawValue
        self.barcode = barcode
        self.calories = calories
    }
}
