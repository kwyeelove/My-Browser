//
//  BaseNavigationController.swift
//  My Browser
//
//  Created by Kiwon on 18/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass : navigationBarClass, toolbarClass : toolbarClass)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let mainVC = UIStoryboard.init(name: Const.StoryBoard.Main.name, bundle: nil).instantiateViewController(withIdentifier: MainViewController.reusableIdentifier) as? MainViewController else { return }
        self.setViewControllers([mainVC], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 네비게이션 하얀색
        setBackgroundColor(color: .white)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setBackgroundClear() {
//        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.navigationBar.barTintColor = .clear
        self.navigationBar.backgroundColor = .clear
        self.isNavigationBarHidden = true
    }
    
    func setBackgroundColor(color: UIColor = .white, isHiddneLine: Bool = false) {
        if isHiddneLine {
            // navigationBar 하단 line 숨기기
            self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage()
        }
        
        // isTranslucent: 불투명 처리 여부 (false: 안함 / true: 불투명)
        self.navigationBar.isTranslucent = true
        
        // navigationItme들의 Tint Color 설정
        self.navigationBar.tintColor = .black
        
        // navigationBar  배경색
        self.navigationBar.barTintColor = .white
        
//        self.navigationBar.backgroundColor = .clear
//        self.isNavigationBarHidden = false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portraitUpsideDown
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .lightContent
        }
    }

}

// MARK:- Public Functions
extension BaseNavigationController {
    func setNavigationBackButton(title: String) {
        let item = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], for: .normal)
        self.navigationItem.backBarButtonItem = item
    }
    
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

// MARK:- Private Functions
extension BaseNavigationController {
    private func initViews() {
        // NavigationBar Style을 검은색으로 바꿈으로써 Status Bar 스타일을 흰색으로 바꿀수 있다.
        self.navigationBar.barStyle = .black
        
        // 불투명 처리를 하지 않음.
        self.navigationBar.isTranslucent = false
        
        // BackgroundColor를 바꿔도 바뀌지 않음.. -> _UIBarBackground라는 녀석이 self.navigationBar.background 앞을 가리고 있음
        self.navigationBar.backgroundColor = .clear // UIColor.init(hexString: COLOR.BASE_COLOR_1D2029)
        
        // 실제 Bar Background color 설정 :  _UIBarBackground의 view 색상을 아래코드로 변경할 수 있음.
        self.navigationBar.barTintColor = UIColor.getColor(Const.Color.Base_nor.value)
        
        // 기본적으로 제공해주는 navigationBar의 언더라인(이라 쓰고 그림자shadow라고 읽는다ㅋ)를 삭제
        self.navigationBar.shadowImage = UIImage() // UIColor.init(hexString: COLOR.ARGB_33FFFFFF).as1PtImage()
                
        // 백버튼 글씨, BarButton title등의 글씨색을 흰색으로 변경
        self.navigationBar.tintColor = .black
        
        // navigationBar 폰트 + 크기 변경
        guard let font = UIFont.init(name: Const.Font.Apple_gothic_regular.name, size: 16.0) else {
            return
        }
        let fontAttribute = [ NSAttributedString.Key.font :  font]
        self.navigationBar.titleTextAttributes = fontAttribute
        // BarButton들의 폰트도 한꺼번에 바꿔준다.
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttribute, for: .normal)
    }
}
