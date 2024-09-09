//
//  CreateRecipeView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentRecipe: Recipe?
    @State private var recipeName: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var showIngredientsSection: Bool = false
    @State private var showAlert: Bool = false
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack {
            if(!showIngredientsSection) {
                Text("First, let's name your recipe:").font(.title2).bold()
                TextField("Tap here to edit", text: $recipeName).focused($showKeyboard)
                
                /*
                 This button will create the initial recipe if the recipe name is not empty, otherwise
                 it will display the alert below saying to "Add a recipe name before continuing".
                */
                Button(action: {
                    if(!recipeName.isEmpty) {
                        createInitialRecipe()
                    } else {
                        showAlert = true
                    }
                }, label: {
                    Text("Next")
                }).alert(isPresented: $showAlert) {
                    Alert(title: (Text("Please fix the following")), message: (Text("Add a recipe name before continuing"))
                    )}.buttonStyle(.borderedProminent).tint(.blue).padding()
                
                Text("Select an Image for your Recipe")
                
                HStack {
                    Text("Add an Image")
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Image(systemName: "photo.badge.plus")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    }.onChange(of: selectedPhoto) { newItem in
                        if let newItem = newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    selectedPhotoData = data
                                }
                            }
                        }
                    }.buttonStyle(.borderless)
                }
            }
            else {
                // Current recipe is checked for null safety in the SelectIngredientsView
                SelectIngredientsView(currentRecipe: $currentRecipe)
            }
        }
    }
    
    /*
     This function creates the initial recipe, with no ingredients and assigns the newly created recipe an id.
     
     Then the function will insert that recipe into SwiftData, assign the currentRecipe as the recipe for the SelectIngredientsView
     and then show the SelectIngredientsView by setting showIngredientsSection to true.
     
     If an error occurs, a error will be printed to the console.
    */
    private func createInitialRecipe() -> Void {
        showKeyboard = false
        var fetchDescriptor = FetchDescriptor<Recipe>()
        fetchDescriptor.propertiesToFetch = [\.id]
        
        do {
            let id: Int = try modelContext.fetch(fetchDescriptor).count + 1
            let recipe: Recipe = Recipe(id: id, name: recipeName, ingredients: [], instructions: "", favourite: true, mealTime: Recipe.mealTimes.Dinner, image: selectedPhotoData)
            
            modelContext.insert(recipe)
            currentRecipe = recipe
            
            showIngredientsSection = true
        } catch {
            print("An error has occured whilst trying to add a recipe: \(error)")
        }
    }
}

#Preview {
    CreateRecipeView()
        .modelContainer(for: Recipe.self, inMemory: true)
}

