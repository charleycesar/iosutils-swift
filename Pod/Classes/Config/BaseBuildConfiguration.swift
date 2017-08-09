//
//  BaseBuildConfiguration.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import UIKit

///Protocolo que define os métodos de configuração da lib.
public protocol BaseConfigurationDelegate {
    
    /**
     Retorna o nome do arquivo de mensagens do projeto.
     
     - important: O nome do arquivo padrão é **ios_utils_default_messages.json**.
     
     - returns: O nome do arquivo que contém as mensagens padrões utilizadas pelo projeto.
     */
    func getDefaultMessageFilename() -> String
    
    /**
     Retorna uma instância da classe `DatabaseHelper` para auxiliar no gerenciamento de banco de dados.
     
     - throws: Pode lançar uma exceção do tipo **SQLException.DatabaseHelperNotFound**, indicando que a classe não foi encontrada ou não existe no projeto.
     
     - returns: Retorna uma instância da classe `DatabaseHelper`.
     */
    func getDatabaseHelper() throws -> DatabaseHelper
}

///Classe que implementa o protocolo `BaseConfigurationDelegate` e auxilia as outras classes da lib nos tratamentos automáticos.
open class BaseBuildConfiguration: NSObject, BaseConfigurationDelegate {
    
    /**
     Retorna o nome do arquivo de mensagens do projeto.
     
     - important: O nome do arquivo padrão é **ios_utils_default_messages.json**.
     
     - returns: O nome do arquivo que contém as mensagens padrões utilizadas pelo projeto.
     */
    open func getDefaultMessageFilename() -> String {
        return "ios_utils_default_messages.json"
    }
    
    /**
     Retorna uma instância da classe `DatabaseHelper` para auxiliar no gerenciamento de banco de dados.
     
     - important: Por padrão, este método lança uma exceção.
     
     - throws: Pode lançar uma exceção do tipo **SQLException.DatabaseHelperNotFound**, indicando que a classe não foi encontrada ou não existe no projeto.
     
     - returns: Retorna uma instância da classe `DatabaseHelper`.
     */
    open func getDatabaseHelper() throws -> DatabaseHelper {
        throw SQLException.databaseHelperNotFound
    }
}
