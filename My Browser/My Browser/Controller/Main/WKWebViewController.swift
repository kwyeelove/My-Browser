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

    var wkWebView: MyWKWebView!
    
    var mainDelegate: MainViewControllerDelegate?
    
    var url: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            self.wkWebView = MyWKWebView(frame: self.view.frame)
            self.wkWebView.scrollView.delegate = self
            self.wkWebView.navigationDelegate = self
            
            self.wkWebView.allowsBackForwardNavigationGestures = true
            self.wkWebView.load(request)
            self.view.addSubview(self.wkWebView)
            self.wkWebView.setAutolayout(withView: self.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension WKWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let url = navigationAction.request.url else {
            return nil
        }
        // target = _blank tag 호출시
        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame  else  {
            _ = self.wkWebView.openApp(withScheme: url.absoluteString, moreString: nil)
            return nil
        }
        return nil
    }
}

extension WKWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        log("decidePolicyFor navigationResponse : \(navigationResponse.debugDescription)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        log("decidePolicyFor navigationAction : \(navigationAction.debugDescription)")
        if let url = navigationAction.request.url,
            !url.absoluteString.hasPrefix("http"),
            self.wkWebView.openApp(withScheme: url.absoluteString, moreString: nil) {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        log("Finish!!")
    }
}

extension WKWebViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let contentOffset = scrollView.contentOffset.y
        if (velocity.y>0 && contentOffset > 50.0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.mainDelegate?.hideSearchBar(animate: true)
                print("Hide")
            }, completion: nil)
            
        } else if (velocity.y<=0 && contentOffset <= 50.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.mainDelegate?.showSearchBar(animate: true)
                print("show")
            }, completion: nil)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        if (contentOffset <= 50.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.mainDelegate?.showSearchBar(animate: true)
                print("show")
            }, completion: nil)
        }
    }
}
