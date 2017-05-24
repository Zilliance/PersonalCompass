//
//  DynamicTextCell.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 24-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class DynamicTextCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelContainer.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.label.textColor = UIColor.white
        self.selectionStyle = .none
    }

}
