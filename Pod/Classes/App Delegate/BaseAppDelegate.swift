//
//  BaseAppDelegate.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import UIKit

///Classe que será responsável por gerenciar os tratamentos automáticos da lib.
@UIApplicationMain
open class BaseAppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Variables
    
    open var window: UIWindow?
    
    //MARK: - Application
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    //MARK: - Configurations
    
    /**
     Retorna uma instância de uma classe que implemente o protocolo `BaseConfigurationDelegate`. Caso não seja sobrescrito, este método retorna uma instância de `BaseBuildConfiguration`.
     
     - returns: A instância de uma classe que implemente `BaseConfigurationDelegate`.
     */
    open func getConfig() -> BaseConfigurationDelegate {
        return BaseBuildConfiguration()
    }
    
    //MARK: - Helpers
    
    /**
     Cria um `UINavigationController` com o `UIViewController` inicial passado e associa a uma `UIWindow`.
     
     - important: Este método só deve ser chamado no didFinishLaunchingWithOptions. É necessário atribuir o retorno deste método ao **window** da classe. Caso contrário, não terá o efeito desejado.
     
     - returns: Uma `UIWindow` configurada para mostrar a primeira tela do aplicativo.
     */
    open func createNavigationController(_ viewController: UIViewController) -> UIWindow {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return window
    }
    
    /**
     Cria um `UITabBarController` com os `UIViewControllers` passados e associa a uma `UIWindow`.
     
     - important: Este método só deve ser chamado no didFinishLaunchingWithOptions. É necessário atribuir o retorno deste método ao **window** da classe. Caso contrário, não terá o efeito desejado.
     
     - returns: Uma `UIWindow` configurada para mostrar as primeiras telas do aplicativo.
     */
    open func createTabBarWithViewControllers(_ viewControllers: [UIViewController]) -> UITabBarController {
        
        var tabs : [UINavigationController] = []
        
        for viewController in viewControllers {
            let navigationController = UINavigationController(rootViewController: viewController)
            tabs.append(navigationController)
        }
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = tabs
        tabBarController.tabBar.barStyle = UIBarStyle.default
        tabBarController.tabBar.isOpaque = true
        tabBarController.tabBar.isTranslucent = false
        
        return tabBarController
    }
}
