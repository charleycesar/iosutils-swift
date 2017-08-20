//
//  NavigationBarUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 21/06/2016.
//
//

import UIKit

open class NavigationBarUtils: NSObject {
    
    //MARK: - Get
    
    static open func get(_ viewController: UIViewController) -> UINavigationBar? {
        guard let navigationController = viewController.navigationController else {
            return nil
        }
        
        return navigationController.navigationBar
    }
    
    //MARK: - Information
    
    static open func getHeight(_ viewController: UIViewController) -> CGFloat {
        guard let navigationBar = get(viewController) else {
            return 0.0
        }
        
        NavigationBarUtils.show(viewController)
        
        let height = navigationBar.frame.height
        return height
    }
    
    //MARK: - Show/Hide
    
    /**
     *  Método para mostrar a UINavigationBar no UIViewController passado.
     *
     *  - parameter viewController O UIViewController em que se deseja mostrar a navigation bar.
     *
     */
    static open func show(_ viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.isHidden = false
    }
    
    static open func hide(_ viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.isHidden = true
    }
    
    static open func hideBorder(_ viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - Layout
    
    static open func setTranslucent(_ viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.isTranslucent = true
        navigationBar.isOpaque = false
    }
    
    static open func setOpaque(_ viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
    }
    
    static open func setTitle(_ title: String, forViewController viewController: UIViewController) {
        viewController.navigationItem.title = title
    }
    
    static open func setTitleColor(_ color: UIColor, andFont font: UIFont = UIFont.systemFont(ofSize: 17.0), forViewController viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
    }
    
    static open func setTitleAttributes(_ titleAttributes: [String: AnyObject], forViewController viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.titleTextAttributes = titleAttributes
    }
    
    /**
        Altera a cor dos navigation items e bar buttons da navigation bar.
     
        - parameter color: Cor desejada.
        - parameter viewController: O view controller em que se deseja alterar a tintColor da navigation bar.
    */
    static open func setTintColor(_ color: UIColor, forViewController viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.tintColor = color
    }
    
    /**
         Altera a cor de fundo da navigation bar.
         
         - parameter color: Cor desejada.
         - parameter viewController: O view controller em que se deseja alterar a barTintColor da navigation bar.
     */
    static open func setBackgroundColor(_ color: UIColor, forViewController viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.barTintColor = color
    }
    
    //MARK: - Back Button
    
    static open func setBackBarButtonWithTitle(_ title: String, forViewController viewController: UIViewController) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backButton
    }
    
    static open func setBackBarButtonWithImage(_ image: UIImage?, forViewController viewController: UIViewController) {
        guard let navigationBar = get(viewController) else {
            return
        }
        
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK: - Left Button
    
    static open func setLeftBarButton(_ object: AnyObject?, withTarget target: UIViewController, andAction action: Selector) {
        var leftButton : UIBarButtonItem?
        
        if let title = object as? String {
            leftButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        } else if let image = object as? UIImage {
            leftButton = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        }
        
        if let leftButton = leftButton {
            target.navigationItem.leftBarButtonItem = leftButton
        }
    }
    
    static open func setLeftSystemButton(_ systemItem: UIBarButtonSystemItem, onTarget target: UIViewController, andAction action: Selector) {
        let leftButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        target.navigationItem.leftBarButtonItem = leftButton
    }
    
    static open func setLeftImage(_ image: UIImage?, onViewController viewController: UIViewController) {
        guard let image = image else {
            return
        }
        
        let leftButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        leftButton.isEnabled = false
        
        viewController.navigationItem.leftBarButtonItem = leftButton
    }
    
    //MARK: - Right Button
    
    static open func setRightBarButton(_ object: AnyObject?, withTarget target: UIViewController, andAction action: Selector) {
        var rightButton : UIBarButtonItem?
        
        if let title = object as? String {
            rightButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        } else if let image = object as? UIImage {
            rightButton = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        }
        
        if let rightButton = rightButton {
            target.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    static open func setRightSystemButton(_ systemItem: UIBarButtonSystemItem, onTarget target: UIViewController, andAction action: Selector) {
        let rightButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        target.navigationItem.rightBarButtonItem = rightButton
    }
    
    static open func setRightImage(_ image: UIImage?, onViewController viewController: UIViewController) {
        guard let image = image else {
            return
        }
        
        let rightButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        rightButton.isEnabled = false
        
        viewController.navigationItem.rightBarButtonItem = rightButton
    }
}
