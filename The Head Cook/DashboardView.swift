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
    
    var body: some View {
        VStack {
            Text("Hello, <username>").font(.title.bold())
            Spacer()

            Text("Favourite Recipes").font(.title2.bold())
            
            ScrollView {
                ForEach(recipes.filter { $0.favourite }) { recipe in
                    VStack {
                        Text(recipe.name).foregroundColor(.white)
                        Image("")
                        Button(action: {/* Todo */}, label: {
                            Text("Show me")
                        })
                    }.background(Color.black).padding().overlay(
                        RoundedRectangle(cornerRadius: 10)
                    )
                }
            }
        }
    }
}
