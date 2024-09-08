//
//  DashboardView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 14/8/2024.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
        @Query private var recipes: [Recipe]
        @State private var daysOfTheWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] // Come back to, see if there is a better way to write this
    @State private var selectedRecipe: Recipe = Recipe(id: 0, name: "", ingredients: [], instructions: "", favourite: false, imageName: "", mealTime: Recipe.mealTimes.Dinner)
    @State private var showRecipeView: Bool = false
        
        var body: some View {
            if(!showRecipeView) {
                VStack {
                    // TODO: Update username below with actual username once User Accounts and Authentication is implemented within the app
                    Text("Hello, <Username>").font(.title.bold())
                    Text("Weekly Meal Plan").font(.title2.bold())
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Grid {
                                GridRow {
                                    ForEach(daysOfTheWeek, id: \.self) { day in
                                        Text(day)
                                    }
                                }
                                Divider()
                                GridRow {
                                    Text("Breakfast")
                                }
                                Divider()
                                GridRow {
                                    Text("Lunch")
                                }
                                Divider()
                                GridRow {
                                    Text("Dinner")
                                }
                            }
                        }.padding().frame(width: 750, height: 300)
                    }
                    Section {
                        Text("Your Favourite Recipes").font(.title2.bold())
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(recipes.filter { $0.favourite }, id: \.id) { recipe in
                                    VStack {
                                        Text(recipe.name)
                                        Image(recipe.imageName).resizable().frame(width: 200, height: 200)
                                        // TODO: Update button action below, to display the recipe in the View Recipes View once that feature has been implemented
                                        Button(action: {
                                            displayRecipe(recipe: recipe)
                                        }, label: {
                                            Text("Show Recipe")
                                        })
                                    }.padding().frame(width: 212.5, height: 300)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            else {
                RecipeView(recipe: $selectedRecipe)
            }
    }
    
    private func displayRecipe(recipe: Recipe) -> Void {
        selectedRecipe = recipe
        showRecipeView = true
    }
}
