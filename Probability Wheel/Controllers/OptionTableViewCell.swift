//
//  OptionTableViewCell.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/1/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import UIKit

protocol OptionCellUpdater {
    func updateTable()
}

class OptionTableViewCell: UITableViewCell, UITextFieldDelegate {
    let maxStringLength = 25
    
    let sharedInfo = SharedInfo.sharedInstance
    
    let activeColor = UIColor(red: 82 / 255 , green: 144 / 255, blue: 252 / 255, alpha: 1)
    let inactiveColor = UIColor(red: 111 / 255, green: 113 / 255, blue: 120 / 255, alpha: 1)
    
    @IBOutlet weak var ActiveButton: UIButton!
    @IBOutlet weak var UserText: UITextField!
    @IBOutlet weak var Percentage: UILabel!
    
    var delegate: OptionCellUpdater?
    
    var option : Option? {
        didSet {
            updateUI()
        }
    }

    @IBAction func ActivationToggled(sender: UIButton) {
        if self.option != nil {
            if self.option!.isActive() {
                if sharedInfo.activeOptionsCount() <= 2 {
                    return
                }
                self.option!.setInactive()
                sender.setTitleColor(inactiveColor, forState: UIControlState.Normal)
                print("Option \(option!.getIndex()) set inactive")
            } else {
                self.option!.setActive()
                sender.setTitleColor(activeColor, forState: UIControlState.Normal)
                print("Option \(option!.getIndex()) set active")
            }
            delegate?.updateTable()
        }
    }
    
    @IBAction func UserTextChanged(sender: UITextField) {
        if self.option != nil {
            let oldText = option!.getText()
            option!.setText(sender.text!)
            print("Text in Option \(option!.getIndex()) changed from \(oldText) to \(sender.text!)")
            delegate?.updateTable()
        }
    }
    
    // This delegate will limit the text field's input to a number of characters
    // as defined in the constant maxStringLength
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxStringLength
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.UserText.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.UserText.endEditing(true)
    }
    
    func updateUI() {
        if let option = self.option {
            UserText.delegate = self
            UserText?.text = option.getText()
            let displayedPercentage = option.getPercentage() * 100
            let displayString = String(format: "%.1f", displayedPercentage) + "%"
            Percentage?.text = displayString
            if (option.isActive()) {
                ActiveButton?.backgroundColor = option.getColor()
            } else {
                ActiveButton?.backgroundColor = inactiveColor
            }
            
        }
    }
    
    func getOption() -> Option? {
        return option
    }

}
