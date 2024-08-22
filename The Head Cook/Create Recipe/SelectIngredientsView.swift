//
//  SelectIngredientsView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import SwiftUI
import SwiftData

struct SelectIngredientsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var ingredients: [Ingredient]
    @State private var ingredientName: String = ""
    @State private var ingredientQuantity: String = ""
    @State private var ingredientQuantityUnits: String = "g"
    @State private var recipeIngredients: [Ingredient] = []
    @State private var unitsOfMeasurement: [String] = ["grams", "tablespoons", "teaspoons", "cups", "millileters"]
    @Binding var currentRecipe: Recipe
    
    var body: some View {
        VStack {
            Text("Now, let's pick some ingredients!\nIngredients to select from:")
            Spacer()
            List {
                ScrollView {
                    ForEach(ingredients, id: \.id) { ingredient in
                        Text("\(ingredient.name)")
                        Text("Quantity: \(ingredient.quantity) \(ingredient.quantityUnits)")
                        Button(action: {addIngredientToRecipe(ingredient: ingredient)}, label: {(Text("Add To Recipe"))})
                    }
                }
                
            }
            
            Text("Ingredients in the recipe:")
            Spacer()
            List {
                ScrollView {
                    ForEach(currentRecipe.ingredients, id: \.id) { ingredient in
                        Text("\(ingredient.name)")
                        Text("Quantity: \(ingredient.quantity) \(ingredient.quantityUnits)")
                        Button(action: {removeIngredientFromRecipe(ingredient: ingredient)}, label: {(Text("Remove from Recipe"))})
                    }
                }
            }
            
            Text("Add a new ingredient:")
            Spacer()
            TextField("Ingredient Name", text: $ingredientName)
            TextField("Ingredient Quantity", text: $ingredientQuantity)
            Picker("Ingredient Quantity Measurement", selection: $ingredientQuantityUnits) {
                ForEach(unitsOfMeasurement, id: \.self) {
                    Text($0)
                }
            }
            Button(action: {addIngredient(name: ingredientName, quantity: Int(ingredientQuantity) ?? 0, quantityUnits: ingredientQuantityUnits)}, label: {(
                Text("New Ingredient")
            )})
        }
    }
    
    private func addIngredientToRecipe(ingredient: Ingredient) -> Void {
        if(currentRecipe.ingredients.contains(ingredient)) {
            print("Current recipe already contains ingredient. Continuing...")
        } else {
            currentRecipe.ingredients.append(ingredient)
        }
    }
    
    private func removeIngredientFromRecipe(ingredient: Ingredient) -> Void {
        currentRecipe.ingredients.removeAll() {
            $0.name == ingredient.name &&
            $0.quantity == ingredient.quantity &&
            $0.quantityUnits == ingredient.quantityUnits
        }
    }
    
    private func addIngredient(name: String, quantity: Int, quantityUnits: String) -> Void {
        withAnimation {
            var fetchDescriptor = FetchDescriptor<Ingredient>()
            fetchDescriptor.propertiesToFetch = [\.id]
            
            do {
                let id: Int = try modelContext.fetch(fetchDescriptor).count
                modelContext.insert(Ingredient(id: id, name: name, quantity: quantity, quantityUnits: quantityUnits))

            } catch {
                print("An error has occured whilst trying to add an ingredient.")
            }
        }
    }
}
