//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 09/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
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
