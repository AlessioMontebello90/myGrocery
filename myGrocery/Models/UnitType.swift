import Foundation

enum UnitType: String, CaseIterable, Identifiable {
    case pieces = "Pezzi"
    case grams = "Grammi"
    case kilograms = "Kilogrammi"
    
    var id: String { rawValue }
}
