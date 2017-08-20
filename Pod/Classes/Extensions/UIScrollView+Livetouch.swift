//
//  UIScrollView+Livetouch.swift
//  Pods
//
//  Created by Livetouch BR on 6/22/16.
//
//

import UIKit

public extension UIScrollView {
    
    //MARK: - Keyboard
    
    public func registerKeyboardNotifications() {
        registerNotification(NSNotification.Name.UIKeyboardWillShow.rawValue, withSelector: #selector(keyboardDidShow(_:)))
        registerNotification(NSNotification.Name.UIKeyboardWillHide.rawValue, withSelector: #selector(keyboardDidHide(_:)))
        
        addTapRecognizerToSubview()
    }
    
    public func keyboardDidShow(_ notification: Notification) {
        let height = KeyboardUtils.getKeyboardHeightFromNotification(notification)
        let contentInset = UIEdgeInsetsMake(0, 0, height, 0)
        
        self.contentInset = contentInset
    }
    
    public func keyboardDidHide(_ notification: Notification) {
        let contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.contentInset = contentInset
    }
    
    public func hideKeyboard() {
        KeyboardUtils.hide(self.superview)
    }
    
    //MARK: - Helpers
    
    fileprivate func getCorrectSubviews() -> [UIView] {
        var correctSubviews : [UIView] = []
        
        for view in subviews {
            if (view is UIImageView) {
                continue
            }
            correctSubviews.append(view)
        }
        
        return correctSubviews
    }
    
    //MARK: - Tap Recognizer
    
    fileprivate func addTapRecognizerToSubview() {
        let subviews = getCorrectSubviews()
        
        if (subviews.count > 1) {
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        subviews[0].addGestureRecognizer(tap)
    }
}
