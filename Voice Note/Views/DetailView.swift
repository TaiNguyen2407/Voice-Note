//
//  DetailView.swift
//  Voice Note
//
//  Created by Giao Ngo on 18.4.2023.
//
import SwiftUI
import CoreData

struct DetailView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @Environment(\.presentationMode) var presentationMode
    let textContainer = #colorLiteral(red: 0.4, green: 0.2039215686, blue: 0.4980392157, alpha: 0.2)
    private let voiceNote: VoiceNote
    @State private var isEditing = false
    @State private var editText: String

    init(voiceNote: VoiceNote) {
        self.voiceNote = voiceNote
        _editText = State(initialValue: voiceNote.text ?? "")
    }

    var body: some View {
        VStack {
            if isEditing {
                TextEditor(text: $editText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(textContainer))
                    .cornerRadius(20)
                    .padding()
            } else {
                Text(voiceNote.text ?? "")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(textContainer))
                    .cornerRadius(20)
                    .padding()
            }
            
            RecordingCardView().padding(15)
            Text("Duration: \(voiceNote.duration)s")
            HStack {
                // Direction button
                DetailBtn(clickHander: {
                    print("Direction pressed")
                }, icon: "arrow.triangle.turn.up.right.diamond.fill")
                
                // Edit button
                DetailBtn(clickHander: {
                    toggleEditing()
                }, icon: isEditing ? "checkmark" : "pencil", alternativeIcon: isEditing ? "checkmark.circle.fill" : "")
                
                // Delete button
                DetailBtn(clickHander: {
                    deleteVoiceNote()
                }, icon: "trash")
                
                // Share button
                DetailBtn(clickHander: {
                    print("Share pressed")
                }, icon: "square.and.arrow.up").disabled(true)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private func toggleEditing() {
        if isEditing {
            saveEditedText()
        }
        isEditing.toggle()
    }
    
    private func saveEditedText() {
        let context = PersistenceController.shared.container.viewContext
        voiceNote.text = editText
        do {
            try context.save()
        } catch {
            print("Error saving edited text: \(error)")
        }
    }
    
    private func deleteVoiceNote() {
        let context = PersistenceController.shared.container.viewContext
        context.delete(voiceNote)
        do {
            try context.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error deleting voice note: \(error)")
        }
    }
}

struct DetailBtn: View {
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    let clickHander: () -> Void
    let icon: String
    let alternativeIcon: String?
    
    init(clickHander: @escaping () -> Void, icon: String, alternativeIcon: String? = nil) {
        self.clickHander = clickHander
        self.icon = icon
        self.alternativeIcon = alternativeIcon
    }
    
    var body: some View {
            Button {
                clickHander()
            } label: {
                if let alternativeIcon = alternativeIcon, !alternativeIcon.isEmpty {
                    Image(systemName: alternativeIcon)
                        .font(.title2)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .foregroundColor(Color(buttonColor))
                } else {
                    Image(systemName: icon)
                        .font(.title2)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .foregroundColor(Color(buttonColor))
                }
            }.padding(.horizontal,20)
        }
    }
/*struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(voiceNote: VoiceNote(
            noteId: UUID(),
            noteTitle: "Note - 1",
            noteText: "Rekjh falk sdlfka hsldkj fhkasdh lkfsd",
            noteDuration: TimeDuration(size: 3765),
            noteCreatedAt: Date.init(),
            noteTakenNear: "Ruoholahti",
            voiceNoteLocation: CLLocation(latitude: 24.33, longitude: 33.56)
        ))
    }
}
*/
