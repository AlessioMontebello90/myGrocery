import Foundation

enum Category: String, CaseIterable, Identifiable {
    case ortofrutta = "Ortofrutta"
    case carnePesce = "Carne & Pesce"
    case latticini = "Latticini"
    case dispensa = "Dispensa"
    case surgelati = "Surgelati"
    case bevande = "Bevande"
    case snackDolci = "Snack & Dolci"
    case casaPulizia = "Casa & Pulizia"
    case curaPersona = "Cura Persona"
    case animali = "Animali"
    case altro = "Altro"
    
    var id: String { self.rawValue }
}
