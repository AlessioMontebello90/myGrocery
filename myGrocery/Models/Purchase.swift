import Foundation
import SwiftData

@Model
class Purchase {
    var date: Date
    var totalAmount: Double
    
    init(date: Date = Date(),
         totalAmount: Double) {
        self.date = date
        self.totalAmount = totalAmount
    }
}
