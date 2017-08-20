//
//  LocalNotificationUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 22/07/2016.
//
//

import UIKit

open class LocalNotificationUtils: NSObject {
    
    //MARK: - Show
    
    /**
        Mostra uma notificação de push.
     
        - warning: Caso o título da notificação de push passada seja nil ou uma String vazia, a notificação local não será mostrada.
        
        - important: Este método é equivalente a chamar LocalNotificationUtils.schedulePush(notification).
     
        - parameter notification: Notificação de push a ser agendada (classe 'PushNotification')
        - parameter fireDate: Data em que a notificação será disparada. Caso este parâmetro não seja passado, o valor padrão será dia e hora atuais.
     */
    static open func showPush(_ notification: PushNotification) {
        schedulePush(notification)
    }
    
    /**
        Mostra uma notificação local.
     
        - warning: Caso o título passado seja nil ou uma String vazia, a notificação não será agendada.
     
        - parameter title: Título da notificação
        - parameter body: Corpo de mensagem da notificação. Caso este parâmetro não seja passado, o valor padrão será uma String vazia.
        - parameter userInfo: Dicionário de informações da notificação. Caso este parâmetro não seja passado, o valor padrão será nil.
        - parameter badgeNumber: Número indicador da notificação. Caso este parâmetro não seja passado, o valor padrão será 0 (zero).
        - parameter fireDate: Data em que a notificação será disparada. Caso este parâmetro não seja passado, o valor padrão será dia e hora atuais.
     */
    static open func showLocalNotification(_ title: String, body: String = "", andUserInfo userInfo: [AnyHashable: Any]? = nil, withBadgeCount badgeNumber: Int = 0, atDate fireDate: Date = Date(timeIntervalSinceNow: 0)) {
        
        scheduleWithTitle(title, body: body, andUserInfo: userInfo, withBadgeCount: badgeNumber, atDate: fireDate)
    }
    
    //MARK: - Schedule
    
    /**
        Agenda uma notificação de push. Isso permite que notificações de push apareçam mesmo quando o aplicativo estiver aberto.
        
        - warning: Caso o título da notificação de push passada seja nil ou uma String vazia, a notificação local não será agendada.
     
        - parameter notification: Notificação de push a ser agendada (classe 'PushNotification')
        - parameter fireDate: Data em que a notificação será disparada. Caso este parâmetro não seja passado, o valor padrão será dia e hora atuais.
     */
    static open func schedulePush(_ notification: PushNotification, atDate fireDate: Date = Date(timeIntervalSinceNow: 0)) {
        
        if (StringUtils.isEmpty(notification.getTitle())) {
            LogUtils.log("Local push error! Notificação inválida!")
            
            return
        }
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        
        if #available(iOS 8.2, *) {
            localNotification.alertTitle = notification.getTitle()
        } else {
            localNotification.alertAction = notification.getTitle()
        }
        
        localNotification.alertBody = notification.getBody()
        localNotification.userInfo = notification.getUserInfo()
        localNotification.applicationIconBadgeNumber = 0
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.hasAction = true
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    /**
        Agenda uma notificação local. Isso faz com que alertas apareçam quando a notificação for disparada.
        
        - warning: Caso o título passado seja nil ou uma String vazia, a notificação não será agendada.
     
        - parameter title: Título da notificação
        - parameter body: Corpo de mensagem da notificação. Caso este parâmetro não seja passado, o valor padrão será uma String vazia.
        - parameter userInfo: Dicionário de informações da notificação. Caso este parâmetro não seja passado, o valor padrão será nil.
        - parameter badgeNumber: Número indicador da notificação. Caso este parâmetro não seja passado, o valor padrão será 0 (zero).
        - parameter fireDate: Data em que a notificação será disparada. Caso este parâmetro não seja passado, o valor padrão será dia e hora atuais.
     */
    static open func scheduleWithTitle(_ title: String, body: String = "", andUserInfo userInfo: [AnyHashable: Any]? = nil, withBadgeCount badgeNumber: Int = 0, atDate fireDate: Date = Date(timeIntervalSinceNow: 0)) {
        
        if (StringUtils.isEmpty(title)) {
            LogUtils.log("Local notification error! Título vazio!")
            
            return
        }
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        
        if #available(iOS 8.2, *) {
            localNotification.alertTitle = title
        } else {
            localNotification.alertAction = title
        }
        
        localNotification.alertBody = body
        localNotification.userInfo = userInfo
        localNotification.applicationIconBadgeNumber = badgeNumber
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.hasAction = true
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}
