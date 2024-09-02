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
    @State private var ingredientQuantityUnits: String = "grams"
    @State private var unitsOfMeasurement: [String] = ["grams", "tablespoons", "teaspoons", "cups", "millileters"]
    @State private var showAlert: Bool = false
    @FocusState private var showKeyboard: Bool
    @Binding var showCreateIngredientView: Bool
    @Binding var currentRecipe: Recipe
    
    var body: some View {
        // Display the Create Ingredient View's core content, if this view should be displayed
        if(showCreateIngredientView) {
            VStack {
                Text("New Ingredient")
                TextField("Name", text: $ingredientName).focused($showKeyboard)
                TextField("Quantity", text: $ingredientQuantity).focused($showKeyboard)
                
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
                
                Button(action: {
                    if(!ingredientName.isEmpty && !ingredientQuantity.isEmpty && !ingredientQuantityUnits.isEmpty) {
                        addIngredient(name: ingredientName, quantity: Int(ingredientQuantity) ?? 0, quantityUnits: ingredientQuantityUnits)
                    } else {
                        // Toggle alert on if an error with the above if statement occurs
                        showAlert = true
                    }
                }, label: {(
                    Text("Create Ingredient")
                )}).alert(isPresented: $showAlert) {
                    Alert(title: (Text("Please fix the following")), message: (Text("\(ingredientName.isEmpty ? "Add an ingredient name\n" : "")\(ingredientQuantity.isEmpty ? "Add a quantity of the ingredient" : "")\(ingredientQuantityUnits.isEmpty ? "Select a unit of quantity using the dropdown" : "")")))
                }.buttonStyle(.borderedProminent).tint(.green).padding()
            }
        } else {
            // If this view should not be displayed, return back to the Select Ingredients View, with the current recipe as an argument
            SelectIngredientsView(currentRecipe: $currentRecipe)
        }
    }
    
    // Reset state and return to Select Ingredient View
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
            
            // Reset state, return to Select Ingredient View
            discard()
        } catch {
            // If the ingredient does not add properly, show the error
            print("An error has occurred whilst trying to add an ingredient: \(error)")
            
            showCreateIngredientView = false
        }
    }
}
