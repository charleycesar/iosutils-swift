//
//  UITableView+Livetouch.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 24/06/2016.
//
//

import UIKit

private var scrollDelegateAssociationKey = "scrollDelegateAssociationKey"
private var tableDelegateAssociationKey = "tableDelegateAssociationKey"

public extension UITableView {
    
    //MARK: - Cell Reuse
    
    public func registerCell(_ nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    //MARK: - Automatic Height
    
    public func setMinimumHeight(_ height: CGFloat) {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = height
    }
    
    public func setEstimatedHeight(_ height: CGFloat) {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = height
    }
    
    //MARK: - Footer
    
    public func addActivityIndicatorAtFooter() -> UIActivityIndicatorView {
        
        self.tableFooterView = nil
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 36))
        footer.backgroundColor = UIColor.clear
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.hidesWhenStopped = true
        spinner.center = self.center
        
        footer.addSubview(spinner)
        
        self.tableFooterView = footer
        
        return spinner
    }
    
    public func removeFooter() {
        self.tableFooterView = nil
    }
}

extension UITableView: UITableViewDelegate {
    
    //MARK: - Scroll Delegate
    
    fileprivate(set) public var scrollDelegate: UIScrollViewDelegate? {
        get {
            return objc_getAssociatedObject(self, &scrollDelegateAssociationKey) as? UIScrollViewDelegate
        }
        set(newValue) {
            objc_setAssociatedObject(self, &scrollDelegateAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate(set) public var tableDelegate: UITableViewDelegate? {
        get {
            return objc_getAssociatedObject(self, &tableDelegateAssociationKey) as? UITableViewDelegate
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tableDelegateAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: - Adapter
    
    public func setAdapter(_ adapter: BaseAdapter?) {
        self.dataSource = adapter
        self.tableDelegate = adapter
        self.delegate = adapter != nil ? self : nil
    }
    
    //MARK: - Scroll Listener
    
    public func addScrollListener<T>(_ listener: T?) where T: NSObject, T: UIScrollViewDelegate {
        self.scrollDelegate = listener
    }
    
    //MARK: - Scroll View Delegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegate {
            if (scrollDelegate.responds(to: #selector(scrollViewDidScroll(_:)))) {
                scrollDelegate.scrollViewDidScroll!(scrollView)
            }
        }
    }
    
    //MARK: - Selector Response
    
    open override func responds(to aSelector: Selector) -> Bool {
        
        let forwardingTarget = self.forwardingTarget(for: aSelector)
        
        if let forwardingTarget = forwardingTarget {
            if ((forwardingTarget as AnyObject).isEqual(tableDelegate)) {
                return (forwardingTarget as AnyObject).responds(to: aSelector)
            }
        }
        
        return super.responds(to: aSelector)
    }
    
    open override func forwardingTarget(for aSelector: Selector) -> Any? {
        
        if let tableDelegate = tableDelegate {
            if (tableDelegate.responds(to: aSelector)) {
                return tableDelegate
            }
        }
        
        return super.forwardingTarget(for: aSelector)
    }
}

public extension UITableView {
    
    //MARK: - Index Path Helpers
    
    fileprivate func getIndexPathsFromSequence<T: Sequence>(_ list: T, atSection section: Int) -> [IndexPath] where T.Iterator.Element == Int {
        
        var indexPaths : [IndexPath] = []
        
        for i in list {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    //MARK: - Insert Rows
    
    public func insertRowsWithIndexes(_ indexes: [Int], atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let indexPaths = getIndexPathsFromSequence(indexes, atSection: section)
        self.insertRows(at: indexPaths, with: animation)
    }
    
    public func insertRowsFromIndex(_ startIndex: Int, toIndex endIndex: Int, atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let indexPaths = getIndexPathsFromSequence(startIndex ..< endIndex, atSection: section)
        self.insertRows(at: indexPaths, with: animation)
    }
    
    //MARK: - Delete Rows
    
    public func deleteRowsWithIndexes(_ indexes: [Int], atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let indexPaths = getIndexPathsFromSequence(indexes, atSection: section)
        self.deleteRows(at: indexPaths, with: animation)
    }
    
    public func deleteRowsFromIndex(_ startIndex: Int, toIndex endIndex: Int, atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let indexPaths = getIndexPathsFromSequence(startIndex ..< endIndex, atSection: section)
        self.deleteRows(at: indexPaths, with: animation)
    }
    
    //MARK: - Reload Rows
    
    public func reloadRowsWithIndexes(_ indexes: [Int], atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let indexPaths = getIndexPathsFromSequence(indexes, atSection: section)
        self.reloadRows(at: indexPaths, with: animation)
    }
    
    public func reloadRowsFromIndex(_ startIndex: Int, toIndex endIndex: Int, atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let indexPaths = getIndexPathsFromSequence(startIndex ..< endIndex, atSection: section)
        self.reloadRows(at: indexPaths, with: animation)
    }
    
    //MARK: - Move Rows
    
    public func moveRowAtIndex(_ startIndex: Int, toIndex endIndex: Int, atSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        
        let startIndexPath = IndexPath(row: startIndex, section: section)
        let endIndexPath = IndexPath(row: endIndex, section: section)
        
        self.moveRow(at: startIndexPath, to: endIndexPath)
    }
}
