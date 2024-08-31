//
//  CreateIngredientView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 31/8/2024.
//

import SwiftUI
import SwiftData

struct CreateIngredientView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var ingredientName: String = ""
    @State private var ingredientQuantity: String = ""
    @State private var ingredientQuantityUnits: String = "g"
    @State private var unitsOfMeasurement: [String] = ["grams", "tablespoons", "teaspoons", "cups", "millileters"]
    @Binding var showCreateIngredientView: Bool
    @Binding var currentRecipe: Recipe
    
    var body: some View {
        if(showCreateIngredientView) {
            VStack {
                    Text("New Ingredient")
                    TextField("Name", text: $ingredientName)
                    TextField("Quantity", text: $ingredientQuantity)
                
                HStack {
                    Text("Units:")
                    Picker("", selection: $ingredientQuantityUnits) {
                        ForEach(unitsOfMeasurement, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Button(action: { discard() }, label: {(
                        Text("Discard (Go Back)")
                )}).buttonStyle(.borderedProminent).tint(.red).padding()
                
                Button(action: {addIngredient(name: ingredientName, quantity: Int(ingredientQuantity) ?? 0, quantityUnits: ingredientQuantityUnits)}, label: {(
                        Text("Create Ingredient")
                )}).buttonStyle(.borderedProminent).tint(.blue).padding()
            }
        } else {
            SelectIngredientsView(currentRecipe: $currentRecipe)
        }
    }
    
    private func discard() -> Void {
        ingredientName = ""
        ingredientQuantity = ""
        showCreateIngredientView = false
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
            showCreateIngredientView = false
            
        } catch {
            // If the ingredient does not add properly, show the error
            print("An error has occurred whilst trying to add an ingredient: \(error)")
            
            showCreateIngredientView = false
        }
    }
}
