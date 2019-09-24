//
//  CoreDataManager.swift
//  My Browser
//
//  Created by Kiwon on 19/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
       /// 코어데이터 사용 Context
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let isHardDeleteAllowed = true
    
    static func loadAllCoreData(entity: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        do {
           return try CoreDataManager.context.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    static func saveCoreData( _ tab: Tab) {
        tab.setValue(tab.url, forKey: Const.CoreData.Tab.url.name)
        tab.setValue(tab.name, forKey: Const.CoreData.Tab.name.name)
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func updateCoreData(objc: NSManagedObject, name: String, url: String,
                               onCompletion: @escaping (_ objc:NSManagedObject) -> Void,
                               onFailure: @escaping (_ error: NSError) -> Void) {
        
        (objc as! Tab).name = name
        (objc as! Tab).url = url
        
        do {
            try self.context.save()
            onCompletion(objc)
        } catch let error as NSError {
            onFailure(error as NSError)
        }
    }
    
    static func deleteCoreData(objc: NSManagedObject, onCompletion: @escaping (_ status:Bool) -> Void) {
        do {
            self.context.delete(objc)
            try self.context.save()
            onCompletion(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
