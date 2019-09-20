//
//  PopupGoogleAdView.swift
//  My Browser
//
//  Created by Kiwon on 20/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PopupGoogleAdView: PopupBaseView {
    /// 백그라운드 뷰
    @IBOutlet weak var bgView: UIView!
    /// 구글 전면 광고
    var interstitial: GADInterstitial!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setInitUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitUI()
    }
    
    private func setInitUI() {
        let view = Bundle.main.loadNibNamed(PopupGoogleAdView.reusableIdentifier, owner: self, options: nil)?.first as! UIView
        view.backgroundColor = .clear
        view.frame = self.bounds
        self.addSubview(view)
        
        // bg 설정
        self.bgView.backgroundColor = UIColor.black
        self.bgView.alpha = 0.6
        
        

    }
    
    private func createAndLoadInterstitial() {
        // 구글 광고
        #if DEBUG
        let adUnitID = Const.Google.Popup_DEBUG.ID
        #else
        let adUnitID = Const.Google.Popup.ID
        #endif
        self.interstitial = GADInterstitial(adUnitID: adUnitID)
        
        let request = GADRequest()
        #if DEBUG
        request.testDevices = [ "2c4bfb4fb853b3d9b03c68578176d3a7" ]
        #endif
        interstitial.load(request)

    }
}
