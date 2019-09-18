//
//  LoadingView.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        if let view = Bundle.main.loadNibNamed(LoadingView.reusableIdentifier, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
            addSubview(view)
            setUI()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        if !self.indicator.isAnimating {
            self.indicator.startAnimating()
        }
    }
    
    func startAnimating() {
        self.isHidden = false
        self.indicator.startAnimating()
    }
    
    func stopAnimating() {
        self.isHidden = true
        self.indicator.stopAnimating()
    }
}
