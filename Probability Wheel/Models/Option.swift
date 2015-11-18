//
//  OptionModel.swift
//  Probability Wheel
//
//  Created by Allen Wang on 10/30/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import Foundation
import UIKit

let colors: [UIColor] = [
    UIColor.blueColor(),
    UIColor.orangeColor(),
    UIColor.greenColor(),
    UIColor.yellowColor(),
    UIColor.cyanColor(),
    UIColor.magentaColor(),
]

class Option {
    private var index : Int
    private var percentage: Double
    private var text : String
    private var active : Bool
    private var color : UIColor
    
    init(idx : Int, percentage: Double) {
        index = idx
        text = "Option \(index)"
        self.percentage = percentage
        self.active = true
        self.color = colors[idx - 1]
    }
    
    func getIndex() -> Int {
        return index
    }
    
    func setIndex(idx : Int) {
        index = idx
    }
    
    func getText() -> String {
        return text
    }
    
    func setText(txt : String) {
        text = txt
    }
    
    func isActive() -> Bool {
        return active
    }
    
    func setActive() {
        active = true
    }
    
    func setInactive() {
        active = false
    }
    
    func setPercentage(percentage: Double) {
        self.percentage = percentage
    }
    
    func getPercentage() -> Double {
        return self.percentage
    }
    
    func getColor() -> UIColor {
        return color
    }
    
}
