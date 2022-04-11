//
//  CoreDataStore.swift
//  Cats
//
//  Created by Mark Khmelnitskii on 10.04.2022.
//

import CoreData
import Combine

struct CoreDataStore {
    static let shared = CoreDataStore()
    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    private init() {
        self.container = NSPersistentContainer(name: "Model")
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //request.predicate = NSPredicate(format: "%K == %@", "isCompleted", NSNumber(value: false))
        return CoreDataFetchResultsPublisher(request: request, context: viewContext)
    }
    func publicher(save action: @escaping ()->()) -> CoreDataSaveModelPublisher {
        return CoreDataSaveModelPublisher(action: action, context: viewContext)
    }
    func publicher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher {
        return CoreDataDeleteModelPublisher(delete: request, context: viewContext)
    }
    func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}
