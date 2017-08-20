//
//  SideMenuContainerViewController.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import Foundation

open class SideMenuContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Variables
    
    fileprivate var _centerViewController   :UIViewController?
    
    fileprivate var centerViewController    :UIViewController? {
        get {
            return _centerViewController
        }
        
        set {
            removeCenterGestureRecognizers()
            removeChildViewControllerFromContainer(_centerViewController)
            
            guard let newValue = newValue else {
                return
            }
            
            var origin : CGPoint!
            if let oldCenter = _centerViewController {
                origin = oldCenter.view.frame.origin
            } else {
                origin = CGPoint.zero
            }
            
            _centerViewController = newValue
            
            if (centerViewController == nil) {
                return
            }
            
            addChildViewController(newValue)
            view.addSubview(newValue.view)
            newValue.view.frame = CGRect(x: origin.x, y: origin.y, width: newValue.view.frame.width, height: newValue.view.frame.height)
            
            newValue.didMove(toParentViewController: self)
            
            if (shadow != nil) {
                shadow.shadowedView = newValue.view
            } else {
                shadow = SideMenuShadow.shadowWithView(newValue.view)
            }
            
            shadow.draw()
            addCenterGestureRecognizers()
        }
    }
    
    fileprivate var _leftMenuViewController  : UIViewController?
    
    fileprivate var leftMenuViewController  : UIViewController? {
        get {
            return _leftMenuViewController
        }
        
        set {
            removeChildViewControllerFromContainer(leftMenuViewController)
            
            _leftMenuViewController = newValue
            
            guard let leftMenuViewController = leftMenuViewController else {
                return
            }
            addChildViewController(leftMenuViewController)
            if let menuContainerView = menuContainerView {
                if (menuContainerView.superview != nil) {
                    menuContainerView.insertSubview(leftMenuViewController.view, at: 0)
                }
            }
            
            leftMenuViewController.didMove(toParentViewController: self)
            
            if viewHasAppeared {
                setLeftSideMenuFrameToClosedPosition()
            }
        }
    }
    
    
    fileprivate var _rightMenuViewController : UIViewController?
        
    fileprivate var rightMenuViewController : UIViewController? {
        get {
            return _rightMenuViewController
        }
        
        set {
            removeChildViewControllerFromContainer(_rightMenuViewController)
            
            _rightMenuViewController = newValue
            
            guard let rightMenuViewController = _rightMenuViewController else {
                return
            }
            
            addChildViewController(rightMenuViewController)
            if let menuContainerView = menuContainerView {
                if (menuContainerView.superview != nil) {
                    menuContainerView.insertSubview(rightMenuViewController.view, at: 0)
                }
            }
            
            rightMenuViewController.didMove(toParentViewController: self)
            
            if viewHasAppeared {
                setRightSideMenuFrameToClosedPosition()
            }
        }
    }
    
    fileprivate var menuState   : SideMenuState = .closed
    
    fileprivate var panMode     : SideMenuPanMode = .default
    
    // menu open/close animation duration -- user can pan faster than default duration, max duration sets the limit
    fileprivate var menuAnimationDefaultDuration    : CGFloat!
    fileprivate var menuAnimationMaxDuration        : CGFloat!
    
    // width of the side menus
    fileprivate var menuWidth       : CGFloat!
    fileprivate var leftMenuWidth   : CGFloat!
    fileprivate var rightMenuWidth  : CGFloat!
    
    // shadow
    fileprivate var shadow  : SideMenuShadow!
    
    // menu slide-in animation
    fileprivate var menuSlideAnimationEnabled   : Bool = false
    fileprivate var menuSlideAnimationFactor    : CGFloat! // higher = less menu movement on animation
    
    fileprivate var menuContainerView   : UIView?
    
    fileprivate var panGestureOrigin    : CGPoint!
    fileprivate var panGestureVelocity  : CGFloat!
    
    fileprivate var panDirection    : SideMenuPanDirection = .none
    
    fileprivate var viewHasAppeared : Bool = false
    
    //MARK: - Static Inits
    
    static open func containerWithCenterViewController(_ centerViewController: UIViewController, andLeftMenuViewController leftMenuViewController: UIViewController?, andRightMenuViewController rightMenuViewController: UIViewController?) -> SideMenuContainerViewController {
        
        let controller = SideMenuContainerViewController()
        controller.leftMenuViewController = leftMenuViewController
        controller.centerViewController = centerViewController
        controller.rightMenuViewController = rightMenuViewController
        return controller
    }
    
    //MARK: - Inits
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setDefaultSettings()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.setDefaultSettings()
    }
    
    //MARK: - Setups
    
    open func setDefaultSettings() {
        if (menuContainerView != nil) {
            return
        }
        
        menuContainerView = UIView()
        menuState = .closed
        menuWidth = 270.0
        leftMenuWidth = 0.0
        rightMenuWidth = 0.0
        menuSlideAnimationFactor = 3.0
        menuAnimationDefaultDuration = 0.2
        menuAnimationMaxDuration = 0.4
        panMode = .default
        panGestureVelocity = 0.0
        viewHasAppeared = false
    }
    
    open func setupMenuContainerView() {
        guard let menuContainerView = menuContainerView else {
            return
        }
        
        if (menuContainerView.superview != nil) {
            return
        }
        
        menuContainerView.frame = self.view.bounds
        menuContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.insertSubview(menuContainerView, at: 0)
        
        if let leftMenuViewController = leftMenuViewController , leftMenuViewController.view.superview == nil {
            menuContainerView.addSubview(leftMenuViewController.view)
        }
        
        if let rightMenuViewController = rightMenuViewController , rightMenuViewController.view.superview == nil {
            menuContainerView.addSubview(rightMenuViewController.view)
        }
    }
    
    //MARK: - View Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewHasAppeared {
            setupMenuContainerView()
            setLeftSideMenuFrameToClosedPosition()
            setRightSideMenuFrameToClosedPosition()
            addGestureRecognizers()
            
            shadow.draw()
            
            viewHasAppeared = true
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, 0, 0)
        if let leftMenuViewController = leftMenuViewController , leftMenuViewController.automaticallyAdjustsScrollViewInsets {
            if let scrollView = leftMenuViewController.view as? UIScrollView {
                scrollView.contentInset = insets
            }
        }
        if let rightMenuViewController = rightMenuViewController , rightMenuViewController.automaticallyAdjustsScrollViewInsets {
            if let scrollView = rightMenuViewController.view as? UIScrollView {
                scrollView.contentInset = insets
            }
        }
    }
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let centerViewController = centerViewController {
            if let centerViewController = centerViewController as? UINavigationController {
                if let topViewController = centerViewController.topViewController {
                    return topViewController.preferredStatusBarStyle
                }
            }
            
            return centerViewController.preferredStatusBarStyle
        }
        return .default
    }
    
    //MARK: - Rotation
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if let centerViewController = centerViewController {
            if let navigationController = centerViewController as? UINavigationController {
                if let topViewController = navigationController.topViewController {
                    return topViewController.supportedInterfaceOrientations
                }
            }
            return centerViewController.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate : Bool {
        if let centerViewController = centerViewController {
            if let navigationController = centerViewController as? UINavigationController {
                if let topViewController = navigationController.topViewController {
                    return topViewController.shouldAutorotate
                }
            }
            return centerViewController.shouldAutorotate
        }
        return true
    }
    
    open override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        if let centerViewController = centerViewController {
            if let navigationController = centerViewController as? UINavigationController {
                if let topViewController = navigationController.topViewController {
                    return topViewController.preferredInterfaceOrientationForPresentation
                }
            }
            return centerViewController.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        shadow.shadowedViewWillRotate()
    }
    
    //MARK: - View Controller Containment
    
    open func removeChildViewControllerFromContainer(_ childViewController: UIViewController?) {
        guard let childViewController = childViewController else {
            return
        }
        
        childViewController.willMove(toParentViewController: nil)
        childViewController.removeFromParentViewController()
        childViewController.view.removeFromSuperview()
    }
    
    //MARK: - Gesture Recognizer Helpers
    
    open func panGestureRecognizer() -> UIPanGestureRecognizer {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(SideMenuContainerViewController.handlePan(_:)))
        
        recognizer.maximumNumberOfTouches = 1
        recognizer.delegate = self
        
        return recognizer
    }
    
    open func centerTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SideMenuContainerViewController.centerViewControllerTapped))
        tapRecognizer.delegate = self
        return tapRecognizer
    }
    
    open func addGestureRecognizers() {
        addCenterGestureRecognizers()
        menuContainerView?.addGestureRecognizer(panGestureRecognizer())
    }
    
    open func addCenterGestureRecognizers() {
        if let centerViewController = centerViewController {
            centerViewController.view.addGestureRecognizer(centerTapGestureRecognizer())
            centerViewController.view.addGestureRecognizer(panGestureRecognizer())
        }
    }
    
    open func removeCenterGestureRecognizers() {
        if let centerViewController = centerViewController {
            centerViewController.view.removeGestureRecognizer(centerTapGestureRecognizer())
            centerViewController.view.removeGestureRecognizer(panGestureRecognizer())
        }
    }
    
    //MARK: - Menu State
    
    open func toggleLeftSideMenuCompletion(_ completion: (() -> Void)?) {
        if (menuState == .leftMenuOpen) {
            setMenuState(.closed, completion: completion)
        } else {
            setMenuState(.leftMenuOpen, completion: completion)
        }
    }
    
    open func toggleRightSideMenuCompletion(_ completion: (() -> Void)?) {
        if (menuState == .rightMenuOpen) {
            setMenuState(.closed, completion: completion)
        } else {
            setMenuState(.rightMenuOpen, completion: completion)
        }
    }
    
    open func openLeftSideMenuCompletion(_ completion: (() -> Void)?) {
        guard let leftMenuViewController = leftMenuViewController else {
            return
        }
        
        menuContainerView?.bringSubview(toFront: leftMenuViewController.view)
        setCenterViewControllerOffset(leftMenuWidth, animated: true, completion:completion)
    }
    
    open func openRightSideMenuCompletion(_ completion: (() -> Void)?) {
        guard let rightMenuViewController = rightMenuViewController else {
            return
        }
        
        menuContainerView?.bringSubview(toFront: rightMenuViewController.view)
        setCenterViewControllerOffset(-rightMenuWidth, animated: true, completion:completion)
    }
    
    open func closeSideMenuCompletion(_ completion: (() -> Void)?) {
        setCenterViewControllerOffset(0.0, animated: true, completion: completion)
    }
    
    open func setMenuState(_ menuState: SideMenuState, completion: (() -> Void)? = nil) {
        let innerCompletion = {
            self.menuState = menuState
            
            self.setUserInteractionStateForCenterViewController()
            let eventType : SideMenuStateEvent = self.menuState == .closed ? .didClose : .didOpen
            self.sendStateEventNotification(eventType)
            
            if let completion = completion {
                completion()
            }
        }
        
        switch (menuState) {
        case .closed:
            sendStateEventNotification(.willClose)
            
            closeSideMenuCompletion({
                self.leftMenuViewController?.view.isHidden = true
                self.rightMenuViewController?.view.isHidden = true
                innerCompletion()
            })
            
        case .leftMenuOpen:
            if (leftMenuViewController == nil) {
                return
            }
            
            sendStateEventNotification(.willOpen)
            leftMenuWillShow()
            openLeftSideMenuCompletion(innerCompletion)
            
        case .rightMenuOpen:
            if (rightMenuViewController == nil){
                return
            }
            sendStateEventNotification(.willOpen)
            rightMenuWillShow()
            openRightSideMenuCompletion(innerCompletion)
        }
    }
    
    // these callbacks are called when the menu will become visible, not neccessarily when they will OPEN
    
    open func leftMenuWillShow() {
        if let leftMenuViewController = leftMenuViewController {
            leftMenuViewController.view.isHidden = false
            menuContainerView?.bringSubview(toFront: leftMenuViewController.view)
        }
    }
    
    open func rightMenuWillShow() {
        if let rightMenuViewController = rightMenuViewController {
            rightMenuViewController.view.isHidden = false
            menuContainerView?.bringSubview(toFront: rightMenuViewController.view)
        }
    }
    
    //MARK: - State Event Notification
    
    open func sendStateEventNotification(_ event: SideMenuStateEvent) {
        NotificationUtils.postNotification(SideMenuStateNotificationEvent, withObject: event.rawValue as AnyObject)
    }
    
    //MARK: - Side Menu Positioning
    
    open func setLeftSideMenuFrameToClosedPosition() {
        guard let leftMenuViewController = leftMenuViewController else {
            return
        }
        
        var leftFrame = leftMenuViewController.view.frame
        leftFrame.size.width = leftMenuWidth
        leftFrame.origin.x = menuSlideAnimationEnabled ? -leftFrame.size.width / menuSlideAnimationFactor : 0.0
        leftFrame.origin.y = 0.0
        leftMenuViewController.view.frame = leftFrame
        leftMenuViewController.view.autoresizingMask = [.flexibleRightMargin, .flexibleHeight]
    }
    
    open func setRightSideMenuFrameToClosedPosition() {
        guard let rightMenuViewController = rightMenuViewController else {
            return
        }
        
        var rightFrame = rightMenuViewController.view.frame
        rightFrame.size.width = leftMenuWidth
        rightFrame.origin.x = menuSlideAnimationEnabled ? -rightFrame.size.width / menuSlideAnimationFactor : 0.0
        rightFrame.origin.y = 0.0
        rightMenuViewController.view.frame = rightFrame
        rightMenuViewController.view.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
    }
    
    open func alignLeftMenuControllerWithCenterViewController() {
        guard let leftMenuViewController = leftMenuViewController else {
            return
        }
        
        var leftMenuFrame = leftMenuViewController.view.frame
        leftMenuFrame.size.width = leftMenuWidth
        
        var xOffset: CGFloat = 0
        if let centerViewController = centerViewController {
            xOffset = centerViewController.view.frame.origin.x
        }
        
        let xPositionDivider = menuSlideAnimationEnabled ? self.menuSlideAnimationFactor : 1.0
        leftMenuFrame.origin.x = xOffset / xPositionDivider! - leftMenuWidth / xPositionDivider!
        
        leftMenuViewController.view.frame = leftMenuFrame
    }
    
    open func alignRightMenuControllerWithCenterViewController() {
        guard let rightMenuViewController = rightMenuViewController else {
            return
        }
        
        guard let menuContainerView = menuContainerView else {
            return
        }
        
        var rightMenuFrame = rightMenuViewController.view.frame
        rightMenuFrame.size.width = rightMenuWidth
        
        var xOffset: CGFloat = 0
        if let centerViewController = centerViewController {
            xOffset = centerViewController.view.frame.origin.x
        }
        
        let xPositionDivider = menuSlideAnimationEnabled ? self.menuSlideAnimationFactor : 1.0
        
        rightMenuFrame.origin.x = menuContainerView.frame.size.width - rightMenuWidth + xOffset / xPositionDivider! + rightMenuWidth / xPositionDivider!
        
        rightMenuViewController.view.frame = rightMenuFrame
    }
    
    //MARK: - Side Menu Width
    
    open func setMenuWidth(_ menuWidth: CGFloat, animated: Bool = true) {
        setLeftMenuWidth(menuWidth, animated: animated)
        setRightMenuWidth(menuWidth, animated: animated)
    }
    
    open func setLeftMenuWidth(_ leftMenuWidth: CGFloat, animated: Bool = true) {
        self.leftMenuWidth = leftMenuWidth
        
        if (menuState != .leftMenuOpen) {
            setLeftSideMenuFrameToClosedPosition()
            return
        }
        
        let offset = self.leftMenuWidth
        let effects = {
            self.alignLeftMenuControllerWithCenterViewController()
        }
        
        setCenterViewControllerOffset(offset!, additionalAnimations: effects, animated: animated, completion: nil)
    }
    
    open func setRightMenuWidth(_ rightMenuWidth: CGFloat, animated: Bool = true) {
        self.rightMenuWidth = rightMenuWidth
        
        if (menuState != .rightMenuOpen) {
            setRightSideMenuFrameToClosedPosition()
            return
        }
        
        let offset = -self.rightMenuWidth
        let effects = {
            self.alignRightMenuControllerWithCenterViewController()
        }
        
        setCenterViewControllerOffset(offset, additionalAnimations: effects, animated: animated, completion: nil)
    }
    
    //MARK: - Side Menu Pan Mode
    
    open func centerViewControllerPanEnabled() -> Bool {
        return self.panMode == .default || self.panMode == .centerViewController
    }
    
    open func sideMenuPanEnabled() -> Bool {
        return self.panMode == .default || self.panMode == .sideMenu
    }
    
    //MARK: - Setters
    
    open func setShadowRadius(_ radius: CGFloat) {
        if (shadow != nil) {
            shadow.radius = radius
        }
    }
    
    open func setPanMode(_ panMode: SideMenuPanMode) {
        self.panMode = panMode
    }
    
    open func setShadow(_ shadow: SideMenuShadow) {
        self.shadow = shadow
    }
    
    //MARK: - Getters
    
    open func getCenterViewController() -> UIViewController? {
        return centerViewController
    }
    
    open func getLeftMenuViewController() -> UIViewController? {
        return leftMenuViewController
    }
    
    open func getRightMenuViewController() -> UIViewController? {
        return rightMenuViewController
    }
    
    open func getMenuState() -> SideMenuState {
        return menuState
    }
    
    open func getPanMode() -> SideMenuPanMode {
        return panMode
    }
    
    open func getMenuWidth() -> CGFloat {
        return menuWidth
    }
    
    open func getLeftMenuWidth() -> CGFloat {
        return leftMenuWidth
    }
    
    open func getRightMenuWidth() -> CGFloat {
        return rightMenuWidth
    }
    
    open func getShadow() -> SideMenuShadow {
        return shadow
    }
    
    //MARK: - Gesture Recognizer Delegate
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (gestureRecognizer is UITapGestureRecognizer && menuState != .closed) {
            return true
        }
        
        if (gestureRecognizer is UIPanGestureRecognizer) {
            guard let gestureView = gestureRecognizer.view else {
                return false
            }
            
            if let centerViewController = centerViewController {
                if (gestureView.isEqual(centerViewController.view)) {
                    return self.centerViewControllerPanEnabled()
                }
            }

            if (gestureView.isEqual(menuContainerView)) {
                return sideMenuPanEnabled()
            }
            
            // pan gesture is attached to a custom view
            return true
        }
        
        return false
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
            let isHorizontalPanning = fabs(velocity.x) > fabs(velocity.y)
            return isHorizontalPanning
        }
        
        return true
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //MARK: - Gesture Recognizer Callbacks
    
    open func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        var origin: CGPoint!
        var view: UIView? = nil
        if let centerViewController = centerViewController {
            view = centerViewController.view
            origin = view!.frame.origin
        } else {
            origin = CGPoint.zero
        }
        
        if (recognizer.state == .began) {
            panGestureOrigin = origin
            panDirection = .none
        }
        
        if (panDirection == .none) {
            let translatedPoint = recognizer.translation(in: view)
            if (translatedPoint.x > 0.0) {
                panDirection = .right
                if (leftMenuViewController != nil && menuState == .closed) {
                    leftMenuWillShow()
                }
            } else if (translatedPoint.x < 0.0) {
                panDirection = .left
                if (rightMenuViewController != nil && menuState == .closed) {
                    rightMenuWillShow()
                }
            }
        }
        
        if ((menuState == .rightMenuOpen && panDirection == .left) || (menuState == .leftMenuOpen && panDirection == .right)) {
            panDirection = .none
            return
        }
        
        if (panDirection == .left) {
            handleLeftPan(recognizer)
        } else if (panDirection == .right) {
            handleRightPan(recognizer)
        }
    }
    
    open func handleLeftPan(_ recognizer: UIPanGestureRecognizer) {
        if (rightMenuViewController == nil && menuState == .closed) {
            return
        }
        
        var size: CGSize!
        var view: UIView? = nil
        if let centerViewController = centerViewController {
            view = centerViewController.view
            size = view!.frame.size
        } else {
            size = CGSize.zero
        }
        
        var translatedPoint = recognizer.translation(in: view)
        let adjustedOrigin = panGestureOrigin
        translatedPoint = CGPoint(x: (adjustedOrigin?.x)! + translatedPoint.x, y: (adjustedOrigin?.y)! + translatedPoint.y)
        
        translatedPoint.x = max(translatedPoint.x, -rightMenuWidth)
        translatedPoint.x = min(translatedPoint.x, leftMenuWidth)
        
        if (menuState == .leftMenuOpen) {
            // don't let the pan go less than 0 if the menu is already open
            translatedPoint.x = max(translatedPoint.x, 0.0)
        } else {
            // we are opening the menu
            translatedPoint.x = min(translatedPoint.x, 0.0)
        }
        
        setCenterViewControllerOffset(translatedPoint.x)
        
        if (recognizer.state == .ended) {
            let velocity = recognizer.velocity(in: view)
            let finalX = translatedPoint.x + (0.35 * velocity.x)
            let viewWidth = size.width
            
            if (menuState == .closed) {
                let showMenu = (finalX < -viewWidth/2.0) || (finalX < -rightMenuWidth/2.0)
                if (showMenu) {
                    panGestureVelocity = velocity.x
                    setMenuState(.rightMenuOpen)
                    
                } else {
                    panGestureVelocity = 0.0
                    setCenterViewControllerOffset(0.0, animated: true, completion: nil)
                }
            } else {
                let hideMenu = finalX < (adjustedOrigin?.x)!
                if (hideMenu) {
                    panGestureVelocity = velocity.x
                    setMenuState(.closed)
                    
                } else {
                    panGestureVelocity = 0.0
                    setCenterViewControllerOffset((adjustedOrigin?.x)!, animated: true, completion: nil)
                }
            }
        } else {
            setCenterViewControllerOffset(translatedPoint.x)
        }
    }
    
    open func handleRightPan(_ recognizer: UIPanGestureRecognizer) {
        if (leftMenuViewController == nil && menuState == .closed) {
            return
        }
        
        var size: CGSize!
        var view: UIView? = nil
        if let centerViewController = centerViewController {
            view = centerViewController.view
            size = view!.frame.size
        } else {
            size = CGSize.zero
        }
        
        var translatedPoint = recognizer.translation(in: view)
        let adjustedOrigin = panGestureOrigin
        translatedPoint = CGPoint(x: (adjustedOrigin?.x)! + translatedPoint.x, y: (adjustedOrigin?.y)! + translatedPoint.y)
        
        translatedPoint.x = max(translatedPoint.x, -rightMenuWidth)
        translatedPoint.x = min(translatedPoint.x, leftMenuWidth)
        
        if (menuState == .rightMenuOpen) {
            // menu is already open, the most the user can do is close it in this gesture
            translatedPoint.x = min(translatedPoint.x, 0.0)
        } else {
            // we are opening the menu
            translatedPoint.x = max(translatedPoint.x, 0.0)
        }
        
        if(recognizer.state == .ended) {
            let velocity = recognizer.velocity(in: view)
            let finalX = translatedPoint.x + (0.35 * velocity.x)
            let viewWidth = size.width
            
            if (menuState == .closed) {
                let showMenu = (finalX > viewWidth/2.0) || (finalX > leftMenuWidth/2.0)
                if (showMenu) {
                    panGestureVelocity = velocity.x
                    setMenuState(.leftMenuOpen)
                    
                } else {
                    panGestureVelocity = 0.0
                    setCenterViewControllerOffset(0.0, animated: true, completion: nil)
                }
            } else {
                let hideMenu = (finalX > (adjustedOrigin?.x)!)
                if (hideMenu) {
                    panGestureVelocity = velocity.x
                    setMenuState(.closed)
                    
                } else {
                    panGestureVelocity = 0.0
                    setCenterViewControllerOffset((adjustedOrigin?.x)!, animated: true, completion: nil)
                }
            }
            
            self.panDirection = .none
            
        } else {
            setCenterViewControllerOffset(translatedPoint.x)
        }
    }
    
    open func centerViewControllerTapped(_ sender: AnyObject) {
        if (menuState != .closed) {
            setMenuState(.closed)
        }
    }
    
    open func setUserInteractionStateForCenterViewController() {
        // disable user interaction on the current stack of view controllers if the menu is visible
        if let navigationController = centerViewController as? UINavigationController {
            let viewControllers = navigationController.viewControllers
            
            for viewController in viewControllers {
                viewController.view.isUserInteractionEnabled = (menuState == .closed)
            }
        } else if let navigationController = centerViewController?.navigationController {
            let viewControllers = navigationController.viewControllers
            
            for viewController in viewControllers {
                viewController.view.isUserInteractionEnabled = (menuState == .closed)
            }
        }
    }
    
    //MARKL: - Center View Controller Movement
    
    open func setCenterViewControllerOffset(_ offset: CGFloat, additionalAnimations:(() -> Void)? = nil, animated: Bool, completion: (() -> Void)?) {
        let innerCompletion = {
            self.panGestureVelocity = 0.0
            if let completion = completion {
                completion()
            }
        }
        
        guard let centerViewController = centerViewController else {
            innerCompletion()
            return
        }
        
        if (animated) {
            let centerViewControllerXPosition = abs(centerViewController.view.frame.origin.x)
            let duration = Double(animationDurationFromStartPosition(centerViewControllerXPosition, toEndPosition: offset))
            
            UIView.animate(withDuration: duration, animations: {
                self.setCenterViewControllerOffset(offset)
                if let additionalAnimations = additionalAnimations {
                    additionalAnimations()
                }
                }, completion: { (didComplete) in
                    innerCompletion()
            })
        } else {
            setCenterViewControllerOffset(offset)
            if let additionalAnimations = additionalAnimations {
                additionalAnimations()
            }
            innerCompletion()
        }
    }
    
    open func setCenterViewControllerOffset(_ xOffset: CGFloat) {
        guard let centerViewController = centerViewController else {
            return
        }
        
        var frame = centerViewController.view.frame
        frame.origin.x = xOffset
        
        centerViewController.view.frame = frame
        
        if (!menuSlideAnimationEnabled) {
            return
        }
        
        if (xOffset > 0.0) {
            alignLeftMenuControllerWithCenterViewController()
            setRightSideMenuFrameToClosedPosition()
            
        } else if (xOffset < 0.0){
            alignRightMenuControllerWithCenterViewController()
            setLeftSideMenuFrameToClosedPosition()
            
        } else {
            setLeftSideMenuFrameToClosedPosition()
            setRightSideMenuFrameToClosedPosition()
        }
    }
    
    open func animationDurationFromStartPosition(_ startPosition: CGFloat, toEndPosition endPosition: CGFloat) -> CGFloat {
        let animationPositionDelta = abs(endPosition - startPosition)
        
        var duration : CGFloat!
        if (abs(panGestureVelocity) > 1.0) {
            // try to continue the animation at the speed the user was swiping
            duration = animationPositionDelta / abs(panGestureVelocity)
            
        } else {
            // no swipe was used, user tapped the bar button item
            let menuWidth = max(leftMenuWidth, rightMenuWidth)
            let animationPercent = (animationPositionDelta == 0) ? 0 : menuWidth / animationPositionDelta
            duration = self.menuAnimationDefaultDuration * animationPercent
        }
        
        return min(duration, menuAnimationMaxDuration)
    }
}
