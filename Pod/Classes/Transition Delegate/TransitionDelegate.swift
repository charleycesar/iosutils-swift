//
//  TransitionDelegate.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 24/06/2016.
//
//

import UIKit

open class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    //MARK: - View Controller Transitioning Delegate
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AnimatedTransitioning()
        controller.isPresenting = true
        return controller
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AnimatedTransitioning()
        controller.isPresenting = false
        return controller
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
