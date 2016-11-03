//
//  WheelView.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/8/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//
import UIKit

class WheelView: UIView {
    let sharedInfo = SharedInfo.sharedInstance

    let knobLength = 20.0
    
    var shapeLayers = [CAShapeLayer]()
    var knobs = [KnobView]()
    
    // This variable is used to allow only one knob to be touched.
    var touchedKnob:KnobView? = nil
    
    func initializeElements() {
        for i in 1...sharedInfo.numOptions {
            shapeLayers.append(CAShapeLayer())
            knobs.append(KnobView(frame: CGRect(x: 0.0, y: 0.0, width: knobLength, height: knobLength)))
            knobs[i - 1].setIdx(i)
        }
        updateWheel()
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
    
    
    func modifiedHitTest(points: [CGPoint], withEvent event: UIEvent?) -> UIView?  {
        var hitView:UIView?
        for point in points {
            hitView = hitTest(point, withEvent: event)
            if hitView != nil {
                return hitView
            }
        }
        return nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeElements()
    }

    func getTouchedView(p1: CGPoint) -> UIView? {
        /*
        let dist:CGFloat = CGFloat(2*knobLength)
        let p2 = CGPointMake(p1.x + dist, p1.y)
        let p3 = CGPointMake(p1.x - dist, p1.y)
        let p4 = CGPointMake(p1.x, p1.y + dist)
        let p5 = CGPointMake(p1.x, p1.y - dist)
        let p6 = CGPointMake(p1.x + dist, p1.y + dist)
        let p7 = CGPointMake(p1.x - dist, p1.y - dist)
        let points = [p1, p2, p3, p4, p5, p6, p7]
        //return modifiedHitTest(points, withEvent: nil)
        return hitTest(p1, withEvent: nil)
        */
        for knob in knobs {
            if knob.closeTo(p1) {
                return knob
            }
        }
        return nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchedKnob != nil || touches.first == nil {
            return
        }
        
        let touch:UITouch = touches.first!
        let p1 = touch.locationInView(self)
        let selectedView:UIView? = getTouchedView(p1)
        
        if let knob = selectedView as? KnobView {
            touchedKnob = knob
            print("Knob \(knob.getIdx()) has been touched")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if touches.first == nil {
            return
        }
        let touch:UITouch = touches.first!
        let p1 = touch.locationInView(self)
        if let knob = touchedKnob {
            print("Knob \(knob.getIdx()) moved")
            //let knob2 = (knob.getIdx() == 6) ? knobs[0] : knobs[knob.getIdx() + 1]
            knob.updateCoordinates(p1)
            //knob.setPoint(p1)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if let knob = touchedKnob {
            print("Knob \(knob.getIdx()) ended")
            touchedKnob = nil
        }
    }
    
    
    
    func updateWheel() {
        let totalOptions = sharedInfo.activeOptionsCount() - 1
        print ("Wheel updating. TotalOptions = \(totalOptions)")
        let activeOptions = sharedInfo.getActiveOptions()
        let inactiveOptions = sharedInfo.getInactiveOptions()
        for option in activeOptions {
            let requiredShapeLayer = shapeLayers[option.getIndex() - 1]
            let thisKnob = knobs[option.getIndex() - 1]
            
            requiredShapeLayer.frame = frame
            requiredShapeLayer.fillColor = option.getColor().CGColor
            self.layer.addSublayer(requiredShapeLayer)
            self.addSubview(thisKnob)
            thisKnob.hidden = false
        }
        for option in inactiveOptions {
            let thisKnob = knobs[option.getIndex() - 1]
            thisKnob.hidden = true
        }
        
        drawWheel()
    }
    
    func drawWheel() {
        let activeOptions = sharedInfo.getActiveOptions()
        //print("Drawing Wheel")
        if sharedInfo.activeOptionsCount() == 0 {
            return
        }
        
        var startAngle: CGFloat = CGFloat(M_PI)
        let radius:CGFloat = min(self.bounds.size.width,
            self.bounds.size.height) / 2.0 - 5
        sharedInfo.setRadius(radius)
        for option in activeOptions {
            let myShapeLayer = shapeLayers[option.getIndex() - 1]
            let thisKnob = knobs[option.getIndex() - 1]
            myShapeLayer.removeAllAnimations()
            let path = UIBezierPath()
            let center = CGPointMake(CGRectGetMidX(myShapeLayer.bounds),
                CGRectGetMidY(myShapeLayer.bounds))
            sharedInfo.setCenter(center)
            let endAngle:CGFloat = startAngle + CGFloat(option.getPercentage()) * CGFloat(M_PI) * 2.0
            
            
            path.moveToPoint(center)

            path.addArcWithCenter(center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true)
            path.addLineToPoint(center)
            
            path.closePath()
            let endPoint = CGPointMake(center.x + radius * cos(startAngle), center.y + radius * sin(startAngle))
            //print("Calculated endPoint for option \(option.getIndex()) is (\(endPoint.x),\(endPoint.y))")
            thisKnob.setPoint(endPoint)
            thisKnob.setAngle(startAngle)
            startAngle = endAngle
            myShapeLayer.path = path.CGPath
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        for requiredShapeLayer in shapeLayers {
            requiredShapeLayer.frame = self.layer.bounds
            requiredShapeLayer.removeAllAnimations()
        }
        self.drawWheel()
    }
}
