//
//  BaseNavigationController.swift
//  My Browser
//
//  Created by Kiwon on 18/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 네비게이션 투명하게
        setBackgroundClear()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setBackgroundClear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.navigationBar.barTintColor = .clear
        self.navigationBar.backgroundColor = .clear
        self.isNavigationBarHidden = true
    }
    
    func setBackgroundColor(color: UIColor = .white) {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        self.navigationBar.barTintColor = .white
        self.navigationBar.backgroundColor = .clear
        self.isNavigationBarHidden = false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portraitUpsideDown
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}

extension BaseNavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (() ->     Void)) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: @escaping (() -> Void)) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    private func doAfterAnimatingTransition(animated: Bool, completion: @escaping (() -> Void)) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion()
            })
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
