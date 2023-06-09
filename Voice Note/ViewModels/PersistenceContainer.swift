import CoreData

/**
    A Singleton that initialises the NSPersistenceContainer for application CoreData, sets up the static instance reference to PersistenceController and handles potential errors that may occur during initialization or saving. 
 */
struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newVoiceNote = VoiceNote(context: viewContext)

            newVoiceNote.id = UUID()
            newVoiceNote.text = "this is my voicenote text"
            newVoiceNote.title = "Note title"
            newVoiceNote.near = "Kamppi"
            newVoiceNote.fileUrl = URL(fileURLWithPath: "/dev/secure/storage")
            newVoiceNote.duration = 3765
            newVoiceNote.createdAt = Date.init()
            newVoiceNote.location = Location(context: viewContext)
            newVoiceNote.location?.latitude = 24.444
            newVoiceNote.location?.longitude = 64.444
            newVoiceNote.weather = Weather(context: viewContext)
            newVoiceNote.weather?.temperature = Temperature(context: viewContext)
            newVoiceNote.weather?.temperature?.maximum = 44
            newVoiceNote.weather?.temperature?.minimum = 24
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "VoiceNoteManagedObjectModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        // viewContext is a NSManagedObjectContext
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
