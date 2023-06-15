//
//  MarkGestureRecognizer.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 20.05.2023.
//
//<a href="https://www.freepik.com/free-vector/golden-metal-fence-mesh-pattern-gold-wire-grid_30157926.htm#query=net%20cartoon&position=3&from_view=search&track=ais">Image by upklyak</a> on Freepik

import UIKit
import UIKit.UIGestureRecognizerSubclass

class MarkGestureRecognizer: UIGestureRecognizer {

    private var touchedPoints = [CGPoint]()
    var path = CGMutablePath()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        if touches.count != 1 {
            state = .failed
        } else {
            state = .began
        }
        
        let window = view?.window
        if let loc = touches.first?.location(in: window) {
            path.addLine(to: loc) // start the path
            drawPoin(point: loc)
        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
        
//        for loc in touchedPoints {
//            path.addLine(to: loc)
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .failed{
            return
        }
        
        
        let window = view?.window
        if let loc = touches.first?.location(in: window){
            touchedPoints.append(loc)
//            var rec = CGRect(origin: loc, size: CGSize(width: 5, height: 5) )
            
            
            
            state = .changed
            print("We have touch = \(loc)")
            path.addLine(to: loc)
//            CGPathAddLineToPoint(path, nil, loc.x, loc.y)
//            view?.draw(rec)
            drawPoin(point: loc)
            
        }
    }
    
    func drawPoin(point: CGPoint){
        let pointView = UIView(frame: CGRect(x: point.x, y: point.y, width: 10, height: 10))

        print("Drawing point: \(point)")
               //Round the view's corners so that it is a circle, not a square
        pointView.layer.cornerRadius = 5

               //Give the view a background color (in this case, blue)
        pointView.backgroundColor = .blue

               //Add the view as a subview of the current view controller's view
        self.view?.addSubview(pointView )
        
//        let v = self.view as! UIImageView
//        UIGraphicsBeginImageContext.
    }
}
