//
//  PopupAddTabView.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class PopupAddTabView: UIView {

    /// 백그라운드 뷰
    @IBOutlet weak var bgView: UIView!
    /// 팝업 전체뷰
    @IBOutlet weak var popupView: UIView!
    /// 타이틀 라벨
    @IBOutlet weak var titleLbl: UILabel!
    /// 메시지 라벨
    @IBOutlet weak var msgLbl: UILabel!
    /// 취소 버튼
    @IBOutlet weak var btnLeft: UIButton!
    /// 확인 버튼
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLbBot: NSLayoutConstraint!

}
