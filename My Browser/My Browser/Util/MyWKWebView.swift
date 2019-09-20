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

// MARK:- Public Functions
extension MyWKWebView {
    public func setAutolayout(withView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    public func openApp(withScheme urlScheme: String, moreString: String?) {
        guard let url = URL.init(string: urlScheme + (moreString ?? "")) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    public func callJavaScript(functionName: String) {
    //        let js:String = String(format: "ajaxSetting.imgHTML('%@');", imageURL)
            self.evaluateJavaScript(functionName) { (AnyObject, NSError) in
                log("function \(#function)")
            }
        }
        
        func loadQueryString(withRequest request: URLRequest, url: URL) {
            let task = URLSession.shared.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
                if data != nil {
                    if let returnString = String(data: data!, encoding: .utf8) {
                        log("loadQueryString : " + returnString)
                        DispatchQueue.main.async {
                            self.loadHTMLString(returnString, baseURL: url)
                        }
                    }
                }
            }
            task.resume()
        }
}
