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
    @State private var showInstructionsSection: Bool = false
    @State private var ingredientName: String = ""
    @State private var ingredientQuantity: String = "0"
    @State private var ingredientQuantityUnits: String = "g"
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Now, let's pick some ingredients!")
            Text("\nIngredients to select from:")
            
            List {
                ForEach(ingredients, id: \.id) { ingredient in
                    Text("\(ingredient.name)")
                    Text("\(ingredient.quantity) \(ingredient.quantityUnits)")
                }
            }
            
            Text("Add a new ingredient:")
            TextField("Ingredient Name", text: $ingredientName)
            TextField("Ingredient Quantity", text: $ingredientQuantity)
            TextField("Ingredient Quantity's Unit of Measurement", text: $ingredientQuantityUnits)
            
            Button(action: {addIngredient(name: ingredientName, quantity: Int(ingredientQuantity) ?? 0, quantityUnits: ingredientQuantityUnits)}, label: {(
                Text("New Ingredient")
            )})
        }
    }
    
    private func addIngredient(name: String, quantity: Int, quantityUnits: String) -> Void {
        var fetchDescriptor = FetchDescriptor<Ingredient>()
        fetchDescriptor.propertiesToFetch = [\.id]
        
        do {
            let id: Int = try modelContext.fetch(fetchDescriptor).count
            modelContext.insert(Ingredient(id: id+1, name: name, quantity: quantity, quantityUnits: quantityUnits))
        } catch {
            print("An error has occured whilst trying to add an ingredient.")
        }
        
    }
}

#Preview {
    SelectIngredientsView()
        .modelContainer(for: Ingredient.self, inMemory: true)
}
