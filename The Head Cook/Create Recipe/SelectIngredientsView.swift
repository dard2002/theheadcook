//
//  SelectIngredientsView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import SwiftUI
import PhotosUI
import SwiftData

struct SelectIngredientsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var ingredients: [Ingredient]
    @Query private var recipes: [Recipe]
    @State private var ingredientToggleStates: [Int: Bool] = [:]
    @State private var showCreateIngredientView: Bool = false
    @Binding var currentRecipe: Recipe?
    
    var body: some View {
        if(!showCreateIngredientView) {
            VStack {
                HStack {
                    Text("1").font(.title2).bold().padding().frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.2, alignment: .leading)
                    Text("Add/Remove Ingredients to the Recipe").frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.7, alignment: .leading)
                }
                Spacer()
                    ScrollView {
                        ForEach(ingredients.sorted(by: { $0.name < $1.name } ), id: \.id) { ingredient in
                            if(ingredient.name != "") {
                                VStack {
                                    HStack {
                                        if let imageData = ingredient.image, let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        } else {
                                            // Fallback image or placeholder
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        }
                                    }
                                    
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
                ScrollView {
                    if let currentRecipe = currentRecipe {
                        ForEach(currentRecipe.ingredients.sorted(by: { $0.name < $1.name } ), id: \.id) { ingredient in
                            VStack {
                                HStack {
                                    if let imageData = ingredient.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    } else {
                                        // Fallback image or placeholder
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                                
                                Text("\(ingredient.name)")
                                Text("\(ingredient.quantity) \(ingredient.quantityUnits)")
                                
                                Divider()
                            }
                        }
                    }
                    else {
                        Text("No recipe selected.")
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
                    
                    // TODO: Action to get to the Instructions View for Recipe Steps
                    Button(action: { }, label: {(
                        Text("Next Step")
                    )}).buttonStyle(.borderedProminent).tint(.blue).padding()
                }
            }
        } else {
            CreateIngredientView(showCreateIngredientView: $showCreateIngredientView, currentRecipe: $currentRecipe)
        }
    }
    
    private func addIngredientToRecipe(ingredient: Ingredient) -> Void {
        guard let recipe = currentRecipe else {
                    print("Current recipe is nil, cannot add ingredient.")
                    return
                }
        
        if recipe.ingredients.contains(where: { $0.id == ingredient.id }) {
            print("Current recipe already contains ingredient. Continuing...")
        } else {
            withAnimation {
                currentRecipe!.ingredients.append(ingredient)
                currentRecipe = recipe
            }
        }
    }
    
    private func removeIngredientFromRecipe(ingredient: Ingredient) -> Void {
        
        guard let recipe = currentRecipe else {
                    print("Current recipe is nil, cannot remove ingredient.")
                    return
                }
        
        withAnimation {
            currentRecipe!.ingredients.removeAll() {
                $0.name == ingredient.name &&
                $0.quantity == ingredient.quantity &&
                $0.quantityUnits == ingredient.quantityUnits
            }
            
            currentRecipe = recipe
        }
    }
}
