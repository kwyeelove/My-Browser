//
//  TabCell.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit

class TabCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.contentView.backgroundColor = .clear
        self.titleLbl.textColor = .black
        self.titleLbl.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLbl.textColor = .black
        self.titleLbl.text = ""
    }

}
