//
//  MealPlan.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 18/8/2024.
//

import Foundation
import SwiftData

@Model
final class Day {
    var id: Int
    var name: String
    var meals: [Recipe]
    
    init(id: Int, name: String, meals: [Recipe]) {
        self.id = id
        self.name = name
        self.meals = meals
    }
}
