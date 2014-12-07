//
//  FPDebtTableViewCell.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/5/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class FPDebtTableViewCell: UITableViewCell {

    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
