//
//  KnobView.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/15/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//
//  The code in this file is largely based on this link:
//  http://www.ioscreator.com/tutorials/dragging-views-gestures-tutorial-ios8-swift

import UIKit

class KnobView: UIView {

    private var index:Int = 0
    private var lastLocation:CGPoint = CGPointMake(0,0)
    private var angle:CGFloat = 0.0
    let sharedInfo = SharedInfo.sharedInstance
    
    // Overrides the drawing of a rectangle. Makes it look like a circle instead.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        layer.borderColor = UIColor.clearColor().CGColor
        layer.borderWidth = 5.0
    }
    
    // Attach a pan gesture recognizer to the view
    // This allows us to click and drag it to a new position.
    override init(frame: CGRect) {
        super.init(frame: frame)
        /*
        let panRecognizer = UIPanGestureRecognizer(target:self, action:"detectPan:")
        self.gestureRecognizers = [panRecognizer]
        */
        self.backgroundColor = UIColor.blackColor()
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
    
    /*
    func detectPan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.superview!)
        self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
        //frame.origin.x = lastLocation.x + translation.x
        //frame.origin.y = lastLocation.y + translation.y
    }
    */
    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // promote the touched view
        self.superview?.bringSubviewToFront(self)
        //print("Knob \(index) being touched")
        // Remember the original location
        lastLocation = self.center
    }
    */

    func setPoint(point: CGPoint) {
        lastLocation = point
        //print("Moving point \(index) to (\(point.x),\(point.y)).")
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
        let x = frame.origin.x
        let y = frame.origin.y
        let w = frame.width
        let h = frame.height
        
        return p.x >= x - w && p.x <= x + w && p.y >= y - h && p.y <= y + h
    }
    
    func updateAngle(point: CGPoint) {
        let center = sharedInfo.getCenter()
        if point.x >= center.x && point.y >= center.y {         // Quadrant I
            angle =  -abs(atan2(center.y - (point.y + 10), (point.x + 10) - center.x) * CGFloat(180.0 / M_PI))
        } else if point.x < center.x && point.y > center.y {    // Quadrant II
            angle = abs(360 + (atan2(-((point.y + 10) - center.y), ((point.x + 10) - center.x)) * CGFloat(180 / M_PI)))
        } else if point.x < center.x && point.y < center.y {    // Quadrant III
            angle = abs(360 + (atan2(-((point.y + 10) - center.y), -(center.x - (point.x + 10))) * CGFloat(180 / M_PI)))
        } else {                                                // Quadrant IV
            angle = abs(atan2(center.y - (point.y + 10), -(center.x - (point.x + 10))) * (CGFloat(180 / M_PI)))
        }
    }
    
    func updateCoordinates(p: CGPoint) {
        updateAngle(p)
        let radius = Float(sharedInfo.getRadius())
        let center = sharedInfo.getCenter()
        self.frame.origin.x = center.x + CGFloat(radius * cos(Float(angle) / 360 * Float(2*M_PI)))
        self.frame.origin.y = center.y - CGFloat(radius * sin(Float(angle) / 360 * Float(2*M_PI)))
    }
}