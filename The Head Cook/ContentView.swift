//
//  ContentView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 13/8/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            DashboardView().tabItem {
                Label("Dashboard", systemImage: "clock.fill")
            }
            CreateRecipeView().tabItem {
                Label("Create Recipe", systemImage: "plus.app")
            }
            MealPlannerView().tabItem {
                Label("Meal Planner", systemImage: "calendar.circle.fill")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
