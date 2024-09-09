//
//  RecipeView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 5/9/2024.
//

import SwiftUI

struct RecipeView: View {
    @Binding var recipe: Recipe?
    
    var body: some View {
            ScrollView {
                VStack {
                    Text("\(recipe!.name)").font(.largeTitle).bold()
                    if let imageData = recipe!.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                    } else {
                        // Fallback image or placeholder
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                    }
                    
                    Text("Ingredients:").font(.title2).bold()
                    if let recipe = recipe {
                        ForEach(recipe.ingredients.sorted(by: { $0.name < $1.name } ), id: \.id) { ingredient in
                            HStack {
                                if let imageData = ingredient.image, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                } else {
                                    // Fallback image or placeholder
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                }
                                
                                VStack {
                                    Text("\(ingredient.name)").font(.title3).bold()
                                    Text("\(ingredient.quantity)")
                                    Text("\(ingredient.quantityUnits)")
                                }.frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.8, alignment: .center).padding()
                                
                            }.frame(maxWidth: (UIScreen.main.bounds.width - 32.0) * 0.8, alignment: .leading)
                        }
                    }
                    else {
                    Text("No Recipe found.")
                }
            }
        }
    }
}
