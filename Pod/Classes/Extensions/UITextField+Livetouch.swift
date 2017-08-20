//
//  UITextField+Livetouch.swift
//  NutrabemV2-iOS
//
//  Created by Livetouch Brasil on 9/10/15.
//  Copyright (c) 2015 Marco Velloni. All rights reserved.
//

import Foundation

public extension UITextField {
    
    //MARK: - Padding
    
    public func setLeftPadding(_ padding: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        view.backgroundColor = UIColor.clear
        
        self.leftView = view
        self.leftViewMode = UITextFieldViewMode.always
    }
    
    public func setRightPadding(_ padding: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        view.backgroundColor = UIColor.clear
        
        self.rightView = view
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    //MARK: - Picker View
    
    public func setPickerView(_ pickerView: UIPickerView) {
        self.inputView = pickerView
    }
    
    public func setToolbar(_ toolbar: UIToolbar) {
        self.inputAccessoryView = toolbar
    }
}
