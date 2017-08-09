//
//  BasePickerAdapter.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 28/06/2016.
//
//

import UIKit

///Classe que permite o uso do padrão `Adapter` nas `UIPickerView` dos projetos.
open class BasePickerAdapter: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    ///Não esquecer de guardar uma instância do seu adapter na classe que o utiliza.
    
    //MARK: - Picker View Data Source
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    //MARK: - Picker View Delegate
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nil
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {}
}
