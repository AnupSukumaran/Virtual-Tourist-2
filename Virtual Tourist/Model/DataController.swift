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
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion:(() -> ())? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else { fatalError("CoreDataError😳\(error!.localizedDescription)")}
            completion?()
        }
    }
    
}
