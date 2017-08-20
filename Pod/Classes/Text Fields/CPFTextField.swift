//
//  CPFTextField.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 05/07/2016.
//
//

import UIKit

open class CPFTextField: UITextField, UITextFieldDelegate {
    
    //MARK: - Variables
    
    fileprivate var onReturn            : (() -> Void)?
    fileprivate var onEditingChanged    : ((_ text: String) -> Void)?
    
    //MARK: - Inits
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
    }
    
    //MARK: - Setups
    
    open func setOnReturn(_ onReturn: (() -> Void)?) {
        self.onReturn = onReturn
    }
    
    open func setOnEditingChanged(_ onEditingChanged: ((_ text: String) -> Void)?) {
        self.onEditingChanged = onEditingChanged
        
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    //MARK: - Toolbar
    
    open func setToolbarWithTitle(_ title: String, andTextColor color: UIColor) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = color
        toolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let closePicker = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickToolbarButton))
        
        toolbar.setItems([spaceButton, closePicker], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        inputAccessoryView = toolbar
    }
    
    //MARK: - Getters
    
    open func getUnmaskedText() -> String {
        guard let text = text , CPFUtils.isValid(string: text) else {
            return ""
        }
        
        return CPFUtils.unmask(string: text)
    }
    
    //MARK: - Actions
    
    func onClickToolbarButton() {
        onReturn?()
    }
    
    //MARK: - Delegate
    
    open func textFieldDidChange(_ textField: UITextField) {
        guard let text = text else {
            return
        }
        
        onEditingChanged?(text)
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let tfText = textField.text else {
            return false
        }
        
        let text = string == "" ? (tfText as NSString).replacingCharacters(in: range, with: string) : tfText + string
        
       /* if (text.length == 11) {
            let maskedText = CPFUtils.mask(string: text)
            
            textField.text = maskedText
            onEditingChanged?(maskedText)
            
            return false
        }
        
        if (CPFUtils.isMasked(string: text) && text.length > 14) {
            return false
        }*/
        
        if (text.characters.count >= 10) {
            let unmaskedText = CPFUtils.unmask(string: text)
            
            textField.text = unmaskedText
            onEditingChanged?(unmaskedText)
            
            return false
        }
        /*
        if (text.length > 0 && !text.isNumber()) {
            return false
        }*/
        
        return true
    }
}
