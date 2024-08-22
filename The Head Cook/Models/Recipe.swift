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
    var ingredients: [Ingredient]
    var instructions: String
    var favourite: Bool
    var imageName: String
    var mealTime: mealTimes
    
    enum mealTimes: Codable {
        case Breakfast,
        Lunch,
        Dinner
    }
    
    init(id: Int, name: String, ingredients: [Ingredient], instructions: String, favourite: Bool, imageName: String, mealTime: mealTimes) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.favourite = favourite
        self.imageName = imageName
        self.mealTime = mealTime
    }
}
