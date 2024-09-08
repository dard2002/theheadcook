//
//  RecipeView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 5/9/2024.
//

import SwiftUI

struct RecipeView: View {
    @Binding var recipe: Recipe
    
    var body: some View {
        VStack {
            Section {
                Text("\(recipe.name)")
                ForEach(recipe.ingredients, id: \.id) { ingredient in
                    Text("\(ingredient.name)")
                    Text("\(ingredient.quantity)")
                    Text("\(ingredient.quantityUnits)")
                }
            }
        }
    }
}
