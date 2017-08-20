//
//  SideMenuShadow.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import Foundation

open class SideMenuShadow: NSObject {
    
    //MARK: - Variables
    
    open var enabled : Bool = false {
        didSet {
            draw()
        }
    }
    
    open var radius : CGFloat! {
        didSet {
            draw()
        }
    }
    
    open var opacity : CGFloat! {
        didSet {
            draw()
        }
    }
    
    open var color : UIColor! {
        didSet {
            draw()
        }
    }
    
    open var shadowedView    : UIView!
    
    //MARK: - Static Inits
    
    static open func shadowWithView(_ shadowedView: UIView) -> SideMenuShadow {
        let shadow = SideMenuShadow.shadowWithColor(UIColor.black, andRadius: 10.0, andOpacity: 0.75)
        shadow.shadowedView = shadowedView
        return shadow
    }
    
    static open func shadowWithColor(_ color: UIColor, andRadius radius: CGFloat, andOpacity opacity: CGFloat) -> SideMenuShadow {
        let shadow = SideMenuShadow()
        shadow.color = color
        shadow.radius = radius
        shadow.opacity = opacity
        return shadow
    }
    
    //MARK: - Init
    
    override public init() {
        super.init()
        
        self.enabled = true
        self.color = UIColor.black
        self.opacity = 0.75
        self.radius = 10.0
    }
    
    //MARK: - Drawing
    
    open func draw() {
        if enabled {
            show()
        } else {
            hide()
        }
    }
    
    open func show() {
        if (shadowedView == nil) {
            return
        }
        
        var pathRect = self.shadowedView.bounds
        pathRect.size = self.shadowedView.frame.size
        
        //TODO: Tentar fazer a sombra parecer que está no centerViewController e não no leftViewController
        
        shadowedView.layer.shadowPath = UIBezierPath(rect: pathRect).cgPath
        shadowedView.layer.masksToBounds = false
        shadowedView.layer.shadowOpacity = Float(opacity)
        shadowedView.layer.shadowRadius = radius
        shadowedView.layer.shadowColor = color.cgColor
        shadowedView.layer.rasterizationScale = DeviceUtils.getScreenScale()
    }
    
    open func hide() {
        if (shadowedView == nil) {
            return
        }
        
        shadowedView.layer.shadowOpacity = 0.0
        shadowedView.layer.shadowRadius = 0.0
    }
    
    //MARK: - Shadowed View Rotation
    
    open func shadowedViewWillRotate() {
        shadowedView.layer.shadowPath = nil;
        shadowedView.layer.shouldRasterize = true
    }
    
    open func shadowedViewDidRotate() {
        draw()
        shadowedView.layer.shouldRasterize = false
    }
}
