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
            self.url = "https://www.google.com"
            self.name = "구글"
        }
    }
}
