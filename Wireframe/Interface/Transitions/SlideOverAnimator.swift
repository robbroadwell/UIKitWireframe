//
//  SlideOverAnimator.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/4/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class SlideOverAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let animatingView = transitionContext.view(forKey: .to) ?? transitionContext.view(forKey: .from)!
        
        if presenting {
            animatingView.transform = CGAffineTransform(translationX: -animatingView.frame.size.width, y: 0)
        } else {
            animatingView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        containerView.addSubview(animatingView)
        
        UIView.animate(withDuration: duration, delay:0.0, options: .curveEaseInOut, animations: {
            
            if self.presenting {
                animatingView.transform = CGAffineTransform(translationX: 0, y: 0)
            } else {
                animatingView.transform = CGAffineTransform(translationX: -animatingView.frame.size.width, y: 0)
            }
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }
}
