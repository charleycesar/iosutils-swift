//
//  AlertUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import UIKit

///Classe responsável por mostrar alertas ao usuário.
open class AlertUtils {
    
    /**
        Cria um Alert para uma ViewController.
        - Parameters:
            - title:          String do título do Alert. Caso não seja definido, o valor padrão será nil.
            - message:        String da mensagem que irá ser mostrada. Caso não seja definido, o valor padrão será nil.
            - cancelText:     String do texto que irá aparecer no botão de cancelar. Caso não seja definido, o valor padrão será nil.
            - okText:         String do texto que irá aparecer no botão de OK. Caso não seja definido, o valor padrão será nil.
            - viewController: A View na qual o Alert será atribuido. Caso não seja definido, o valor padrão será nil.
            - handler:        Ação que será executado ao clicar no botão. Caso não seja definido, o valor padrão será nil.
    */
    static open func alert(_ title: String? = nil, message: String? = nil, cancelText: String? = nil, okText: String? = nil, onViewController viewController: UIViewController? = nil, withHandler handler: ((_ action: UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let cancelText = cancelText {
            alertController.addAction(UIAlertAction(title: cancelText, style: UIAlertActionStyle.cancel, handler: handler))
        }
        
        if let okText = okText {
            alertController.addAction(UIAlertAction(title: okText, style: UIAlertActionStyle.default, handler: handler))
        }
        
        if (alertController.actions.isEmpty) {
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: handler))
        }
        
        
        if let viewController = viewController {
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            alertController.show()
        }
    }
    
    /**
     Cria um Alert do tipo Sheet para uma ViewController.
     
     - Parameters:
        - title:          String do título do Alert.
        - message:        String da mensagem que irá ser mostrada. Caso não seja definido, o valor padrão será nil.
        - actions:        Ações que serão atribuidos ao Alert.
        - viewController: A View na qual o Alert será atribuido. Caso não seja definido, o valor padrão será nil.
     */
    static open func actionSheet(_ title: String, withMessage message: String? = nil, andActions actions: [UIAlertAction], onViewController viewController: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        
        if let viewController = viewController {
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            alertController.show()
        }
    }
}
