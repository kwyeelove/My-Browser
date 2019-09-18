//
//  PopupOneButtonView.swift
//  My Browser
//
//  Created by Kiwon on 17/06/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class PopupOneButtonView: PopupBaseView {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var titleLblTop: NSLayoutConstraint!
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    
    var popupTitle : String = "" {
        didSet {
            self.titleLbl.text = self.popupTitle
            if self.popupTitle.isEmpty {
                self.titleLblHeight.constant = 0.0
                self.titleLbl.isHidden = true
                self.titleLblTop.constant = 0.0
            } else {
                self.titleLblHeight.constant = self.titleLbl.intrinsicContentSize.height
                self.titleLbl.isHidden = false
                self.titleLblTop.constant = TITLE_LABEL_BOT_MARGIN
            }
        }
    }
    var popupMsg: String = "" {
        didSet { self.msgLbl.text = self.popupMsg }
    }
    var btnTitle: String = "" {
        didSet { self.cancelButton.setTitle(self.btnTitle, for: .normal) }
    }
    
    var btnAction: VoidClosure? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInitUI()
    }
    
    private func setInitUI() {
        let view = Bundle.main.loadNibNamed(PopupOneButtonView.reusableIdentifier,  owner: self, options: nil)?.first as! UIView
        view.backgroundColor = .clear
        view.frame = self.bounds
        self.addSubview(view)
        
        // bg 설정
        self.bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0.6
        
        // 라운딩
        self.popupView.clipsToBounds = true
        self.popupView.layer.cornerRadius = 5.0
        self.popupView.layer.shadowRadius = 5.0
        
        // UI 설정
        self.setPopupButton(self.cancelButton)
        self.setPopupTitleLabel(self.titleLbl)
        self.setPopupMsgLabel(self.msgLbl)
        
        // 팝업 애니메이션 추가
        addAnimate(inView: self.popupView)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        removeFromSuperview(completion: self.btnAction)
    }
}
