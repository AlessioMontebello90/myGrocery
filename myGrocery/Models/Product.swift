import Foundation
import SwiftData

@Model
class Product {
    var name: String
    var category: String
    var barcode: String?
    var calories: Double?
    
    init(name: String,
         category: String,
         barcode: String? = nil,
         calories: Double? = nil) {
        self.name = name
        self.category = category
        self.barcode = barcode
        self.calories = calories
    }
}
