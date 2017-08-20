//
//  UneditableTextField.swift
//  Einstein-Vacinas-iOS
//
//  Created by Livetouch-Mini02 on 3/22/16.
//  Copyright © 2016 livetouch. All rights reserved.
//

import UIKit

class UneditableTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation({
            UIMenuController.shared.setMenuVisible(false, animated: false)
        })
        return super.canPerformAction(action, withSender: sender)
    }
}
