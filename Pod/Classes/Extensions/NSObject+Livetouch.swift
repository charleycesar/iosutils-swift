//
//  NSObject+Livetouch.swift
//  Pods
//
//  Created by Guilherme Politta on 17/06/16.
//
//

import Foundation
import ObjectiveC

private var queueAssociationKey: UInt8 = 0

public extension NSObject {
    
    //MARK: - Queue
    
    fileprivate(set) public var queue: OperationQueue? {
        get {
            return objc_getAssociatedObject(self, &queueAssociationKey) as? OperationQueue
        }
        set(newValue) {
            objc_setAssociatedObject(self, &queueAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var maxConcurrentOperationCount : Int {
        get {
            assert(queue != nil, "Você deve implementar o método setupQueue: antes ober o maxConcurrentOperationCount")
            
            return queue!.maxConcurrentOperationCount
        }
        set {
            assert(queue != nil, "Você deve implementar o método setupQueue: antes de mudar o maxConcurrentOperationCount")
            
            queue?.maxConcurrentOperationCount = newValue
        }
    }
    
    public final func setupQueue() {
        self.queue = OperationQueue()
        self.queue?.maxConcurrentOperationCount = 5
    }
    
    //MARK: - Start Tasks
    
    public func startTask(_ baseTask: BaseTask, withActivityIndicator activityIndicator: UIActivityIndicatorView? = nil) -> BlockOperation? {
        
        let taskManager = TaskManager().setTask(baseTask).setActivityIndicator(activityIndicator)
        
        return startTaskWithManager(taskManager)
    }
    
    public func startTaskOffline(_ baseTask: BaseTask, withActivityIndicator activityIndicator: UIActivityIndicatorView? = nil) -> BlockOperation? {
        
        let taskManager = TaskManager().setTask(baseTask).setActivityIndicator(activityIndicator).setOffline(true)
        
        return startTaskWithManager(taskManager)
    }
    
    //Ainda não implementada a lógica de paralelismo!!!!
    public func startTaskParallel(_ baseTask: BaseTask, withActivityIndicator activityIndicator: UIActivityIndicatorView? = nil) -> BlockOperation? {
        
        let taskManager = TaskManager().setTask(baseTask).setActivityIndicator(activityIndicator).setParallel(true)
        
        return startTaskWithManager(taskManager)
    }
    
    public func startTaskWithManager(_ taskManager: TaskManager) -> BlockOperation? {
        
        assert(queue != nil, "Antes de chamar uma task pela primeira vez na classe é necessário chamar o método setupQueue()")
        
        guard let blockOperation = taskManager.start() else {
            return nil
        }
        
        queue?.addOperation(blockOperation)
        return blockOperation
    }
    
    //MARK: - Cancel Tasks
    
    public func cancelTasks() {
        queue?.cancelAllOperations()
    }
    
    public func cancelTask(_ operation: BlockOperation?) {
        if let operation = operation {
            operation.cancel()
        }
    }
 
    //MARK: - Notifications
    
    public func registerNotification(_ notificationName: String, withSelector selector: Selector) {
        NotificationUtils.registerNotification(notificationName, withSelector: selector, fromObserver: self)
    }
    
    public func unregisterNotification(_ notificationName: String) {
        NotificationUtils.unregisterNotification(notificationName, fromObserver: self)
    }
    
    public func unregisterAllNotifications() {
        NotificationUtils.unregisterAllNotificationsFromObserver(self)
    }
    
    public func postNotification(_ notificationName: String, withObject object: AnyObject? = nil) {
        NotificationUtils.postNotification(notificationName, withObject: object)
    }
    
    public func postNotification(_ notification: Notification) {
        NotificationUtils.postNotification(notification)
    }
    
    //MARK: - Log
    
    public func log(_ message: String) {
        LogUtils.log(message)
    }
    
    //MARK: - Conversões
    
    public func toJsonString() throws -> String {
        let result : AnyObject = toDictionary() as AnyObject
        
        let data = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        return data.toString()
    }
    
    public func toDictionary() -> [String:AnyObject] {
        return NSObject.toDictionary(self)
    }
    
    public static func toDictionary(_ object: AnyObject) -> [String:AnyObject] {
        var dict: [String:AnyObject] = [:]
        let otherSelf = Mirror(reflecting: object)
        
        for child in otherSelf.children {
            if let key = child.label {
                if (ClassUtils.isBasicClass(child.value)) {
                    dict[key] = (child.value as AnyObject)
                } else {
                    if let array = child.value as? NSArray {
                        if (array.count > 0) {
                            dict[key] = toArrayDescription(array) as AnyObject?
                        }
                    } else if let object = child.value as? NSObject {
                        dict[key] = object.toDictionary() as AnyObject?
                    }
                }
            }
        }
        
        return dict
    }
    
    fileprivate static func toArrayDescription(_ array: NSArray) -> [AnyObject] {
        var arrayRetorno: [AnyObject] = []
        for i in array {
            if (ClassUtils.isBasicClass(i)) {
                arrayRetorno.append(i as AnyObject)
            } else if let array = i as? NSArray {
                arrayRetorno.append(array)
            } else if let object = i as? NSObject {
                arrayRetorno.append(object.toDictionary() as AnyObject)
            }
        }
        return arrayRetorno
    }
    
    //MARK: - Thread
    
    public func sleep(_ time: TimeInterval) {
        Thread.sleep(forTimeInterval: time)
    }
    
    public func runOnBackground(_ _block: @escaping ()->()) {
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        queue.async(execute: _block)
    }
    
    public func runOnUIThread(_ _block: @escaping ()->()) {
        let queue = DispatchQueue.main
        queue.async(execute: _block)
    }

}
