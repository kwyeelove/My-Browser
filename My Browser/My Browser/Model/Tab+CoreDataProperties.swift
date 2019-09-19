//
//  Tab+CoreDataProperties.swift
//  My Browser
//
//  Created by Kiwon on 19/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//
//

import Foundation
import CoreData


extension Tab {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tab> {
        return NSFetchRequest<Tab>(entityName: "Tab")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}
