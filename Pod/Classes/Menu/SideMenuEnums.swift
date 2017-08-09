//
//  SideMenuEnums.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 17/06/2016.
//
//

import Foundation

public let SideMenuStateNotificationEvent = "SideMenuStateNotificationEvent"

public enum SideMenuPanMode {
    case none
    case centerViewController
    case sideMenu
    case `default`
}

public enum SideMenuState {
    case leftMenuOpen
    case rightMenuOpen
    case closed
}

public enum SideMenuStateEvent: Int {
    case willOpen = 0
    case didOpen = 1
    case willClose = 2
    case didClose = 3
}

public enum SideMenuPanDirection {
    case none
    case left
    case right
}
