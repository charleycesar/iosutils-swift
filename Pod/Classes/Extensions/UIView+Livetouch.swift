//
//  UIView+Livetouch.swift
//  PortoSeguroCartoes
//
//  Created by livetouch on 4/12/15.
//  Copyright © 2015 Livetouch Brasil. All rights reserved.
//

import Foundation

public extension UIView {
    
    //MARK: - Static Functions
    
    static func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func roundView(coners: UIRectCorner, withSize size: CGSize) {
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: coners, cornerRadii:size)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

