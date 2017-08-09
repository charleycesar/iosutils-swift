//
//  BaseAdapter.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 24/06/2016.
//
//

import UIKit

///Classe que permite o uso do padrão `Adapter` nas `UITableView` dos projetos.
open class BaseAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    ///Não esquecer de guardar uma instância do seu adapter na classe que o utiliza.
    
    //MARK: - Getters
    
    /**
     Método para outras classes acessarem a lista do adapter.
     
     - important: Caso este método seja necessário, cada adapter deverá sobrescrevê-lo e implementá-lo.
     
     - returns: A lista de elementos usado pelo adapter.
    */
    open func getAdapterList<T>() -> [T] where T: NSObject {
        return []
    }
    
    //MARK: - Setters
    
    /**
     Método para sobrescrever a lista do adapter com uma nova lista.
     
     - important: Caso este método seja necessário, cada adapter deverá sobrescrevê-lo e implementá-lo.
     
     - parameter list: A nova lista que será usada pelo adapter.
     */
    open func setNewList<T>(_ list: [T]) where T: NSObject {}
    
    /**
     Método para adicionar novos elementos a lista do adapter.
     
     - important: Caso este método seja necessário, cada adapter deverá sobrescrevê-lo e implementá-lo.
     
     - parameter list: A lista de elementos que se deseja adicionar ao adapter.
     */
    open func addNewElements<T>(_ list: [T]) where T: NSObject {}
    
    //MARK: - Table View Data Source
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //MARK: - Table View Delegate
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
