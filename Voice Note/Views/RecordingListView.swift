import SwiftUI
import CoreLocation

/**
    A View that that List all Voice notes
 */
struct RecordingListView: View {
    @State var toast:ToastView? = nil
    @Environment(\.coreData) private var coreDataService: CoreDataService
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    @State private var searchText = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceNote.createdAt, ascending: false)],
        animation: .default)
    private var items: FetchedResults<VoiceNote>

    private var displayedVoiceNotes: [VoiceNote] {
        if searchText.isEmpty {
            return items.map{ $0 as VoiceNote }
        } else {
            let filteredVoiceNotes = items.filter{ $0.text?.lowercased().contains(searchText.lowercased()) ?? false}
            return filteredVoiceNotes// .isEmpty ? items.map{ $0 as VoiceNote} : filteredVoiceNotes
        }
    }
    var body: some View {
        NavigationStack {
             List{
                 // ForEach will give us onDelete feature by swiping Left
                 ForEach(displayedVoiceNotes.indices, id: \.self) { index in
                     ListItem(voiceNote: displayedVoiceNotes[index])
                 }.onDelete(perform: deleteItem)
             }
                        .searchable(text: $searchText)
                .toolbar {
                    /*ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    */ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }.navigationTitle("My Voice notes")
                .padding(0)
        }
        .toastView(toast: $toast)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /**
        Development option: This method add sample data to the UI
     */
    private func addItem() {
        withAnimation {
            coreDataService.addFakeItem()
        }
    }

    /**
        This method removed the selected voice note
     */
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.forEach{ listIndex in
                let managedObject = items[listIndex]
                if let fileURL = managedObject.fileUrl {
                    coreDataService.delete(managedObject)
                    voiceNoteViewModel.deleteRecording(url: fileURL)
                    voiceNoteViewModel.fetchVoiceNotes()
                    mapViewModel.populateLocation()
                }
            }
        }
    }
}

struct RecordingListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingListView(
            toast: ToastView(type: .success, title: "Delete Success", message: "Delete successfully") {
                print("cancel on toast pressed")
            })
        .environmentObject(VoiceNoteViewModel())
    }
}
