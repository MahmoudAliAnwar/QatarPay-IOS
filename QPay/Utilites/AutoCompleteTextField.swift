//
//  AutoCompleteTextField.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

public class AutoCompleteTextField:UITextField {
    
    /// Manages the instance of tableview
    private var autoCompleteTableView:UITableView?
    
    /// Holds the collection of attributed strings
    private lazy var attributedAutoCompleteStrings = [NSAttributedString]()
    
    /// Handles user selection action on autocomplete table view
    public var onSelect:(String, IndexPath)->() = {_,_ in}
    
    /// Handles textfield's textchanged
    public var onTextChange:(String)->() = {_ in}
    
    /// Font for the text suggestions
    public var autoCompleteTextFont = UIFont.systemFont(ofSize: 12)
    
    /// Color of the text suggestions
    public var autoCompleteTextColor = UIColor.black
    
    /// Used to set the height of cell for each suggestions
    public var autoCompleteCellHeight:CGFloat = 44.0
    
    /// The maximum visible suggestion
    public var maximumAutoCompleteCount = 3
    
    /// Used to set your own preferred separator inset
    public var autoCompleteSeparatorInset = UIEdgeInsets.zero
    
    /// Shows autocomplete text with formatting
    public var enableAttributedText = false
    
    /// User Defined Attributes
    public var autoCompleteAttributes:[NSAttributedString.Key : AnyObject]?
    
    /// Hides autocomplete tableview after selecting a suggestion
    public var hidesWhenSelected = true
    
    /// Hides autocomplete tableview when the textfield is empty
    public var hidesWhenEmpty : Bool? {
        didSet{
            assert(hidesWhenEmpty != nil, "hideWhenEmpty cannot be set to nil")
            autoCompleteTableView?.isHidden = hidesWhenEmpty!
        }
    }
    
    /// The table view height
    public var autoCompleteTableHeight : CGFloat? {
        didSet{
            redrawTable()
        }
    }
    
    /// The strings to be shown on as suggestions, setting the value of this automatically reload the tableview
    public var autoCompleteStrings : [String]? {
        didSet{ reload() }
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupAutocompleteTable(view: superview!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // FIXME: Handle custom inits...
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        setupAutocompleteTable(view: superview!)
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        commonInit()
        setupAutocompleteTable(view: newSuperview!)
    }
    
    private func commonInit(){
        hidesWhenEmpty = true
        autoCompleteAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        autoCompleteAttributes![NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 12)
        self.clearButtonMode = .always
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(self.textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    private func setupAutocompleteTable(view:UIView){
        let screenSize = UIScreen.main.bounds.size
        let tableView = UITableView(frame: CGRectMake(self.frame.origin.x, self.frame.origin.y + CGRectGetHeight(self.frame), screenSize.width - (self.frame.origin.x * 2), 30.0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = autoCompleteCellHeight
        tableView.isHidden = hidesWhenEmpty ?? true
        view.addSubview(tableView)
        autoCompleteTableView = tableView
        
        autoCompleteTableHeight = 100.0
    }
    
    private func redrawTable(){
        if let autoCompleteTableView = autoCompleteTableView, let autoCompleteTableHeight = autoCompleteTableHeight {
            var newFrame = autoCompleteTableView.frame
            newFrame.size.height = autoCompleteTableHeight
            autoCompleteTableView.frame = newFrame
        }
    }
    
    //MARK: - Private Methods
    private func reload(){
        if enableAttributedText{
            let attrs = [NSAttributedString.Key.foregroundColor: autoCompleteTextColor, NSAttributedString.Key.font: autoCompleteTextFont]
            
            if attributedAutoCompleteStrings.count > 0 {
                attributedAutoCompleteStrings.removeAll()
            }
            
            if let autoCompleteStrings = autoCompleteStrings, let autoCompleteAttributes = autoCompleteAttributes {
                for i in 0..<autoCompleteStrings.count {
                    let str = autoCompleteStrings[i] as NSString
                    let range = str.range(of: text!, options: .caseInsensitive)
                    let attString = NSMutableAttributedString(string: autoCompleteStrings[i], attributes: attrs)
                    attString.addAttributes(autoCompleteAttributes, range: range)
                    attributedAutoCompleteStrings.append(attString)
                }
            }
        }
        autoCompleteTableView?.reloadData()
    }
    
    @objc func textFieldDidChange(){
        guard let _ = text else {
            return
        }
        
        onTextChange(text!)
        if text!.isEmpty{ autoCompleteStrings = nil }
        DispatchQueue.main.async(execute: { () -> Void in
            self.autoCompleteTableView?.isHidden =  self.hidesWhenEmpty! ? self.text!.isEmpty : false
        })
    }
    
    @objc func textFieldDidEndEditing() {
        autoCompleteTableView?.isHidden = true
    }
}

//MARK: - UITableViewDataSource - UITableViewDelegate
extension AutoCompleteTextField: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteStrings != nil ? (autoCompleteStrings!.count > maximumAutoCompleteCount ? maximumAutoCompleteCount : autoCompleteStrings!.count) : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "autocompleteCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if enableAttributedText{
            cell?.textLabel?.attributedText = attributedAutoCompleteStrings[indexPath.row]
        }
        else{
            cell?.textLabel?.font = autoCompleteTextFont
            cell?.textLabel?.textColor = autoCompleteTextColor
            cell?.textLabel?.text = autoCompleteStrings![indexPath.row]
        }
        
        cell?.contentView.gestureRecognizers = nil
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let selectedText = cell?.textLabel?.text {
            self.text = selectedText
            onSelect(selectedText, indexPath)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            tableView.isHidden = self.hidesWhenSelected
        })
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: Selector("setSeparatorInset:")) {
            cell.separatorInset = autoCompleteSeparatorInset
        }
        if cell.responds(to: Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: Selector("setLayoutMargins:")) {
            cell.layoutMargins = autoCompleteSeparatorInset
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return autoCompleteCellHeight
    }
}
