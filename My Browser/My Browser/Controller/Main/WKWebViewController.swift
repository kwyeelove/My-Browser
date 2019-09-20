//
//  WKWebViewController.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: BaseViewController {

    @IBOutlet var wkWebView: MyWKWebView!
    
    var url: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.getRandomColor()
        
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            self.wkWebView = MyWKWebView(frame: self.wkWebView.frame)
            self.wkWebView.load(request)
        }
    }
}

extension WKWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else {
            return nil
        }
        // target = _blank tag 호출시
        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame  else  {
            self.wkWebView.openApp(withScheme: url.absoluteString, moreString: nil)
            return nil
        }
        return nil
    }
}

//extension WKWebViewController: WKNavigationDelegate {
//
//}
