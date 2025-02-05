//
//  CoreDataManager.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

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
                print("Core Data Error: Unable to load persistent stores: \(error.localizedDescription)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Core Data Save Error: \(error.localizedDescription)")
        }
    }
    
    func testCoreDataSetup() {
        let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            print("Fetched \(results.count) characters from CoreData")
        } catch {
            print("❌ Failed to fetch: \(error)")
        }
    }
}

extension CoreDataManager {
    func saveCharacters(_ characters: [RMCharacter]) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            for character in characters {
                let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", character.id)

                do {
                    let existingCharacters = try context.fetch(fetchRequest)
                    let cdCharacter = existingCharacters.first ?? CDCharacter(context: context)

                    cdCharacter.id = Int64(character.id)
                    cdCharacter.name = character.name
                    cdCharacter.imageURL = character.image
                    cdCharacter.status = character.status
                    cdCharacter.species = character.species
                    
                    // Save image to FileManager
                    if let imageURL = URL(string: character.image),
                       let imageData = try? Data(contentsOf: imageURL) {
                        ImageCacheManager.shared.saveImage(imageData, id: character.id)
                    }
                } catch {
                    print("CoreData: Error fetching characters: \(error)")
                }
            }

            do {
                try context.save()
            } catch {
                print("CoreData: Error saving: \(error)")
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
            print("CoreData: Error fetching characters: \(error)")
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
            print("CoreData: Error clearing characters: \(error)")
        }
    }
}
