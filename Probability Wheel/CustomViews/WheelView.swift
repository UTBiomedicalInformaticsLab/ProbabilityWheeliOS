//
//  WheelView.swift
//  Probability Wheel
//
//  Created by Allen Wang on 11/8/15.
//  Copyright © 2015 UT Biomedical Informatics Lab. All rights reserved.
//
import UIKit

protocol WheelViewUpdater {
    func updateTable()
}

class WheelView: UIView {
    let sharedInfo = SharedInfo.sharedInstance

    let knobLength = 20.0
    
    var shapeLayers = [CAShapeLayer]()
    var knobs = [KnobView]()
    var activeKnobs = [KnobView]()
    
    var delegate: WheelViewUpdater?
    
    // This variable is used to allow only one knob to be touched.
    var touchedKnob:KnobView? = nil
    
    func initializeElements() {
        for i in 1...sharedInfo.numOptions {
            shapeLayers.append(CAShapeLayer())
            knobs.append(KnobView(frame: CGRect(x: 0.0, y: 0.0, width: knobLength, height: knobLength)))
            knobs[i - 1].setIdx(i)
        }
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
        var knobsInRange:[KnobView] = []
        var closestKnob:KnobView? = nil
        var minDistance:CGFloat = CGFloat(INT_MAX)
        for knob in knobs {
            if knob.closeTo(p1) {
                knobsInRange.append(knob)
            }
        }
        
        for knob in knobsInRange {
            let thisDistance = knob.distance(p1)
            if thisDistance < minDistance {
                closestKnob = knob
                minDistance = thisDistance
            }
        }
        
        return closestKnob
    }
    
    /* ------ Touch functions ------- */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchedKnob != nil || touches.first == nil {
            return
        }
        
        let touch:UITouch = touches.first!
        let p1 = touch.locationInView(self)
        let selectedView:UIView? = getTouchedView(p1)
        
        if let knob = selectedView as? KnobView {
            touchedKnob = knob
        }
    }
    
    // little helper function for checking for conflicts
    private func getAdjustedAngle(angle: CGFloat) -> CGFloat {
        return angle % CGFloat(2 * M_PI)
    }
    
    
    func anyConflicts(thisKnob : KnobView, p: CGPoint) -> Bool {
        var newAngle = getAdjustedAngle(thisKnob.getNewAngle(p))
        let allowableError = CGFloat(M_PI / 360)
        var thisKnobNewIndex = 0
        
        if activeKnobs.count > 0 {
            for i in 0...activeKnobs.count - 1{
                let knob = activeKnobs[i]
                if knob == thisKnob {
                    thisKnobNewIndex = i
                    continue
                }
                if abs(getAdjustedAngle(knob.getAngle()) - newAngle) <= allowableError  {
                    return true
                }
            }
            
            let leftKnob:KnobView = (thisKnobNewIndex == 0) ? activeKnobs.last! : activeKnobs[thisKnobNewIndex - 1]
            let rightKnob:KnobView = (thisKnobNewIndex == activeKnobs.count - 1) ? activeKnobs.first! : activeKnobs[thisKnobNewIndex + 1]
        
            if rightKnob == thisKnob || leftKnob == thisKnob || rightKnob == leftKnob {
                return false
            }
        
            let leftAngle = getAdjustedAngle(leftKnob.getAngle())
            let rightAngle = getAdjustedAngle(rightKnob.getAngle())
            var oldAngle = getAdjustedAngle(thisKnob.getAngle())
        
            /**************************************************
            *  At this point we're trying to check if the knob is between the other two knobs
            *  It's hard to check this because it's a circle, so using inequalities might not be that effective.
            *  However, we do know what the inequality was before, and that it was valid.
            *  We can just check that that inequality still holds.
            ***************************************************/
            
            // There's some wonky behavior if it's around 2*PI, so to fix that we're just checking that
            // if it's around that area, we'll add 2*PI to make the inequalities make sense
            // This breaks if any boundary angles are around 2*PI though.
            if !((leftAngle > CGFloat(1.9999 * M_PI) || leftAngle < 0.00001) ||
                (rightAngle > CGFloat(1.9999 * M_PI) || rightAngle < 0.00001)) {
                if (oldAngle > CGFloat(1.9 * M_PI) && newAngle < CGFloat(0.1 * M_PI)) {
                    newAngle += CGFloat(2 * M_PI)
                } else if(newAngle > CGFloat(1.9 * M_PI) && oldAngle < CGFloat(0.1 * M_PI)) {
                    oldAngle += CGFloat(2 * M_PI)
                }
            }
        
            if leftAngle <= oldAngle && rightAngle <= oldAngle {
                return !(leftAngle <= newAngle && rightAngle <= newAngle)
            } else if leftAngle <= oldAngle && rightAngle >= oldAngle {
                return !(leftAngle < newAngle && rightAngle > newAngle)
            } else if leftAngle >= oldAngle && rightAngle <= oldAngle {
                return !(leftAngle >= newAngle && rightAngle <= newAngle)
            } else { // leftAngle >= oldAngle && rightAngle >= oldAngle
                return !(leftAngle >= newAngle && rightAngle >= newAngle)
            }
        }
        return true
    }
    
    func updatePercentages() {
        var lastKnob:KnobView = activeKnobs.last!
        let activeOptions = sharedInfo.getActiveOptions()
        
        for i in 0...activeKnobs.count - 1 {
            let knob = activeKnobs[i]
            var option = activeOptions.last!
            if i > 0 {
                option = activeOptions[i - 1]
            }
            var percentage = ((knob.getAngle() - lastKnob.getAngle()) % CGFloat(2*M_PI)) / CGFloat(2*M_PI)
            if percentage < 0 {
                percentage = 1 + percentage
            }
            option.setPercentage(Double(percentage))
            lastKnob = knob
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
            if !anyConflicts(knob, p: p1) {
                knob.updateCoordinates(p1)
                updatePercentages()
                drawWheel()
                delegate?.updateTable()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        touchedKnob = nil
    }
    
    private func initializeShapeLayers() {
        for option in sharedInfo.getActiveOptions() {
            let requiredShapeLayer = shapeLayers[option.getIndex() - 1]
            requiredShapeLayer.frame = frame
            requiredShapeLayer.fillColor = option.getColor().CGColor
            self.layer.addSublayer(requiredShapeLayer)
            requiredShapeLayer.hidden = false
        }
        for option in sharedInfo.getInactiveOptions() {
            let requiredShapeLayer = shapeLayers[option.getIndex() - 1]
            requiredShapeLayer.hidden = true
        }
    }
    
    private func initializeKnobs() {
        activeKnobs.removeAll()
        for option in sharedInfo.getActiveOptions() {
            let thisKnob = knobs[option.getIndex() - 1]
            self.addSubview(thisKnob)
            activeKnobs.append(thisKnob)
            thisKnob.hidden = false
        }
        for option in sharedInfo.getInactiveOptions() {
            let thisKnob = knobs[option.getIndex() - 1]
            thisKnob.hidden = true
        }
    }
    
    func updateWheel() {
        // Initialize knobs last. Doing this puts it "on top" of the shapes.
        initializeShapeLayers()
        initializeKnobs()
        drawResetWheel()
    }
    
    func drawWheel() {
        let activeOptions = sharedInfo.getActiveOptions()
        if sharedInfo.activeOptionsCount() == 0 {
            return
        }
        
        let radius:CGFloat = sharedInfo.getRadius()
        let center = sharedInfo.getCenter()
        
        for i in 0...activeOptions.count - 1 {
            let option = activeOptions[i]
            let myShapeLayer = shapeLayers[option.getIndex() - 1]
            let thisKnob = activeKnobs[i]
            let nextKnob = (i == activeOptions.count - 1) ? activeKnobs[0] : activeKnobs[i + 1]
            myShapeLayer.removeAllAnimations()
            let path = UIBezierPath()
            
            let startAngle:CGFloat = thisKnob.getAngle()
            let endAngle:CGFloat = nextKnob.getAngle()
            
            path.moveToPoint(center)
            
            path.addArcWithCenter(center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true)
            path.addLineToPoint(center)
            path.closePath()
            myShapeLayer.path = path.CGPath
        }
    }
    
    func drawResetWheel() {
        let activeOptions = sharedInfo.getActiveOptions()
        if sharedInfo.activeOptionsCount() == 0 {
            return
        }
        
        var startAngle: CGFloat = CGFloat(M_PI)
        let radius:CGFloat = min(self.bounds.size.width,
            self.bounds.size.height) / 2.0 - 5
        sharedInfo.setRadius(radius)
        let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        sharedInfo.setCenter(center)
        for option in activeOptions {
            let myShapeLayer = shapeLayers[option.getIndex() - 1]
            let thisKnob = knobs[option.getIndex() - 1]
            myShapeLayer.removeAllAnimations()
            let path = UIBezierPath()
            let endAngle:CGFloat = startAngle + CGFloat(option.getPercentage()) * CGFloat(M_PI) * 2.0
            
            
            path.moveToPoint(center)

            path.addArcWithCenter(center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true)
            path.addLineToPoint(center)
            
            path.closePath()
           
            let endPoint = CGPointMake(center.x + radius * cos(startAngle) + CGFloat(sharedInfo.knob_xOffset),
                center.y + radius * sin(startAngle) - CGFloat(sharedInfo.knob_yOffset))
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
        drawResetWheel()
    }
}
