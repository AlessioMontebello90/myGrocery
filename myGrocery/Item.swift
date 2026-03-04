//
//  Item.swift
//  myGrocery
//
//  Created by ALESSIO MONTEBELLO on 04/03/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
