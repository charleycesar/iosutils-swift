//
//  EndlessScrollViewListener.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 11/08/2016.
//
//

import UIKit

open class EndlessScrollViewListener<T, U>: NSObject, UIScrollViewDelegate where T: UIViewController, U: NSObject {
    
    //MARK: - Variables
    
    fileprivate var viewController : T!
    
    fileprivate var adapter : BaseAdapter!
    
    fileprivate var tableView : UITableView!
    
    fileprivate var onScrollGetNextList : ((_ page: Int) throws -> [U])?
    
    fileprivate var onScrollFinished : (() -> Void)?
    
    fileprivate var spinner : UIActivityIndicatorView?
    
    fileprivate var page : Int = 1
    
    fileprivate var lastLoad : Bool = false
    
    fileprivate var loading : Bool = false
    
    //MARK: - Inits
    
    override public init() {
        super.init()
    }
    
    public convenience init(viewController: T, tableView: UITableView, adapter: BaseAdapter, onScrollGetNextList : ((_ page: Int) throws -> [U])? = nil, onScrollFinished: (() -> Void)? = nil) {
        
        self.init()
        
        self.viewController = viewController
        self.tableView = tableView
        self.adapter = adapter
        self.onScrollGetNextList = onScrollGetNextList
        self.onScrollFinished = onScrollFinished
    }
    
    //MARK: - Builder
    
    open func setViewController(_ viewController: T) -> EndlessScrollViewListener {
        self.viewController = viewController
        return self
    }
    
    open func setTableView(_ tableView: UITableView) -> EndlessScrollViewListener {
        self.tableView = tableView
        return self
    }
    
    open func setAdapter(_ adapter: BaseAdapter) -> EndlessScrollViewListener {
        self.adapter = adapter
        return self
    }
    
    open func setOnScrollGetNextList(_ onScrollGetNextList: ((_ page: Int) throws -> [U])?) -> EndlessScrollViewListener {
        self.onScrollGetNextList = onScrollGetNextList
        return self
    }
    
    open func setOnScrollFinished(_ onScrollFinished: (() -> Void)?) -> EndlessScrollViewListener {
        self.onScrollFinished = onScrollFinished
        return self
    }
    
    //MARK: - Scroll View Delegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        
        let scroll = currentOffset.y + bounds.size.height - inset.bottom
        let height = size.height
        
//        if (scroll > height + 22) {
        if (scroll > height + 30) {
            if lastLoad {
                return
            }
            
            if (!loading) {
                loading = true
                
                viewController.startTask(scrollTask(page: page, adapter: adapter, onScrollGetNextList: onScrollGetNextList), withActivityIndicator: spinner)
            }
        }
    }
    
    //MARK: - Tasks
    
    fileprivate func scrollTask(page: Int, adapter: BaseAdapter, onScrollGetNextList: ((_ page: Int) throws -> [U])?) -> BaseTask {
        
        var itemsUpdate : [U]!
        var indexPaths  : [IndexPath]!
        
        return BaseTask(execute: {
            itemsUpdate = try onScrollGetNextList?(page)
            
            indexPaths = []
            
            let count = adapter.getAdapterList().count
            
            for i in count ..< count + itemsUpdate.count {
                let indexPath = IndexPath(row: i, section: 0)
                indexPaths.append(indexPath)
            }
            
        }, updateView: {
            if (itemsUpdate.count == 0) {
                
                if let onScrollFinished = self.onScrollFinished {
                    onScrollFinished()
                    self.onScrollFinished = nil
                }
                
                self.lastLoad = true
                
            } else {
                self.page += 1
                self.adapter.addNewElements(itemsUpdate)
                
                //FIXME: Causando crash no LivecomV2 - Será revertido assim que o problema for solucionado
                //self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                self.tableView.reloadData()
            }
            
            self.loading = false
        })
    }
}
