//
//  CoreDataaHelper.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import CoreData
import Foundation

class CoreDataService: NSObject {
    // MARK: - Core Data stack
    lazy var context = persistentContainer.viewContext
    static let standart = CoreDataService()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.appName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
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

    func save(model: LoadedData) {
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: context) else { return }
        let savedData = SavedData(entity: entity, insertInto: context)
        savedData.countOfDownloads = Int64(model.countOfDownloads ?? 0)
        savedData.date = model.dateCreate
        savedData.name = model.nameAuthor
        savedData.location = model.location
        savedData.id = model.uuid.uuidString
        savedData.url = model.url
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func fetch() -> [LoadedData]? {
        let fetchRequest: NSFetchRequest<SavedData> = SavedData.fetchRequest()
        var convertedData = [LoadedData]()
        guard let data = try? CoreDataService.standart.context.fetch(fetchRequest) else {
            return nil
        }
        data.forEach { saveDataContext in
            var object = LoadedData()
            object.nameAuthor = saveDataContext.name
            object.url = saveDataContext.url
            object.dateCreate = saveDataContext.date
            object.location = saveDataContext.location
            object.uuid = UUID(uuidString: saveDataContext.id ?? "") ?? UUID()
            object.countOfDownloads = Int(saveDataContext.countOfDownloads)
            convertedData.append(object)
        }
        return convertedData
    }

    func delete(id: UUID) {

        let predicateRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Constants.entityName)
        predicateRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: predicateRequest)
        do {
            try CoreDataService.standart.context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
