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
    @State private var ingredientToggleStates: [Int: Bool] = [:]
    @State private var showCreateIngredientView: Bool = false
    @Binding var currentRecipe: Recipe
    
    var body: some View {
        if(!showCreateIngredientView) {
            VStack {
                HStack {
                    Text("1").font(.title2).bold().padding().frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.2, alignment: .leading)
                    Text("Add/Remove Ingredients to the Recipe").frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.7, alignment: .leading)
                }
                Spacer()
                List {
                    ScrollView {
                        ForEach(ingredients.sorted(by: { $0.name < $1.name } ), id: \.id) { ingredient in
                            VStack {
                                Text("\(ingredient.name)")
                                Text("\(ingredient.quantity) \(ingredient.quantityUnits)")
                                
                                Toggle("", isOn: Binding(
                                    get: { ingredientToggleStates[ingredient.id] ?? false },
                                    set: { newValue in
                                        ingredientToggleStates[ingredient.id] = newValue
                                        if newValue {
                                            addIngredientToRecipe(ingredient: ingredient)
                                        } else {
                                            removeIngredientFromRecipe(ingredient: ingredient)
                                        }
                                    }
                                )).labelsHidden()
                                    .toggleStyle(.switch)
                            }
                            Divider()
                        }
                    }
                }
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
                            }
                            Divider()
                        }
                    }
                }
            }
            
            HStack {
                Button(action: {
                    withAnimation {
                        showCreateIngredientView = true
                    }
                }, label: {(
                    Text("Create New Ingredient")
                )}).buttonStyle(.borderedProminent).tint(.green).padding()
                
                Button(action: {  }, label: {(
                    Text("Next Step")
                )}).buttonStyle(.borderedProminent).tint(.blue).padding()
            }
        } else {
            CreateIngredientView(showCreateIngredientView: $showCreateIngredientView, currentRecipe: $currentRecipe)
        }
    }
    
    private func addIngredientToRecipe(ingredient: Ingredient) -> Void {
        if(currentRecipe.ingredients.contains(ingredient)) {
            print("Current recipe already contains ingredient. Continuing...")
        } else {
            withAnimation {
                currentRecipe.ingredients.append(ingredient)
            }
        }
    }
    
    private func removeIngredientFromRecipe(ingredient: Ingredient) -> Void {
        withAnimation {
            currentRecipe.ingredients.removeAll() {
                $0.name == ingredient.name &&
                $0.quantity == ingredient.quantity &&
                $0.quantityUnits == ingredient.quantityUnits
            }
        }
    }
}
