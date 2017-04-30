//
//  CircularTransition.swift
//  CircularTransition
//
//  Created by Arek on 30.04.2017.
//  Copyright © 2017 Arek. All rights reserved.
//

import UIKit
enum CircularTransitionMode: Int{
    case present, dismiss, pop
}
class CircularTransition: NSObject {
    var circle = UIView();
    var circleColor = UIColor.white;
    var duration = 0.3;
    var transitionMode: CircularTransitionMode = .present;
    var startingPoint = CGPoint.zero{
        didSet{
            circle.center = startingPoint;
        }
    }
    func frameForCircle(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect{
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x);
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y);
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2;
        let size = CGSize(width: offestVector, height: offestVector);
        
        return CGRect(origin: CGPoint.zero, size: size);
    }
}
extension CircularTransition: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration;
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView;
        
        if transitionMode == .present{
            if let presendetView = transitionContext.view(forKey: .to){
                let viewCenter = presendetView.center;
                let viewSize = presendetView.frame.size;
                
                circle = UIView();
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint);
                circle.layer.cornerRadius = circle.frame.size.height/2;
                circle.center = startingPoint;
                circle.backgroundColor = circleColor;
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
                containerView.addSubview(circle);
                
                presendetView.center = startingPoint;
                presendetView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
                presendetView.alpha = 0;
                containerView.addSubview(presendetView);
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity;
                    presendetView.transform = CGAffineTransform.identity;
                    presendetView.alpha = 1;
                    presendetView.center = viewCenter;
                }, completion: {(success: Bool) in
                    transitionContext.completeTransition(success);
                })
            }
        }
        else{
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from;
            
            if let returningView = transitionContext.view(forKey: transitionModeKey){
                let viewCenter = returningView.center;
                let viewSize = returningView.frame.size;
                
                 circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint);
                circle.layer.cornerRadius = circle.frame.size.height/2;
                circle.center = startingPoint;

                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
                    returningView.center = self.startingPoint;
                    returningView.alpha = 0;
                    
                    if self.transitionMode == .pop{
                        containerView.insertSubview(returningView, belowSubview: returningView);
                        containerView.insertSubview(self.circle, belowSubview: returningView);
                    }
                }, completion: {(success: Bool) in
                    returningView.center = viewCenter;
                    returningView.removeFromSuperview();
                    self.circle.removeFromSuperview();
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
}
