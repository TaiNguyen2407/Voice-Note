//
//  Voice_NoteApp.swift
//  Voice Note
//
//  Created by iosdev on 22.3.2023.
//

import SwiftUI
import CoreData

@main
struct Voice_NoteApp: App {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @StateObject var voiceNoteViewModel: VoiceNoteViewModel
    @StateObject var mapViewModel = MapViewModel()

    // Core Data stack
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VoiceNote")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    init() {
        let context = persistentContainer.viewContext
        _voiceNoteViewModel = StateObject(wrappedValue: VoiceNoteViewModel(context: context))
    }
    
    // Save Core Data changes
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(speechRecognizer)
            .environmentObject(voiceNoteViewModel)
            .environmentObject(mapViewModel)
            .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
