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
    @State private var recipeName: String = ""
    @FocusState private var showKeyboard: Bool
    @State private var showIngredientsSection: Bool = false
    @State private var currentRecipe: Recipe?
    @State private var showAlert: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @Query private var recipes: [Recipe]
    
    var body: some View {
        VStack {
            if(!showIngredientsSection) {
                Text("First, let's name your recipe:")
                TextField("Tap here to edit", text: $recipeName).focused($showKeyboard)
                
                Button(action: {
                    if(!recipeName.isEmpty) {
                        showKeyboard = false
                        createInitialRecipe()
                        showIngredientsSection = true
                    } else {
                        // Toggle alert on if an error with the above if statement occurs
                        showAlert = true
                    }
                }, label: {
                    Text("Next")
                }).alert(isPresented: $showAlert) {
                    Alert(title: (Text("Please fix the following")), message: (Text("Add a recipe name before continuing"))
                )}.buttonStyle(.borderedProminent).tint(.blue).padding()
                
                Text("Select an Image for your Recipe").font(.title2).bold()
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
                SelectIngredientsView(currentRecipe: $currentRecipe)
            }
        }
    }
    
    private func createInitialRecipe() -> Void {
        var fetchDescriptor = FetchDescriptor<Recipe>()
        fetchDescriptor.propertiesToFetch = [\.id]
        
        do {
            let id: Int = try modelContext.fetch(fetchDescriptor).count + 1
            let recipe: Recipe = Recipe(id: id, name: recipeName, ingredients: [], instructions: "", favourite: true, mealTime: Recipe.mealTimes.Dinner, image: selectedPhotoData)
            modelContext.insert(recipe)
            
            currentRecipe = recipe
        } catch {
            print("An error has occured whilst trying to add a recipe: \(error)")
        }
    }
}
