//
//  Ingredient.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

@Model
final class Ingredient: Identifiable {
    var id: Int
    var name: String
    var quantity: Int
    var quantityUnits: String
    var image: Data?
    
    init(id: Int, name: String, quantity: Int, quantityUnits: String, image: Data?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.quantityUnits = quantityUnits
        self.image = image
    }
}
