//
//  MyWKWebView.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit
import WebKit

fileprivate class ProcessPool: WKProcessPool {
    static let pool = ProcessPool()
}

class MyWKWebView: WKWebView {

    public init(frame: CGRect) {
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        let configuration = WKWebViewConfiguration()
        configuration.processPool = ProcessPool.pool
        
        super.init(frame: frame, configuration: configuration)
        configuration.userContentController = userContentWithCookies()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private
    private func userContentWithCookies() -> WKUserContentController {
        let userContentController = configuration.userContentController
        return userContentController
    }
}
