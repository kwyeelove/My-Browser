//
//  MainTabBar.swift
//  GS SHOP
//
//  Created by Kiwon on 03/09/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class MainTabBar: UIView {
    
    let HEIGHT: CGFloat = 50.0
    
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var cateLbl: UILabel!
    @IBOutlet weak var myShopLbl: UILabel!
    @IBOutlet weak var wishLbl: UILabel!
    @IBOutlet weak var historyLbl: UILabel!
    
    @IBOutlet var tabBarImageViews: [UIImageView]!
    @IBOutlet var tabBarButtons: [UIButton]!
    
    @IBOutlet weak var recentlyImgView: UIImageView!
    
    private var originFrame: CGRect = .zero

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    private func setUI() {
        let view = Bundle.main.loadNibNamed(MainTabBar.reusableIdentifier, owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        view.backgroundColor = .clear
        self.backgroundColor = UIColor.getColor("F9F9F9")
        
        
        let height = HEIGHT + getSafeAreaInsets().bottom
        self.frame = CGRect(x: 0, y: getAppFullHeight() - height, width: getAppFullWidth(), height: height)
        self.originFrame = self.frame
    }
    
    func showTabBar() {
        UIView.animate(withDuration: 0.3) {
            self.frame = self.originFrame
        }
    }
    
    func hideTabBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: self.originFrame.origin.x,
                                y: getAppFullHeight(),
                                width: self.originFrame.width,
                                height: self.originFrame.height)
        }) { (isFinished) in
            self.showTabBar()
        }
    }
}

// MARK:- Button Action
extension MainTabBar {
    
    @IBAction func tabBarTouchDownInside(_ sender: UIButton) {
        for (index, button) in self.tabBarButtons.enumerated() {
            if button.isEqual(sender) {
                self.tabBarImageViews[index].isHighlighted = true
                break
            }
        }
    }
    
    @IBAction func tabBarTouchUpOutSide(_ sender: UIButton) {
        for (index, button) in self.tabBarButtons.enumerated() {
            if button.isEqual(sender) {
                self.tabBarImageViews[index].isHighlighted = false
                break
            }
        }
    }
    
    @IBAction func tabBarAction(_ sender: UIButton) {
        for (index, button) in self.tabBarButtons.enumerated() {
            if button.isEqual(sender) {
                self.tabBarImageViews[index].isHighlighted = false
                break
            }
        }
        
        
            self.hideTabBar()
    }
}
