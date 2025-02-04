//
//  CoreDataManager.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

//import Foundation
//import CoreData
//
//final class CoreDataManager {
//    static let shared = CoreDataManager()
//
//    private init() {}
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "RickAndMortyCleanSwift")
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Unresolved error \(error)")
//            }
//        }
//        return container
//    }()
//
//    var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
//    func testCoreDataSetup() {
//        let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//        do {
//            let results = try context.fetch(fetchRequest)
//            print("Fetched \(results.count) characters from CoreData")
//        } catch {
//            print("Failed to fetch: \(error)")
//        }
//    }
//}
//
//extension CoreDataManager {
//    func saveCharacters(_ characters: [RMCharacter]) {
//        clearCharacters()
//
//        for character in characters {
//            let cdCharacter = CDCharacter(context: context)
//            cdCharacter.id = Int64(character.id)
//            cdCharacter.name = character.name
//            cdCharacter.imageURL = character.image
//            cdCharacter.status = character.status
//            cdCharacter.species = character.species
//        }
//
//        saveContext()
//    }
//
//    func fetchCharacters() -> [RMCharacter] {
//        let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//
//        do {
//            let cdCharacters = try context.fetch(fetchRequest)
//            return cdCharacters.map { cdCharacter in
//                RMCharacter(
//                    id: Int(cdCharacter.id),
//                    name: cdCharacter.name ?? "",
//                    image: cdCharacter.imageURL ?? "",
//                    status: cdCharacter.status ?? "",
//                    species: cdCharacter.species ?? ""
//                )
//            }
//        } catch {
//            print("Failed to fetch characters: \(error)")
//            return []
//        }
//    }
//
//    private func clearCharacters() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print("Failed to clear characters: \(error)")
//        }
//    }
//}


import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "RickAndMortyCleanSwift")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
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
    
    func testCoreDataSetup() {
        let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            print("Fetched \(results.count) characters from CoreData")
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
}

extension CoreDataManager {
    func saveCharacters(_ characters: [RMCharacter]) {
        clearCharacters()

        persistentContainer.performBackgroundTask { context in
            for character in characters {
                let cdCharacter = CDCharacter(context: context)
                cdCharacter.id = Int64(character.id)
                cdCharacter.name = character.name
                cdCharacter.imageURL = character.image
                cdCharacter.status = character.status
                cdCharacter.species = character.species
            }

            do {
                try context.save()
            } catch {
                print("Failed to save characters: \(error)")
            }
        }
    }
    
    func fetchCharacters() -> [RMCharacter] {
        let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
        
        do {
            let cdCharacters = try context.fetch(fetchRequest)
            return cdCharacters.map { cdCharacter in
                RMCharacter(
                    id: Int(cdCharacter.id),
                    name: cdCharacter.name ?? "",
                    image: cdCharacter.imageURL ?? "",
                    status: cdCharacter.status ?? "",
                    species: cdCharacter.species ?? ""
                )
            }
        } catch {
            print("Failed to fetch characters: \(error)")
            return []
        }
    }
    
    private func clearCharacters() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to clear characters: \(error)")
        }
    }
}
