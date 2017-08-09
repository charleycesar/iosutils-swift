//
//  TaskManager.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 15/06/2016.
//
//

import UIKit

open class TaskManager: NSObject {
    
    //MARK: - Variables
    
    fileprivate var baseTask    : BaseTask!
    
    fileprivate var activityIndicator : UIActivityIndicatorView?
    
    fileprivate var progressDialog  : UIView?
    fileprivate var progressMessage : String?
    fileprivate var progressFont    : UIFont?
    
    fileprivate var cancellable : Bool = false
    fileprivate var offline     : Bool = false
    fileprivate var parallel    : Bool = false
    fileprivate var showDialog  : Bool = false
    
    fileprivate var operation   : BlockOperation!
    
    //MARK: - Inits
    
    override public init() {
        super.init()
    }
    
    //MARK: - Setters
    
    open func setTask(_ baseTask: BaseTask) -> TaskManager {
        self.baseTask = baseTask
        return self
    }
    
    open func setActivityIndicator(_ activityIndicator: UIActivityIndicatorView?) -> TaskManager {
        self.activityIndicator = activityIndicator
        return self
    }
    
    open func setCancellable(_ cancellable: Bool) -> TaskManager {
        self.cancellable = cancellable
        return self
    }
    
    open func setOffline(_ offline: Bool) -> TaskManager {
        self.offline = offline
        return self
    }
    
    open func setParallel(_ parallel: Bool) -> TaskManager {
        self.parallel = parallel
        return self
    }
    
    open func setShowDialog(_ showDialog: Bool) -> TaskManager {
        self.showDialog = showDialog
        return self
    }
    
    open func setProgressMessage(_ progressMessage: String) -> TaskManager {
        self.progressMessage = progressMessage
        return self
    }
    
    open func setProgressFont(_ progressFont: UIFont) -> TaskManager {
        self.progressFont = progressFont
        return self
    }
    
    //MARK: - Start
    
    open func start() -> BlockOperation? {
        
        assert(self.baseTask != nil, "Favor atribuir um valor a baseTask pelo método setTask(_:)")
        
        if !self.offline && !NetworkUtils.isAvailable() {
            let message = ExceptionUtils.getExceptionMessage(.networkUnavailableException)
            AlertUtils.alert(message, cancelText: "Ok")
            return nil
        }
        
        self.operation = BlockOperation(block: {
            return self.executeTaskBackground()
        })
        
        self.baseTask.operation = self.operation
        return self.operation
    }
    
    static open func startTask(_ baseTask: BaseTask, withActivityIndicator activityIndicator: UIActivityIndicatorView?) -> BlockOperation {
        let taskManager = TaskManager()
        taskManager.baseTask = baseTask
        taskManager.activityIndicator = activityIndicator
        
        taskManager.operation = BlockOperation(block: {
            return taskManager.executeTaskBackground()
        })
        
        taskManager.baseTask.operation = taskManager.operation
        return taskManager.operation
    }
    
    //MARK: - Task Management
    
    open func onCancelTask() {
        self.operation.cancel()
    }
    
    open func preExecuteTask() {
        if operation.isCancelled {
            return
        }
        
        startProgress()
        
        if let preExecute = baseTask.preExecute {
            preExecute()
        }
    }
    
    open func updateViewTask() {
        if operation.isCancelled {
            return
        }
        
        if (baseTask.updateView != nil) {
            baseTask.updateView()
        }
        
        stopProgress(useDispatch: false)
    }
    
    open func executeTaskBackground() {
        if operation.isCancelled {
            cancelActivityIndicator(useDispatch: true)
        }
        
        performSelector(onMainThread: #selector(preExecuteTask), with: nil, waitUntilDone: true)
        
        if operation.isCancelled {
            stopProgress(useDispatch: true)
            return
        }
        
        do {
            try baseTask.execute()
            
            if operation.isCancelled {
                stopProgress(useDispatch: true)
                return
            }
            
            performSelector(onMainThread: #selector(updateViewTask), with: nil, waitUntilDone: true)
            
        } catch {
            if operation.isCancelled {
                stopProgress(useDispatch: true)
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let onError = self.baseTask.onError {
                    onError(error)
                } else {
                    self.handleDefaultException(error)
                }
                
                self.stopProgress(useDispatch: false)
            });
        }
    }
    
    //MARK: - Error Handling
    
    open func handleDefaultException(_ exception: Error) {
        if let exception = exception as? Exception {
            switch exception {
            case .domainException(let message):
                AlertUtils.alert(message)
                
            case .ioException:
                showError(.ioException)
                
            case .appSecurityTransportException:
                ExceptionUtils.alertAppTransportSecurityException()
                
            default:
                showError(.genericException(message: ""))
            }
        }
    }
    
    open func showError(_ exception: Exception) {
        let errorMessage = ExceptionUtils.getExceptionMessage(exception)
        
        if errorMessage.isEmpty {
            return
        }
        
        AlertUtils.alert(errorMessage)
    }
}

//MARK: -

extension TaskManager {
    
    //MARK: - Progress
    
    fileprivate func startProgress() {
        if showDialog {
            showProgressView()
        } else {
            startActivityIndicator()
        }
    }
    
    fileprivate func stopProgress(useDispatch: Bool) {
        if showDialog {
            hideProgressView(useDispatch: useDispatch)
        } else {
            cancelActivityIndicator(useDispatch: useDispatch)
        }
    }
    
    //MARK: - Spinner
    
    fileprivate func startActivityIndicator() {
        guard let activityIndicator = activityIndicator else {
            return
        }
        
        activityIndicator.startAnimating()
    }
    
    fileprivate func cancelActivityIndicator(useDispatch: Bool) {
        if let activityIndicator = activityIndicator {
            if useDispatch {
                DispatchQueue.main.async(execute: {
                    activityIndicator.stopAnimating()
                });
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    //MARK: - Progress Dialog
    
    fileprivate func showProgressView() {
        guard progressDialog == nil else {
            return
        }
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.colorWithRed(0, green: 0, blue: 0, andAlpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if cancellable {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCancelTask))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            
            view.addGestureRecognizer(tapGesture)
        }
        
        let dialog = UIView(frame: CGRect.zero)
        dialog.backgroundColor = UIColor.white
        dialog.layer.cornerRadius = 4.0
        dialog.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect.zero)
        label.text = progressMessage ?? FileUtils.getUtilsDefaultMessage(tag: "progress_dialog_default_message")
        label.font = progressFont ?? UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        dialog.addSubview(label)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        dialog.addSubview(spinner)
        
        view.addSubview(dialog)
        
        window.addSubview(view)
        
        let viewUpperConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let viewLeadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let viewTrailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let viewLowerConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([viewUpperConstraint, viewLeadingConstraint, viewTrailingConstraint, viewLowerConstraint])
        
        let dialogLeadingConstraint = NSLayoutConstraint(item: dialog, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 25.0)
        
        let dialogTrailingConstraint = NSLayoutConstraint(item: dialog, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -25.0)
        
        let dialogCenterYConstraint = NSLayoutConstraint(item: dialog, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([dialogLeadingConstraint, dialogTrailingConstraint, dialogCenterYConstraint])
        
        let labelUpperConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: dialog, attribute: .top, multiplier: 1.0, constant: 16.0)
        
        let labelLeadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: dialog, attribute: .leading, multiplier: 1.0, constant: 16.0)
        
        let labelTrailingConstraint = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: dialog, attribute: .trailing, multiplier: 1.0, constant: -16.0)
        
        let labelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: spinner, attribute: .top, multiplier: 1.0, constant: -16.0)
        
        NSLayoutConstraint.activate([labelUpperConstraint, labelLeadingConstraint, labelTrailingConstraint, labelBottomConstraint])
        
        let spinnerBottomContraint = NSLayoutConstraint(item: spinner, attribute: .bottom, relatedBy: .equal, toItem: dialog, attribute: .bottom, multiplier: 1.0, constant: -16.0)
        
        let spinnerCenterXContraint = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: dialog, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([spinnerBottomContraint, spinnerCenterXContraint])
        
        progressDialog = view
        progressDialog?.isHidden = false
        
        self.activityIndicator = spinner
        self.activityIndicator?.startAnimating()
        
        view.layoutIfNeeded()
    }
    
    fileprivate func hideProgressView(useDispatch: Bool) {
        guard let progressDialog = progressDialog else {
            return
        }
        
        DispatchQueue.main.async(execute: {
            progressDialog.isHidden = true
            progressDialog.removeFromSuperview()
            
            self.activityIndicator?.stopAnimating()
            self.activityIndicator = nil
            self.progressDialog = nil
        })
    }
}
