//
//  CreateRecipeView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import SwiftUI
import SwiftData

struct CreateRecipeView: View {
    // @Environment(\.modelContext) private var modelContext
    // @Query private var recipes: [Recipe]
    @State private var recipeName: String = ""
    @State private var showIngredientsSection: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("First, let's name your recipe:")
            TextField("Name your recipe here!", text: $recipeName)
            
            Button(action: { showIngredientsSection = true }, label: {
                Text("Next")
            })
            
            showIngredientsSection ? SelectIngredientsView() : nil
        }
    }
}

#Preview {
    CreateRecipeView()
}
