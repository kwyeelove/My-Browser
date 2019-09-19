//
//  BaseViewController.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    /// 코어데이터 사용 Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // 로딩화면
    var loadingView: LoadingView!
    
    /// 네비게이션 컨트롤러
    override var navigationController: BaseNavigationController? {
        get {
            return super.navigationController as? BaseNavigationController ?? nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBackButton(title: "")
        self.loadingView = LoadingView.init(frame: self.view.frame)
    }
}

// MARK:- Loading View
extension BaseViewController {
    func showLoading() {
        if !self.loadingView.isHidden {
            return
        }
        
        self.view.addSubview(self.loadingView)
        self.loadingView.alpha = 0.0
        self.loadingView.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 1.0
        })
    }
    
    func stopLoading() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 0.0
        }) { (success) in
            self.loadingView.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
}



