//
//  InvoicesFilterViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

// api/Ecommerce/GetOrderListByFilter

class InvoicesFilterViewController: ViewController {

    @IBOutlet weak var shopListButton: UIButton!
    @IBOutlet weak var shopListLabel: UILabel!
    @IBOutlet weak var shopListErrorImageView: UIImageView!
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var fromDateImageView: UIImageView!
    @IBOutlet weak var fromDateErrorImageView: UIImageView!
    
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var toDateImageView: UIImageView!
    @IBOutlet weak var toDateErrorImageView: UIImageView!
    
    var filterOrdersDelegate: FilterOrdersDelegate?
    
    private let shopListDropDown = DropDown()
    private let fromDatePicker = UIDatePicker()
    private let toDatePicker = UIDatePicker()
    private var selectedShop: Shop?
    private let dateFormat = "dd/MM/yyyy"
    
    private var shops = [Shop]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension InvoicesFilterViewController {
    
    func setupView() {
        self.setupDropDownAppearance()
        self.setupShopListDropDown()
        self.createFromDatePicker()
        self.createToDatePicker()
        
        self.fromDateImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showFromDatePicker(_:))))
        self.toDateImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showToDatePicker(_:))))
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InvoicesFilterViewController {

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shopListDropDownAction(_ sender: UIButton) {
        self.shopListDropDown.show()
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        if self.checkViewFieldsErrors() {
            if let shopID = self.selectedShop?.id,
               let fromDateString = self.fromDateTextField.text, fromDateString.isNotEmpty,
               let toDateString = self.toDateTextField.text, toDateString.isNotEmpty {
                
                let fromDate = self.fromDatePicker.date.formatDate(ServerDateFormat.Server2.rawValue)
                let toDate = self.toDatePicker.date.formatDate(ServerDateFormat.Server2.rawValue)
                
                self.requestProxy.requestService()?.getOrderListByFilter(shopID: shopID, fromDate: fromDate, toDate: toDate, completion: { (status, orders) in
                    if status {
                        let arr = orders ?? []
                        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                            self.dismiss(animated: true)
                            self.filterOrdersDelegate?.filterOrdersCallBack(with: arr)
                        }
                    }
                })
            }
        }
    }
}
 
// MARK: - REQUESTS DELEGATE

extension InvoicesFilterViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getOrderListByFilter {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                break
            case .Failure(let errorType):
                switch errorType {
                case .Exception(let exc):
                    if showUserExceptions {
                        self.showErrorMessage(exc)
                    }
                    break
                case .AlamofireError(let err):
                    if showAlamofireErrors {
                        self.showSnackMessage(err.localizedDescription)
                    }
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension InvoicesFilterViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        
        let isShopNotEmpty = self.selectedShop != nil
        self.showHideShopError(isShopNotEmpty)
        
        let isFromDateNotEmpty = self.fromDateTextField.text!.isNotEmpty
        self.showHideFromDateError(isFromDateNotEmpty)
        
        let isToDateNotEmpty = self.toDateTextField.text!.isNotEmpty
        self.showHideToDateError(isToDateNotEmpty)
        
        return isShopNotEmpty && isFromDateNotEmpty && isToDateNotEmpty
    }
    
    private func showHideShopError(_ isNotEmpty: Bool) {
        self.shopListErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideFromDateError(_ isNotEmpty: Bool) {
        self.fromDateErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideToDateError(_ isNotEmpty: Bool) {
        self.toDateErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func setupDropDownAppearance() {
        
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 36
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
    }
    
    private func setupShopListDropDown() {
        
        self.shopListDropDown.anchorView = self.shopListButton
        
        self.shopListDropDown.topOffset = CGPoint(x: 0, y: self.shopListButton.bounds.height)
        self.shopListDropDown.direction = .any
        self.shopListDropDown.dismissMode = .automatic
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getShopList ( weakify { strong, shopList in
                let arr = shopList ?? []
                
                arr.forEach({ (shop) in
                    strong.shops.append(shop)
                    if let name = shop.name {
                        strong.shopListDropDown.dataSource.append(name)
                    }
                })
                strong.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            if !self.shops.isEmpty {
                self.selectShop(self.shops.first?.name ?? "")
            }
        }
                
        self.shopListDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectShop(item)
        }
    }
    
    private func selectShop(_ shopName: String) {
        
        for (index, shop) in self.shops.enumerated() {
            if shopName == shop.name {
                self.shopListDropDown.selectRow(index)
                self.shopListLabel.text = shopName
                self.selectedShop = shop
                self.shopListErrorImageView.image = .none
                break
            }
        }
    }
    
    @objc private func showFromDatePicker(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.fromDateTextField.becomeFirstResponder()
    }
    
    private func createFromDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.fromDateDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.fromDateTextField.inputAccessoryView = toolbar
        self.fromDateTextField.inputView = self.fromDatePicker
        
        self.fromDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            self.fromDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func fromDateDonePressed() {
        
        let date = self.formatDate(self.fromDatePicker.date)
        self.fromDateTextField.text = date
        self.showHideFromDateError(self.fromDateTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    @objc private func showToDatePicker(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.toDateTextField.becomeFirstResponder()
    }
    
    private func createToDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dueDateDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)

        self.toDateTextField.inputAccessoryView = toolbar
        self.toDateTextField.inputView = self.toDatePicker
        
        self.toDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            self.toDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func dueDateDonePressed() {
        
        let date = self.formatDate(self.toDatePicker.date)
        self.toDateTextField.text = date
        self.showHideToDateError(self.toDateTextField.text!.isNotEmpty)
        self.dateCancelPressed()
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }
    
    private func formatDate(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        return dateFormatter.string(from: date)
    }
}
