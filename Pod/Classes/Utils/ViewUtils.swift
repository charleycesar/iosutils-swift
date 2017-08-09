//
//  ViewUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class ViewUtils: NSObject {
    
    static open func shine(_ view: UIView?) {
        guard let view = view else {
            return
        }
        
        CATransaction.begin()
        
        let duration = 1.0
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.masksToBounds = false
        
        let shadowRadius = CABasicAnimation(keyPath: "shadowRadius")
        shadowRadius.fromValue = NSNumber(value: 0.0 as Float)
        shadowRadius.toValue = NSNumber(value: 6.0 as Float)
        shadowRadius.duration = duration
        shadowRadius.autoreverses = true
        
        let shadowOpacity = CABasicAnimation(keyPath: "shadowOpacity")
        shadowOpacity.fromValue = NSNumber(value: 0.6 as Float)
        shadowOpacity.toValue = NSNumber(value: 1.0 as Float)
        shadowOpacity.duration = duration
        shadowOpacity.autoreverses = true
        
        view.layer.add(shadowRadius, forKey: "shadowRadius")
        view.layer.add(shadowOpacity, forKey: "shadowOpacity")
        
        CATransaction.commit()
    }
    
    static open func setGradientEffect(_ view: UIView?, withTopColor topColor: UIColor, andBottomColor bottomColor: UIColor) {
        guard let view = view else {
            return
        }
        
        let theViewGradient = CAGradientLayer()
        theViewGradient.colors = [topColor.cgColor, bottomColor.cgColor]
        theViewGradient.frame = view.bounds
        
        view.layer.insertSublayer(theViewGradient, at: 0)
    }
}
