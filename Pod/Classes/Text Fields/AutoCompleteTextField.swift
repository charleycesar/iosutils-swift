//
//  AutoCompleteTextField.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

/*
 *  Esta classe foi feita com base na lib MPGTextField.
 *  https://github.com/gaurvw/MPGTextField
 */

public protocol AutoCompleteTextFieldDataSource {
    //TODO
    /*
    //A mandatory method that must be conformed by the using class. It expects an NSArray of NSDictionary objects where the dictionary should contain the key 'DisplayText' and optionally contain the keys - 'DisplaySubText' and 'CustomObject'
    func dataForPopoverInTextField(_ textField: AutoCompleteTextField) -> [[String: AnyObject]]
    
    //If mandatory selection needs to be made (asked via delegate), this method. It can have the following return values:
    //1. If user taps on a row in the search results, it will return the selected NSDictionary object
    //2. If the user doesn't tap a row, it will return the first NSDictionary object from the results
    //3. If the user doesn't tap a row and there is no search result, it will return a NEW NSDictionary object containing the text entered by the user and the value of 'Custom object' will be set to 'NEW'
    func textField(_ textField: AutoCompleteTextField, didEndEditingWithSelection result: [String: AnyObject])
    
    //This delegate method is used to specify if a mandatory selection needs to be made. Set this property to 'true' if you want a selection to be made from the accompanying popover. In case the user does not select anything from the popover and this property is set to YES, the first item from the search results will be selected automatically. If this property is set to 'false' and the user doesn't select anything from the popover, the text will remain as-is in the textfield. Default Value is 'false'.
    func textFieldShouldSelect(_ textField: AutoCompleteTextField) -> Bool
}

open class AutoCompleteTextField: UITextField, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - Variables
    
    open var dataSource : AutoCompleteTextFieldDataSource?
    
    //Cor de fundo da tabela. Se não for definido, o padrão é [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0].
    open var tableViewColor   : UIColor!
    
    //Cor dos separadores da tabela. Se não for definido, o padrão é [UIColor blackColor].
    open var separatorColor   : UIColor!
    
    //Fonte da célula. Se não for definido, o padrão é HelveticaNeue tamanho 17 (fonte padrão do iOS).
    open var cellFont : UIFont!
    
    //Cor do texto da célula. Se não for definido, o padrão é [UIColor blackColor].
    open var cellTextColor    : UIColor!
    
    //Altura da célula. Se não for definido, o padrão é 44px.
    open var cellHeight   : CGFloat!
    
    //Tamanho do popover onde a tabela estará contida. Se não for definido, a largura será igual ao do UITextField, a altura será 200px e a posição será logo abaixo do UITextField.
    open var popoverRect  : CGRect!
    
    //ainda não implementado o código para esse atributo.
    open var showPopoverWhenEmpty : Bool = false
    
    open var popoverShouldAdjustHeight    : Bool = false
    
    fileprivate var data    : [[String: AnyObject]] = []
    
    fileprivate var tableViewController : UITableViewController?
    
    //MARK: - Inits
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        setupDefaultValues()
        
        tableViewController?.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "AutoCompleteResultsCell")
    }
    
    //MARK: - Setups
    
    open func setupDefaultValues() {
        tableViewColor = UIColor.colorWithRed(240, green: 240, blue: 240, andAlpha: 1.0)
        separatorColor = UIColor.black
        cellFont = UIFont.systemFont(ofSize: 17.0)
        cellTextColor = UIColor.black
        cellHeight = 44.0
        popoverRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height, width: self.frame.width, height: 200)
    }
    
    //MARK: - Layout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if (isFirstResponder) {
            //User entered some text in the textfield. Check if the dataSource has implemented the required method of the protocol. Create a popover and show it around the MPGTextField.
            if let dataSource = dataSource {
                data = dataSource.dataForPopoverInTextField(self)
                provideSuggestions()
            } else {
                LogUtils.log("<AutoCompleteTextField> WARNING: You have not implemented the methods of AutoCompleteTextFieldDataSource.")
            }
        } else {
            //No text entered in the textfield. If -textFieldShouldSelect is YES, select the first row from results using -handleExit method.tableView and set the displayText on the text field. Check if suggestions view is visible and dismiss it.
            if let tableView = tableViewController?.tableView {
                if (tableView.superview != nil) {
                    tableView.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: - Responder
    
    //Override UITextField -resignFirstResponder method to ensure the 'exit' is handled properly.
    override open func resignFirstResponder() -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewController?.tableView.alpha = 0.0
            
        }, completion: { (finished: Bool) in
            self.tableViewController?.tableView.removeFromSuperview()
            self.tableViewController = nil
        })
        
        handleExit()
        
        return super.resignFirstResponder()
    }
    
    //This method checks if a selection needs to be made from the suggestions box using the dataSource method -textFieldShouldSelect. If a user doesn't tap any search suggestion, the textfield automatically selects the top result. If there is no result available and the dataSource method is set to return YES, the textfield will wrap the entered the text in a NSDictionary and send it back to the dataSource with 'CustomObject' key set to 'NEW'
    open func handleExit() {
        guard let dataSource = dataSource else {
            return
        }
        
        guard let text = text else {
            return
        }
        
        tableViewController?.tableView.removeFromSuperview()
        
        if (dataSource.textFieldShouldSelect(self)) {
            let filteredArray = applyFilterWithSearchQuery(text)
            if (filteredArray.count > 0) {
                self.text = filteredArray[0].getStringWithKey("DisplayText")
                dataSource.textField(self, didEndEditingWithSelection: filteredArray[0])
                
            }
            //TODO
            /*else if (text.length > 0){
                //Make sure that dataSource method is not called if no text is present in the text field.
                dataSource.textField(self, didEndEditingWithSelection: ["DisplayText": text as AnyObject, "CustomObject": "NEW" as AnyObject])
            }*/
        }
    }
    
    //MARK: - Table View Data Source
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = applyFilterWithSearchQuery(text).count
        
        
        if (count == 0) {
            count = data.count
            
            if (count == 0) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableViewController?.tableView.alpha = 0.0
                    
                }, completion: { (finished: Bool) in
                    self.tableViewController?.tableView.removeFromSuperview()
                    self.tableViewController = nil
                })
            }
        }
        
        if (count > 0) {
            guard let tableView = tableViewController?.tableView else {
                return count
            }
            
            var height = cellHeight
            height = CGFloat(count) * height! > popoverRect.size.height ? popoverRect.size.height : CGFloat(count) * height!
            
            UIView.animate(withDuration: 0.3, animations: {
                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: height!)
            })
        }
        
        return count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteResultsCell", for: indexPath)
        
        cell.textLabel?.font = cellFont
        cell.textLabel?.textColor = cellTextColor
        
        cell.detailTextLabel?.font = cellFont
        cell.detailTextLabel?.textColor = cellTextColor
        
        cell.backgroundColor = UIColor.clear
        
        let filteredResults = applyFilterWithSearchQuery(text)
        
        var dataForRowAtIndexPath : [String: AnyObject]? = nil
        
        if (filteredResults.count > 0 && (indexPath as NSIndexPath).row < filteredResults.count) {
            dataForRowAtIndexPath = filteredResults[(indexPath as NSIndexPath).row]
            
        } else if (data.count > 0 && (indexPath as NSIndexPath).row < data.count) {
            dataForRowAtIndexPath = data[(indexPath as NSIndexPath).row]
        }
        
        if let dataForRowAtIndexPath = dataForRowAtIndexPath {
            cell.textLabel?.text = dataForRowAtIndexPath.getStringWithKey("DisplayText")
            
            let displaySubText = dataForRowAtIndexPath.getStringWithKey("DisplaySubText")
            if (StringUtils.isNotEmpty(displaySubText)) {
                cell.detailTextLabel?.text = displaySubText
            }
        }
        
        return cell
    }
    
    //MARK: - Table View Delegate
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredResults = applyFilterWithSearchQuery(text)
        
        let results = filteredResults.count > 0 ? filteredResults : data
        
        guard (indexPath as NSIndexPath).row < results.count else {
            return
        }
        
        self.text = results[(indexPath as NSIndexPath).row].getStringWithKey("DisplayText")
        
        resignFirstResponder()
    }
    
    //MARK: - Filter Method
    
    open func applyFilterWithSearchQuery(_ query: String?) -> [[String: AnyObject]] {
        guard let query = query else {
            return []
        }
        
        let filteredArray = data.filter({ (dictionary: [String: AnyObject]) in
            let displayText = dictionary.getStringWithKey("DisplayText")
            return displayText.beginsWith(string: query)
        })
        return filteredArray
    }
    
    //MARK: - Popover Methods
    
    open func provideSuggestions() {
        //Providing suggestions
        if (tableViewController?.tableView.superview == nil) {
            //Add a tap gesture recogniser to dismiss the suggestions view when the user taps outside the suggestions view
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.cancelsTouchesInView = false
            tapRecognizer.delegate = self
            superview?.addGestureRecognizer(tapRecognizer)
            
            tableViewController = UITableViewController()
            tableViewController!.tableView.dataSource = self
            tableViewController!.tableView.delegate = self
            tableViewController!.tableView.backgroundColor = tableViewColor
            tableViewController!.tableView.separatorColor = separatorColor
            
            superview?.addSubview(tableViewController!.tableView)
            
            tableViewController!.tableView.alpha = 0.0;
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableViewController!.tableView.alpha = 1.0
            })
        } else {
            tableViewController?.tableView.reloadData()
        }
    }
    
    open func tapped(_ gesture: UIGestureRecognizer) {}
 */
}
