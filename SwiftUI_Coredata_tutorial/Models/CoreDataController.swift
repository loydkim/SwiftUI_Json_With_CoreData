//
//  Data.swift
//  FireBaseProject
//
//  Created by YOUNGSIC KIM on 2019-12-29.
//  Copyright © 2019 YOUNGSIC KIM. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

let coreDataController = CoreDataController()
let ENTITY_NAME = "Entity"
let ATTRIBUTE_NAME = "text"

class CoreDataController: ObservableObject {
    let context: NSManagedObjectContext
    @Published var data = [CoreDataType]()
    
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        readData()
    }
    
    func createData(msg1:String) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: context)
        entity.setValue(msg1, forKey: ATTRIBUTE_NAME)
        do{
            try context.save()
            print("Create data sucess")
            data.append(CoreDataType(id: entity.objectID, text: msg1))
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        
        do{
            let fetch = try context.fetch(request)
            for i in fetch as! [NSManagedObject]{
                self.data.append(CoreDataType(id: i.objectID, text: i.value(forKey: ATTRIBUTE_NAME) as! String))
            }
            print("Read data sucess")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteData(id : NSManagedObjectID, index: IndexSet) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        
        do{
            let fetch = try context.fetch(request)
            for i in fetch as! [NSManagedObject]{
                if i.objectID == id{
                    try context.execute(NSBatchDeleteRequest(objectIDs: [id]))
                    self.data.remove(atOffsets: index)
                    print("Delete data sucess")
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func updateData(id:NSManagedObjectID ,txt: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        do {
            let fetch = try context.fetch(request) as! [NSManagedObject]
            for index in fetch.indices{
                if fetch[index].objectID == id{
                    fetch[index].setValue(txt, forKey: ATTRIBUTE_NAME)
                    self.data[index].text = txt
                    try context.save()
                    print("Update data sucess")
                }
            }
        } catch {
            print(error)
        }
    }
}
