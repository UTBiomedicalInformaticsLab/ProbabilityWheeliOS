//
//  KnobView.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/15/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.

import UIKit

class KnobView: UIView {
    private var index:Int = 0
    private var angle:CGFloat = 0.0
    let sharedInfo = SharedInfo.sharedInstance
    
    // Overrides the drawing of a rectangle. Makes it look like a circle instead.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderColor = UIColor.clearColor().CGColor
        layer.borderWidth = 1.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        //self.backgroundColor = UIColor.clearColor()
        drawRect(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAngle(angle: CGFloat) {
        self.angle = angle
    }
    
    func getAngle() -> CGFloat {
        return self.angle
    }

    func setPoint(point: CGPoint) {
        frame.origin.x = point.x
        frame.origin.y = point.y
    }
    
    func setIdx(index: Int) {
        self.index = index
    }
    
    func getIdx() -> Int {
        return self.index
    }
    
    func closeTo(p : CGPoint) -> Bool {
        let sensitivity = CGFloat(2.5)
        let x = frame.origin.x
        let y = frame.origin.y
        let w = sensitivity*frame.width
        let h = sensitivity*frame.height
        
        return p.x >= x - w && p.x <= x + w && p.y >= y - h && p.y <= y + h
    }
    
    func distance(p : CGPoint) -> CGFloat {
        return sqrt(pow(p.x - frame.origin.x, 2) + pow(p.y - frame.origin.y, 2))
    }
    
    
    func getNewAngle(point: CGPoint) -> CGFloat {
        let center = sharedInfo.getCenter()
        
        if point.x >= center.x && point.y >= center.y {         // Quadrant I
            return abs(CGFloat(2 * M_PI) - atan2(center.y - point.y, point.x - center.x))
        } else if point.x < center.x && point.y > center.y {    // Quadrant II
            return abs(CGFloat(2 * M_PI) - (atan2(center.y - point.y, point.x - center.x)))
        } else if point.x < center.x && point.y < center.y {    // Quadrant III
            return abs(CGFloat(2 * M_PI) - (atan2(center.y - point.y, point.x - center.x)))
        } else {                                                // Quadrant IV
            return abs(CGFloat(2 * M_PI) - atan2(center.y - point.y, point.x - center.x))
        }
    }
    
    func updateCoordinates(p: CGPoint) {
        angle = getNewAngle(p)
        let radius = Float(sharedInfo.getRadius())
        let center = sharedInfo.getCenter()
        self.frame.origin.x = center.x + CGFloat(radius * cos(Float(angle)) + sharedInfo.knob_xOffset)
        self.frame.origin.y = center.y + CGFloat(radius * sin(Float(angle)) + sharedInfo.knob_yOffset)
    }
}