//
//  CreateRecipeView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import SwiftUI
import SwiftData

struct CreateRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var recipeName: String = ""
    @State private var showIngredientsSection: Bool = false
    @State private var currentRecipe: Recipe = Recipe(id: 0, name: "", ingredients: [], instructions: "", favourite: false, imageName: "", mealTime: Recipe.mealTimes.Dinner)
    
    var body: some View {
        VStack(alignment: .center) {
            Text("First, let's name your recipe:")
            TextField("Name your recipe here!", text: $recipeName)
            
            Button(action: { createInitialRecipe(); showIngredientsSection = true }, label: {
                Text("Next")
            })
            
            showIngredientsSection ? SelectIngredientsView(currentRecipe: $currentRecipe) : nil
        }
    }
    
    private func createInitialRecipe() -> Void {
        var fetchDescriptor = FetchDescriptor<Recipe>()
        fetchDescriptor.propertiesToFetch = [\.id]
        
        do {
            let id: Int = try modelContext.fetch(fetchDescriptor).count
            modelContext.insert(Recipe(id: id, name: recipeName, ingredients: [], instructions: "", favourite: false, imageName: "", mealTime: Recipe.mealTimes.Dinner))
        } catch {
            print("An error has occured whilst trying to add a recipe.")
        }
    }
}
