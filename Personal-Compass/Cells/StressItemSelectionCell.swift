//
//  StressItemSelectionCell.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 17-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

@IBDesignable class StressItemSelectionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
