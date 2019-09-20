//
//  Functions.swift
//  My Browser
//
//  Created by Kiwon on 29/08/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

/// 단말의 Safe Area Inset값을 가져온다.
public func getSafeAreaInsets() -> UIEdgeInsets {
    if isiPhoneXseries() ,
        let window = UIApplication.shared.windows.first {
        return window.safeAreaInsets
    }
    return .zero
}

/// 단말 Status Height 조회
public func getStatusHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}

/// 단말 NavigationBar Height 조회
public func getNavigationBarHeight() -> CGFloat {
    return 44
}


/// 디바이스 width 조회
public func getAppFullWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

/// 디바이스 height 조회
public func getAppFullHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

// MARK: - Devices
public func isIOS11() -> Bool{
    return CGFloat((UIDevice.current.systemVersion as NSString).floatValue) >= 11.0
}

public func isiPhone4() -> Bool{
    return UIScreen.main.bounds.size.height == 480.0
}

public func isiPhone5() -> Bool{
    return UIScreen.main.bounds.size.height == 568.0
}

public func isiPhone8() -> Bool{
    return UIScreen.main.bounds.size.height == 812.0
}

public func isiPhoneX() -> Bool{
    return UIScreen.main.bounds.size.height == 812.0
}

public func isiPhoneXr() -> Bool{
    return UIScreen.main.bounds.size.height == 896.0
}

public func isiPhoneXs() -> Bool{
    return UIScreen.main.bounds.size.height == 896.0
}

public func isiPhoneXsMax() -> Bool{
    return UIScreen.main.bounds.size.height == 896.0
}

public func isiPhoneXseries() -> Bool{
    if isiPhoneX() || isiPhoneXr() || isiPhoneXs() || isiPhoneXsMax() {
        return true
    }
    return false
}

public func log(_ message: String..., separator: String = "") {
    #if DEBUG
    if separator.isEmpty {
        Swift.print(message)
    } else {
        Swift.print(message, separator: separator)
    }
    #endif
}

public func logDebug(_ items: Any...) {
    #if DEBUG
    Swift.debugPrint(items)
    #endif
}
