//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 09/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import CoreData

public class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
        
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion:(() -> ())? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else { fatalError("CoreDataError😳\(error!.localizedDescription)")}
            
            self.configureContexts()
            completion?()
        }
    }
    
    
    func fetch<T>(sortOrderKey: String, ascending: Bool,forType:T, comp: (T) -> ()) {
         let fetchRequest: NSFetchRequest<Pins> = Pins.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: sortOrderKey, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let value = try? viewContext.fetch(fetchRequest) {
            comp(value as! T)
        }
    }
    
    public func fetchDataWith(sortOrderKey: String, ascending: Bool, entityName: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortOrderKey, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var data: [NSManagedObject]?
        do {
          data = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("newfetchData - fetchError - \(error.localizedDescription)")
        }
        
        return data
    }
    
    func saved() {
        if viewContext.hasChanges {
            do{
                try viewContext.save()
                
                print("Saved Pin😛")
            }catch let error{
                print(" Error😩 = \(error.localizedDescription)")
            }
        } else {
            print("No Changes in nsmanagedobjectcontext")
        }
        
    }
    
    func deleted(_ data: NSManagedObject) {
        viewContext.delete(data)
    }
    
}
