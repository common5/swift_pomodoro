//
//  MyPodomoroApp.swift
//  MyPodomoro
//
//  Created by admin on 2023/12/30.
//

import SwiftUI
import SwiftData

@main
struct MyPodomoroApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Podomoro.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    @State var test:Int=0
    @State var test2:String=""
    @State var rest:Int=0
    @State var cycle:Int=0
    var body: some Scene {
        WindowGroup {
            MainView()
//            PodoConfigurationView(taskName:$test2,selectedTotalTime: $test,selectedRestTime: $rest,selectedCycleNum: $cycle)
        }
        .modelContainer(sharedModelContainer)
    }
}
