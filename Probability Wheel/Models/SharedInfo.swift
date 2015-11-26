//
//  SharedInfo.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/6/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//

import Foundation
import UIKit
class SharedInfo {
    
    let numOptions = 6
    let knob_xOffset = Float(-1 * 3)
    let knob_yOffset = Float(0)
    private var wheelRadius:CGFloat = 0.0
    private var wheelCenter:CGPoint? = nil
    var options = [Option]()
    var showPercentage : Bool = true
    var resetWheel : Bool = true
    
    // We want this info to be shared across different views
    // Therefore we will use a singleton class
    class var sharedInstance: SharedInfo {
        struct Static {
            static var instance: SharedInfo?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SharedInfo()
        }
        
        return Static.instance!
    }
    

    func reset() {
        var newOptions = [Option]()
        for i in 1...numOptions {
            newOptions.append(Option(idx: i, percentage: 1.0 / 2.0))
            if i > 2 {
                newOptions[i - 1].setInactive()
                newOptions[i - 1].setPercentage(0.0)
            }
        }
        options = newOptions
        showPercentage = true
        resetWheel = true
    }
    
    func setRadius(radius: CGFloat) {
        wheelRadius = radius
    }
    
    func getRadius() -> CGFloat {
        return wheelRadius
    }
    
    func setCenter(center: CGPoint) {
        wheelCenter = center
    }
    
    func getCenter() -> CGPoint {
        return wheelCenter!
    }
    
    func resetActive() {
        evenOutPercentages()
    }
    
    func activeOptionsCount() -> Int {
        var count = 0
        for option in options {
            if option.isActive() {
                ++count
            }
        }
        return count
    }
    
    func getActiveOptions() -> [Option] {
        var activeOptions = [Option]()
        for option in options {
            if option.isActive() {
                activeOptions.append(option)
            }
        }
        return activeOptions
    }
    
    func getInactiveOptions() -> [Option] {
        var inactiveOptions = [Option]()
        for option in options {
            if !option.isActive() {
                inactiveOptions.append(option)
            }
        }
        return inactiveOptions
    }
    
    func updateInfo() {
        evenOutPercentages()
    }
    
    func evenOutPercentages() {
        let numActiveOptions = Double(activeOptionsCount())
        let evenPercentage = 1.0 / numActiveOptions
        for option in options {
            if option.isActive() {
                option.setPercentage(evenPercentage)
            } else {
                option.setPercentage(0.0)
            }
        }
        resetWheel = true
    }

    func togglePercentageView() {
        if showPercentage {
            showPercentage = false
        } else {
            showPercentage = true
        }
    }
}