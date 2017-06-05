//
//  DynamicTextCell.swift
//  Personal-Compass
//
//  Created by Ignacio Zunino on 24-05-17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

class CompassFacetSummaryCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleContainer.layer.cornerRadius = App.Appearance.buttonCornerRadius
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
    }

}
