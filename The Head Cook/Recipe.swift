//
//  Recipe.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var id: Int
    var name: String
    var ingredients: [String]
    var instructions: String
    
    init(id: Int, name: String, ingredients: [String], instructions: String) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
    }
}
