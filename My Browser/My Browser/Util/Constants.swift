//
//  Constants.swift
//  My Browser
//
//  Created by Kiwon on 27/08/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//
import Foundation

enum Const {}

// MARK:- Text Constants
extension Const {
    enum Text: String { case
        comfirm = "common_txt_confirm",
        close = "common_txt_close",
        back = "common_txt_back",
        search_bar_placeholder = "searchbar_placeholder"
        
        
        var localized: String { return self.rawValue.localizaed }
    }
}

// MARK:- Font
extension Const {
    enum Font: String { case
        Apple_gothic_regular = "AppleSDGothicNeo-Regular",
        Apple_gothic_medium = "AppleSDGothicNeo-Medium",
        Apple_gothic_bold = "AppleSDGothicNeo-Bold",
        Apple_gothic_thin = "AppleSDGothicNeo-Thin"
        
        var name: String { return self.rawValue }
        
    }
}

// MARK:- Color
extension Const {
    enum Color: String { case
        Base_nor = "#1ABC9C",
        Base_pre = "#349880"
        
        var value: String { return self.rawValue }
    }
}

// MARK:- StoryBoard Constatns
extension Const {
    enum StoryBoard: String { case
        Main = "Main"
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

// MARK:- Google AdMod
extension Const {
    enum Google: String { case
        App = "ca-app-pub-9953759635938214~8090198693",
        MainBanner = "ca-app-pub-9953759635938214/4970045488",
        MainBanner_DEBUG = "ca-app-pub-3940256099942544/2934735716",
        Popup = "ca-app-pub-9953759635938214/8526981269",
        Popup_DEBUG = "ca-app-pub-3940256099942544/4411468910"
        
        var ID: String { return self.rawValue }
    }
}

