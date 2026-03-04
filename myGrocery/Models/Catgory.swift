import SwiftUI

enum Category: String, CaseIterable, Identifiable, Codable {
    case frutta = "Frutta"
    case verdura = "Verdura"
    case carne = "Carne"
    case pesce = "Pesce"
    case latticini = "Latticini"
    case bevande = "Bevande"
    case surgelati = "Surgelati"
    case dispensa = "Dispensa"
    case altro = "Altro"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .frutta: return .orange
        case .verdura: return .green
        case .carne: return .red
        case .pesce: return .blue
        case .latticini: return .mint
        case .bevande: return .cyan
        case .surgelati: return .indigo
        case .dispensa: return .brown
        case .altro: return .gray
        }
    }
}
