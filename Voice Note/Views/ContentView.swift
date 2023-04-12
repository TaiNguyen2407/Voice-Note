//
//  ContentView.swift
//  Voice Note
//
//  Created by iosdev on 22.3.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var showSheet:Bool = false
    @State var increaseHeight: Bool = false
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            if showSheet {
                SlidingModalView(showSheet: $showSheet)
            }
            BottomBarView(showSheet: $showSheet)
        }
        .background(
            Home()
        )
        
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(VoiceNoteViewModel()).environmentObject(SpeechRecognizer())
        }
    }
}
*/
import CoreData

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "VoiceNote", managedObjectModel: .init())
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        return NavigationView {
            ContentView()
                .environmentObject(VoiceNoteViewModel(context: context))
                .environmentObject(SpeechRecognizer())
        }
    }
}

