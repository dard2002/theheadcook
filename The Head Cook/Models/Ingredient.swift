//
//  Ingredient.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import Foundation
import SwiftData

@Model
final class Ingredient {
    var id: Int
    var name: String
    var quantity: Int
    var quantityUnits: String
    
    init(id: Int, name: String, quantity: Int, quantityUnits: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.quantityUnits = quantityUnits
    }
}
