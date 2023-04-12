//
//  RecordingListView.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import SwiftUI
import CoreLocation
import CoreData

struct RecordingListView: View {
    @EnvironmentObject var voiceNoteViewModel:VoiceNoteViewModel
    var body: some View {
        NavigationStack {
            List {
                ForEach((1...10), id: \.self) {
                    ListItem (
                            voiceNote: VoiceNote(
                                    noteId: UUID(),
                                    noteTitle: "Note - \($0)",
                                    noteText: "Rekjh falk sdlfka hsldkj fhkasdh lkfsd",
                                    noteDuration: TimeDuration(size: 3765),
                                    noteCreatedAt: Date.init(),
                                    noteTakenNear: "Ruoholahti",
                                    voiceNoteLocation: CLLocation(latitude: 24.33, longitude: 33.56)
                    ))
                }
                }
        }.navigationBarTitle("My Voice Notes")
    }
}

/*struct RecordingListView_Previews: PreviewProvider {
 static var previews: some View {
 RecordingListView().environmentObject(VoiceNoteViewModel())
 }
 }
 */

struct RecordingListView_Previews: PreviewProvider {
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
        
        return RecordingListView()
            .environmentObject(VoiceNoteViewModel(context: context))
    }
}
