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
        if(recipe != nil) {
            ScrollView {
                VStack {
                    Section {
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
                        ForEach(recipe!.ingredients, id: \.id) { ingredient in
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
                            List {
                                Text("\(ingredient.name)").font(.title3).bold()
                                Text("\(ingredient.quantity)")
                                Text("\(ingredient.quantityUnits)")
                            }
                        }
                    }
                }
            }
        }
    }
}
