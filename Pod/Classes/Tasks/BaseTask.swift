//
//  BaseTask.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 14/06/2016.
//
//

import UIKit
import Foundation

public typealias TaskBlock = () -> ()
public typealias TaskBlockThrowable = () throws -> ()
public typealias TaskBlockError = (_ exception: Error) -> ()

//MARK: - Task Delegate

public protocol TaskDelegate {
    func startTask(_ baseTask: BaseTask, withActivityIndicator activityIndicator: UIActivityIndicatorView?) -> BlockOperation?
}

//MARK: - Base Task

open class BaseTask: NSObject {
    
    //MARK: Variables
    
    var preExecute  : TaskBlock?
    var execute     : TaskBlockThrowable!
    var updateView  : TaskBlock!
    
    var onError     : TaskBlockError?
    
    var operation   : BlockOperation!
    
    //MARK: - Inits
    
    override public init() {
        super.init()
    }
    
    convenience public init(execute: @escaping TaskBlockThrowable, updateView: @escaping TaskBlock, onError: TaskBlockError? = nil) {
        self.init(preExecute: nil, execute: execute, updateView: updateView, onError: onError)
    }
    
    convenience public init(preExecute: TaskBlock?, execute: @escaping TaskBlockThrowable, updateView: @escaping TaskBlock, onError: TaskBlockError? = nil) {
        self.init()
        
        self.preExecute = preExecute
        self.execute = execute
        self.updateView = updateView
        self.onError = onError
    }
    
    //MARK: - Methods
    
    static open func preExecute(_ preExecute: @escaping TaskBlock, execute: @escaping TaskBlockThrowable, updateView: @escaping TaskBlock) -> BaseTask {
        return BaseTask.preExecute(preExecute, execute: execute, updateView: updateView, onError: nil)
    }
    
    static open func preExecute(_ preExecute: @escaping TaskBlock, execute: @escaping TaskBlockThrowable, updateView: @escaping TaskBlock, onError: TaskBlockError?) -> BaseTask {
        let baseTask = BaseTask()
        
        baseTask.preExecute = preExecute
        baseTask.execute = execute
        baseTask.updateView = updateView
        baseTask.onError = onError
        
        return baseTask
    }
}
