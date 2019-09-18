//
//  Constants.swift
//  GS SHOP
//
//  Created by Kiwon on 27/08/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//
import Foundation

enum Const {}

// MARK:- Text Constants
extension Const {
    enum Text: String { case
        comfirm = "common_txt_confirm",
        close = "common_txt_close",

        search_bar_placeholder = "searchbar_placeholder"
        
        var localized: String { return self.rawValue.localizaed }
    }
}

// MARK:- StoryBoard Constatns
extension Const {
    enum StoryBoard: String { case
        main = "Main"
        var name: String { return self.rawValue }
    }
}


// MARK:- Image
extension Const {
    enum Image: String { case
        ico_side_menu_nor = "ico_side_menu_nor"
        var name: String { return self.rawValue }
    }
}

// MARK:- CoreData
extension Const {
    enum CoreData {
        enum Tab: String { case
            entity = "Tab",
            name = "name",
            url = "url"
            var name: String { return self.rawValue }
        }
    }
}

