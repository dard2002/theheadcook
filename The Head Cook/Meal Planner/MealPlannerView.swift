//
//  MealPlannerView.swift
//  The Head Cook
//
//  Created by Dylan Armstrong on 18/8/2024.
//

import SwiftUI
import SwiftData

struct MealPlannerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var days: [Day]
    @State private var daysOfTheWeek: [Int: String] = [
        0: "Monday",
        1: "Tuesday",
        2: "Wednesday",
        3: "Thursday",
        4: "Friday",
        5: "Saturday",
        6: "Sunday"
    ]
    
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    ForEach(days, id: \.id) { day in
                        Text(day.name)
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
        }.onAppear { self.initializeDays() }
    }
    
    private func initializeDays() -> Void {
        var fetchDescriptor = FetchDescriptor<Day>()
        fetchDescriptor.propertiesToFetch = [\.id]
        
        do {
            let numOfDays: Int = try modelContext.fetch(fetchDescriptor).count
            
            if(numOfDays == 0) {
                for(idx, dayOfTheWeek) in daysOfTheWeek {
                    let day: Day = Day(id: idx, name: dayOfTheWeek, meals: [])
                    modelContext.insert(day)
                }
            } else {
                print("Days are already in the database. Continuing to app...")
            }
        } catch {
            print("An error has occured while trying to initialize/add the days to the database")
        }
    }
}
