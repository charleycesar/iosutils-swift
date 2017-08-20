//
//  UIPickerView+Livetouch.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 28/06/2016.
//
//

import UIKit

public extension UIPickerView {
    
    //MARK: - Adapter
    
    public func setAdapter(_ adapter: BasePickerAdapter) {
        self.dataSource = adapter
        self.delegate = adapter
    }
}
