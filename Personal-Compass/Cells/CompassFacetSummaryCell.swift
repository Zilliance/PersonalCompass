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
        
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(2.0)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor.silverColor
        self.addSubview(additionalSeparator)
        
    }

}
