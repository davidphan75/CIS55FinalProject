//
//  FPDutchOrderTableViewCell.swift
//  CIS55FinalProject
//
//  Created by David Phan on 12/6/14.
//  Copyright (c) 2014 David Phan. All rights reserved.
//

import UIKit

class FPDutchOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
