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
            HStack {
                Text("1").font(.title2).bold().padding().frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.2, alignment: .leading)
                Text("Add Ingredients to Recipe").frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.7, alignment: .leading)
            }
            Spacer()
            List {
                ScrollView {
                    ForEach(ingredients.sorted(by: { $0.name < $1.name } ), id: \.id) { ingredient in
                        VStack {
                            Text("\(ingredient.name)")
                            Text("\(ingredient.quantity) \(ingredient.quantityUnits)")
                            Button(action: {addIngredientToRecipe(ingredient: ingredient)}, label: {(Text("Add To Recipe"))})
                        }
                        
                        Divider()
                    }
                }
            }.frame(maxHeight: (UIScreen.main.bounds.height - 32) * 0.275)
            Spacer()
            HStack {
                Text("2").font(.title2).bold().padding().frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.2, alignment: .leading)
                Text("Confirm Ingredients in Recipe").frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.7, alignment: .leading)
            }
            Spacer()
            List {
                ScrollView {
                    ForEach(currentRecipe.ingredients.sorted(by: { $0.name < $1.name } ), id: \.id) { ingredient in
                        VStack {
                            Text("\(ingredient.name)")
                            Text("\(ingredient.quantity) \(ingredient.quantityUnits)")
                            Button(action: {removeIngredientFromRecipe(ingredient: ingredient)}, label: {(Text("Remove from Recipe"))})
                        }
                        Divider()
                    }
                }
            }.frame(maxHeight: (UIScreen.main.bounds.height - 32) * 0.275)
            
            VStack {
                    Text("New Ingredient")
                    TextField("Name", text: $ingredientName)
                    TextField("Quantity", text: $ingredientQuantity)
                
                HStack {
                    Picker("Units", selection: $ingredientQuantityUnits) {
                        ForEach(unitsOfMeasurement, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Button(action: {addIngredient(name: ingredientName, quantity: Int(ingredientQuantity) ?? 0, quantityUnits: ingredientQuantityUnits)}, label: {(
                            Text("Create")
                    )})
                }
            }
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
        // Fetch the id property from the ingredients, this is used for later to fetch the count of ingredients by id in SwiftData
        var fetchDescriptor = FetchDescriptor<Ingredient>()
        fetchDescriptor.propertiesToFetch = [\.id]
        
        do {
            // Fetch the count of ingredients by id, to determine the id (in SwiftData) of the new ingredient to be added
            let id: Int = try modelContext.fetch(fetchDescriptor).count
            
            // Add the new Ingredient with the new Id, and insert it into SwiftData
            modelContext.insert(Ingredient(id: id, name: name, quantity: quantity, quantityUnits: quantityUnits))
            
            ingredientName = ""
            ingredientQuantity = ""
            
        } catch {
            // If the ingredient does not add properly, show the error
            print("An error has occurred whilst trying to add an ingredient: \(error)")
        }
    }
}
