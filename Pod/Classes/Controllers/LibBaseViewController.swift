//
//  LibBaseViewController.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import UIKit

///Classe com diversos métodos para auxiliar no desenvolvimento de view controllers.
open class LibBaseViewController: UIViewController, TaskDelegate {
    
    //MARK: - Variables
    
    //MARK: Menu
    
    ///Variável booleana que indica se o view controller deve cancelar automaticamente as tasks ao passar pelo viewWillDisappear.
    open var cancelTasksOnViewWillDisappear: Bool = true
    
    //MARK: Internet
    
    ///Variável que guarda uma instância da classe `Reachability` para checar conexão com a Internet.
    //TODO
    //fileprivate var reachability    : Reachability!
    
    ///Variável booleana que indica se o view controller possui conexão com a Internet.
    fileprivate var isOnline        : Bool = false
    
    //MARK: - View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupQueue()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if cancelTasksOnViewWillDisappear {
            cancelTasks()
        }
    }
    
    //MARK: - Alert
    
    /**
     Mostra um `UIAlertView` com o título e mensagem passados.
     
     - parameters:
        - title: Título do alerta.
        - message: Mensagem de corpo do alerta. Caso não seja definido, o valor padrão é *nil*.
     */
    open func alert(_ title: String, withMessage message: String? = nil) {
        AlertUtils.alert(title, message: message, onViewController: self)
    }
    
    //MARK: - Navigation Bar
    
    /**
     Mostra a `UINavigationBar` do view controller.
     */
    open func showNavigationBar() {
        NavigationBarUtils.show(self)
        StatusBarUtils.show()
    }
    
    /**
     Esconde a `UINavigationBar` do view controller.
     
     - parameter hideStatusBar: Indica se a `UIStatusBar` também deve ser escondida.
     */
    open func hideNavigationBar(_ hideStatusBar: Bool = false) {
        NavigationBarUtils.hide(self)
        
        if hideStatusBar {
            StatusBarUtils.hide()
        }
    }
    
    //MARK: - Menu
    
    /**
     Ação que faz com que o `SideMenuContainerViewController` altere o estado do menu lateral. Se o menu estiver aberto, fecha e vice-versa.
     
     - important: Caso o view controller não possua uma instância de `SideMenuContainerViewController` (por não ter menu lateral, por exemplo), este método não fará nada.
     
     - parameter sender: O `UIBarButtonItem` responsável por disparar o método.
     */
    open func onClickMenu(_ sender: UIBarButtonItem) {
        guard let menuContainerViewController = menuContainerViewController else {
            return
        }
        
        menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    /**
     Configura o botão que abrirá/fechará o menu lateral com a imagem passada no lado esquerdo da `UINavigationBar` do view controller.
     
     - important: Caso a pilha de view controllers seja maior que 1 (um) elemento ou não exista `UINavigationBar`, o botão não será configurado.
     
     - parameter imageName: O nome da imagem que será usada no botão do menu.
     */
    open func setupMenuButton(_ imageName: String) {
        guard let navigationController = navigationController else {
            return
        }
        
        guard navigationController.viewControllers.count == 1 else {
            return
        }
        
        NavigationBarUtils.setLeftBarButton(UIImage(named: imageName), withTarget: self, andAction: #selector(LibBaseViewController.onClickMenu(_:)))
    }
    
    //MARK: - Web View
    
    /**
     Cria e abre uma instância de `LibWebViewController` com a URL e configurações passadas.
     
     - parameters:
        - url: A string com a URL que se deseja acessar.
        - screenTitle: O nome desejado para a tela. Caso não seja definido, o valor padrão é uma string vazia (`""`).
        - callbackError: O nome da imagem que será usada no botão do menu. Caso não seja definido, o valor padrão é *nil*.
     */
    open func openWebViewWithUrl(_ url: String, andTitle screenTitle: String = "", andErrorCallback callbackError: (() -> Void)? = nil) {
        let web = LibWebViewController(nibName: "LibWebViewController", bundle: Bundle(for: LibWebViewController.classForCoder()))
        web.url = url
        web.screenTitle = screenTitle
        web.callbackError = callbackError
        
        pushViewController(web)
    }
    
    //MARK: - Keyboard
    
    /**
     Mostra o teclado e associa as ações do mesmo ao elemento passado.
     
     - parameter view: Uma view que conforma o protocolo `UIKeyInput`.
     */
    open func showKeyboard(_ view: UIKeyInput?) {
        KeyboardUtils.show(view)
    }
    
    /**
     Esconde o teclado.
     */
    open func hideKeyboard() {
        KeyboardUtils.hide(self.view)
    }
    
    /**
     Registra as notifições de abertura e fechamento do teclado.
     
     As ações de abrir e fechar o teclado estarão associadas aos métodos **keyboardDidShow** e **keyboardDidHide**, respectivamente.
     */
    open func registerKeyboardNotifications() {
        registerNotification(NSNotification.Name.UIKeyboardWillShow.rawValue, withSelector: #selector(keyboardDidShow(_:)))
        registerNotification(NSNotification.Name.UIKeyboardWillHide.rawValue, withSelector: #selector(keyboardDidHide(_:)))
    }
    
    /**
     Método disparado ao abrir o teclado. Por padrão, não há implementação neste método.
     
     - important: Este método não será chamado caso o método **registerKeyboardNotifications** não tenha sido chamado anteriormente.
     Os view controllers que desejarem obter informações do teclado devem sobrescrever este método.
     
     - parameter notification: A notificação com as informações do teclado como tempo de duração da animação, tamanho, etc.
     */
    open func keyboardDidShow(_ notification: Notification) {}
    
    /**
     Método disparado ao fechar o teclado. Por padrão, não há implementação neste método.
     
     - important: Este método não será chamado caso o método **registerKeyboardNotifications** não tenha sido chamado anteriormente.
     Os view controllers que desejarem obter informações do teclado devem sobrescrever este método.
     
     - parameter notification: A notificação com as informações do teclado como tempo de duração da animação, tamanho, etc.
     */
    open func keyboardDidHide(_ notification: Notification) {}
    
    //MARK: - Transition Delegate
    
    /**
     Retorna uma instância de `TransitionDelegate`.
     
     Geralmente não deve ser chamado, a não ser que haja uma necessidade especial.
     */
    open func getTransitionDelegate() -> TransitionDelegate {
        return TransitionDelegate()
    }
    
    /**
     Mostra o view controller passado por cima do view controller atual.
     
     - parameter viewController: O view controller que se deseja mostrar.
     */
    open func showViewControllerOnTop(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.transitioningDelegate = getTransitionDelegate()
        navigationController.modalPresentationStyle = .custom
        
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: - Reachability
    
    /**
     Registra as notificações de mudança no estado da conexão com a Internet.
     
     Quando o estado da conexão mudar, o método **connectionStatusDidChange** será chamado.
     */
    //TODO
    /*
    open func registerNetworkNotification() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            try reachability.startNotifier()
            
            registerNotification(ReachabilityChangedNotification, withSelector: #selector(reachabilityDidChange(_:)))
            
            setReachabilityStatus(reachability)
            
        } catch {
            switch error {
                case ReachabilityError.FailedToCreateWithAddress(_):
                    log("Erro ao registrar notificação de Internet.")
                
                default:
                    break
            }
        }
    }*/
    
    /**
     Método disparado automaticamente nas mudanças de conexão com a Internet. Deve ser transparente para o desenvolvedor.
     
     - important: Este método não deve ser sobrescrito.
     */
    /*//TODO
    open func reachabilityDidChange(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            setReachabilityStatus(reachability)
        }
    }
    */
    /**
     Método que alterará a variável `isOnline` dependendo do estado da conexão com a Internet. Deve ser transparente para o desenvolvedor.
     
     - important: Este método não deve ser sobrescrito.
     */
    /*//TODO
    open func setReachabilityStatus(_ reachability: Reachability) {
        let netStatus = reachability.currentReachabilityStatus
        
        if (netStatus == .reachableViaWiFi || netStatus == .reachableViaWiFi) {
            isOnline = true
        } else {
            isOnline = false
        }
        
        connectionStatusDidChange(isOnline)
    }
    */
    /**
     Indica que houve mudanças na conexão com a Internet.
     
     - important: Este método deve ser sobrescrito, caso haja necessidade de alterar lógica/fluxo em caso de mudança na conexão.
     */
    open func connectionStatusDidChange(_ connected: Bool) {}
    
    //MARK: - Table View Scroll Listener
    
    /**
     Adiciona um listener a table view passada para executar paginação automaticamente.
     
     - important: Caso o closure onScrollGetNextList não seja definido, o comportamento da table view não mudará.
     
     - parameters:
        - tableView: A table view na qual o listener será adicionado.
        - adapter: O adapter responsável por popular a `tableView`.
        - onScrollGetNextList: O bloco que será executado a cada nova paginação.
        - onScrollFinished: O bloco que será executado quando não houver mais novas páginas a serem carregadas.
     */
    open func addEndlessScrollViewListener<T>(_ tableView: UITableView, adapter: BaseAdapter, onScrollGetNextList: ((_ page: Int) throws -> [T])? = nil, onScrollFinished: (() -> Void)? = nil) where T: NSObject {
        
        let endScroll = EndlessScrollViewListener().setViewController(self).setTableView(tableView).setAdapter(adapter).setOnScrollFinished(onScrollFinished).setOnScrollGetNextList(onScrollGetNextList)
        
        tableView.addScrollListener(endScroll)
    }
}
