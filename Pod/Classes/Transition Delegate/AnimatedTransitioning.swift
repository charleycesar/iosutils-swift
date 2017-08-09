//
//  AnimatedTransitioning.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 24/06/2016.
//
//

import UIKit

open class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK: - Variables
    
    open var isPresenting    : Bool = false
    
    //MARK: - View Controller Animated Transitioning
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView = transitionContext.containerView
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        
        if isPresenting {
            toVC.view.frame = inView.frame
            inView.addSubview(toVC.view)
            
            toVC.view.alpha = 0.0
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if (self.isPresenting) {
                toVC.view.alpha = 1.0
            } else {
                fromVC.view.alpha = 0.0
            }
        }, completion: { (finished) in
            transitionContext.completeTransition(true)
        })
    }
}
