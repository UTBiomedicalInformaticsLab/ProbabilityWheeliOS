//
//  ParticipantOptionCell.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/15/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import UIKit

class ParticipantOptionCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    let sharedInfo = SharedInfo.sharedInstance
    
    var option : Option? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let option = self.option {
            infoLabel?.text = option.getText()
            infoLabel?.textColor = option.getColor()
            if sharedInfo.showPercentage {
                percentageLabel?.hidden = false
                let displayedPercentage = option.getPercentage() * 100
                percentageLabel?.text = String(format: "%.1f", displayedPercentage) + "%"
            } else {
                percentageLabel?.hidden = true
            }
        }
    }
}
