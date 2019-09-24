//
//  Tab+CoreDataClass.swift
//  My Browser
//
//  Created by Kiwon on 19/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tab)
public class Tab: NSManagedObject {
    convenience init(context moc: NSManagedObjectContext, defaultSet: Bool = false ) {
        self.init(context: moc)
        if defaultSet {
            self.url = Const.CoreData.Tab.defaultURL.name
            self.name = Const.CoreData.Tab.defaultName.name.localizaed
        }
    }
}
