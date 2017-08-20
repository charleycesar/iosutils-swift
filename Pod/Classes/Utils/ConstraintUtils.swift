//
//  ContraintUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class ConstraintUtils: NSObject {
    
    //MARK: - Multiplier
    
    /**
     Modifica o mutiplicador de uma constraint de uma View.
     
     - Parameters:
        - constraint: A contraint que irá ser modificada.
     
        - value: O novo valor do multiplicador.
     
        - view: A view na qual se encontra a contraint
     
     - Returns: A constraint com o multiplicador modificado.
     */
    static open func changeConstraintMultiplier(_ constraint: NSLayoutConstraint, toValue value: CGFloat, inView view: UIView) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: value, constant: constraint.constant)
        
        newConstraint.priority = constraint.priority;
        
        if (DeviceUtils.isIOS8()) {
            NSLayoutConstraint.deactivate([constraint])
            NSLayoutConstraint.activate([newConstraint])
        } else {
            view.removeConstraint(constraint)
            view.addConstraint(newConstraint)
        }
        
        return newConstraint
    }
}
