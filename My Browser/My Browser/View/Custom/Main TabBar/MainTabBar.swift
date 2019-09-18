//
//  MainTabBar.swift
//  My Browser
//
//  Created by Kiwon on 03/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

protocol MainTabBarDelegate {
    func backBtnAction()
    func forwardBtnAction()
    func refreshBtnAction()
    func urlBtnAction()
    func tabBtnAction()
}

class MainTabBar: UIView {
    
    let HEIGHT: CGFloat = 44.0
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var frontBtn: UIButton!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    @IBOutlet weak var urlBtn: UIButton!
    
    @IBOutlet weak var tabBtn: UIButton!
    
    private var originFrame: CGRect = .zero
    
    var delegate: MainTabBarDelegate?

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
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.delegate?.backBtnAction()
    }
    @IBAction func frontBtnAction(_ sender: UIButton) {
        self.delegate?.forwardBtnAction()
    }
    @IBAction func refreshBtnAction(_ sender: UIButton) {
        self.delegate?.refreshBtnAction()
    }
    @IBAction func urlBtnAction(_ sender: UIButton) {
        self.delegate?.urlBtnAction()
    }
    @IBAction func tabBtnAction(_ sender: UIButton) {
        self.delegate?.tabBtnAction()
    }
}
