//
//  PopupManager.swift
//  My Browser
//
//  Created by Kiwon on 17/06/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class PopupManager: NSObject {
    static func showOneButton(titleStr: String = "",
                                    messsage: String,
                                    btnTitle: String = Const.Text.comfirm.localized,
                                    btnAction: VoidClosure? = nil) {

        guard let window = UIApplication.shared.keyWindow else { return }
        let view = PopupOneButtonView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.btnAction = btnAction
        view.btnTitle = btnTitle
        window.addSubview(view)
    }
    
    static func showTowButton(titleStr: String = "",
                                    messsage: String,
                                    btnLeftTitle: String = Const.Text.close.localized,
                                    btnRightTitle: String = Const.Text.comfirm.localized,
                                    btnLeftAction: VoidClosure? = nil,
                                    btnRightAction: VoidClosure? = nil) {
        guard let window = UIApplication.shared.keyWindow  else { return }
        let view = PopupTwoButtonView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.btnLeftTitle = btnLeftTitle
        view.btnRightTitle = btnRightTitle
        view.btnLeftAction = btnLeftAction
        view.btnRightAction = btnRightAction
        window.addSubview(view)
    }
    
    static func showImage(titleStr: String = "", messsage: String, image: UIImage, buttonTitle: String = "닫기", buttonAction: VoidClosure? = nil) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let view = PopupImageView(frame: CGRect(x: 0, y: 0, width: getAppFullWidth(), height: getAppFullHeight()))
        
        view.popupTitle = titleStr
        view.popupMsg = messsage
        view.popupImage = image
        view.cancelHandler = buttonAction
        view.cancelTitle = buttonTitle
        window.addSubview(view)
    }
}
