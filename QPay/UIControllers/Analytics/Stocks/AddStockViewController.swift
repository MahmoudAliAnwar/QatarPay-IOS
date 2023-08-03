//
//  AddStockViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class AddStockViewController: StocksController {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var advImageView: UIImageView!
    
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var groupButton: UIButton!
    
    @IBOutlet weak var marketLabel: UILabel!
    
    @IBOutlet weak var marketButton: UIButton!
    
    @IBOutlet weak var stockIDLabel: UILabel!
    
    @IBOutlet weak var stockIDButton: UIButton!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var purchaseDateTextField: UITextField!
    
    @IBOutlet weak var calendarImageView: UIImageView!
    
    private var purchaseDatePicker = UIDatePicker()
    
    private lazy var groupsDropDown: DropDown = {
        return DropDown()
    }()
    
    private var groups = [StockGroup]() {
        didSet {
            self.groupsDropDown.dataSource = self.groups.compactMap({ $0._name })
            self.groupsDropDown.reloadAllComponents()
        }
    }
    
    private var selectedGroup: StockGroup?
    
    private lazy var marketsDropDown: DropDown = {
        return DropDown()
    }()
    
    private var markets = [StockMarket]() {
        didSet {
            self.marketsDropDown.dataSource = self.markets.compactMap({ $0._name })
            self.marketsDropDown.reloadAllComponents()
        }
    }
    
    private var selectedMarket: StockMarket?
    
    private lazy var stocksDropDown: DropDown = {
        return DropDown()
    }()
    
    private var stocks = [UserStock]() {
        didSet {
            self.stocksDropDown.dataSource = self.stocks.compactMap({ $0._name })
            self.stocksDropDown.reloadAllComponents()
        }
    }
    
    private var selectedStock: UserStock?
    
    private var advs = [StockAdv]()
    
    private var timer: Timer?
    
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

        self.requestProxy.requestService()?.getStockAdv({ advList in
            guard let list = advList else { return }
            self.advs = list
            guard let imageURL = list.first?._path else { return }
            self.advImageView.kf.setImage(with: URL(string: imageURL.correctUrlString()))
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
                guard let url = self.advs.randomElement()?._path.correctUrlString() else { return }
                self.advImageView.kf.setImage(with: URL(string: url))
            })
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer?.invalidate()
    }
}

extension AddStockViewController {
    
    func setupView() {
        self.containerViewDesign.cornerRadius = 10
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.createPurchaseDatePicker()
    }
    
    func localized() {
    }
    
    func setupData() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getStockGroup({ stockGroups in
            self.dispatchGroup.leave()
            guard let list = stockGroups else { return }
            self.groups = list
            self.setupGroupDropDown()
        })
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getUserStocks({ userStocks in
            self.dispatchGroup.leave()
            guard let list = userStocks else { return }
            self.stocks = list
            self.setupStocksDropDown()
        })
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getStockMarkets({  stockMarkets in
            self.dispatchGroup.leave()
            guard let list = stockMarkets else { return }
            self.markets = list
            self.setupMarketsDropDown()
        })
        
        self.dispatchGroup.notify(queue: .main) {
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddStockViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func groupDropDownAction(_ sender: UIButton) {
        self.groupsDropDown.show()
    }
    
    @IBAction func marketDropDownAction(_ sender: UIButton) {
        self.marketsDropDown.show()
    }
    
    @IBAction func stockIDDropDownAction(_ sender: UIButton) {
        self.stocksDropDown.show()
    }
    
    
    @IBAction func createGroupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(CreateStocksGroupViewController.self)
        vc.updateViewDelegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        guard let group = self.selectedGroup, group._id != 0 else {
            self.showErrorMessage("Please Select Group")
            return
        }
        
        guard let market = self.selectedMarket, market._id != 0 else {
            self.showErrorMessage("Please Select Market")
            return
        }
        
        guard let stock = self.selectedStock, stock._id != 0 else {
            self.showErrorMessage("Please Select StockID")
            return
        }
        
        guard let quantityText = self.quantityTextField.text, quantityText.isNotEmpty else {
            self.showErrorMessage("Please Select Quantity")
            return
        }
        
        guard let priceText = self.priceTextField.text, priceText.isNotEmpty else {
            self.showErrorMessage("Please Select Price")
            return
        }
        
        guard let dateText = self.purchaseDateTextField.text, dateText.isNotEmpty else {
            self.showErrorMessage("Please Select Purchase Date")
            return
        }
        
        let quantity: Int = quantityText.integerValue ?? 0
        let price: Double = priceText.doubleValue ?? 0.0
        
        guard quantity > 0,
              price > 0 else {
            return
        }
        
        let date = self.purchaseDatePicker.date
        
        self.requestProxy.requestService()?.addNewStock(groupID: group._id, marketID: market._id, stockID: stock._id, quantity: quantity, price: price, date: date.formatDate(ServerDateFormat.Server1.rawValue)) {(response) in
            
            guard let resp = response else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.navigationController?.popViewController(animated: true)
                self.showSuccessMessage(resp._message)
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension AddStockViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addNewStock {
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

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension AddStockViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        if view is CreateStocksGroupViewController {
            self.viewWillAppear(true)
            self.requestProxy.requestService()?.getStockGroup({ stockGroups in
                guard let list = stockGroups else { return }
                self.groups = list
            })
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension AddStockViewController {
    
    private func createPurchaseDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let centerSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.purchaseDatePickerDonePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dateCancelPressed))
        
        toolbar.setItems([cancelBtn, centerSpace,doneBtn], animated: true)
        
        self.purchaseDateTextField.inputAccessoryView = toolbar
        self.purchaseDateTextField.inputView = self.purchaseDatePicker
        
        self.purchaseDatePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            self.purchaseDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func purchaseDatePickerDonePressed() {
        self.setPurchaseDateTextField(self.purchaseDatePicker.date)
    }
    
    private func setPurchaseDateTextField(_ date: Date) {
        let formattedDate = date.formatDate(libraryFieldsDateFormat)
        self.purchaseDateTextField.text = formattedDate
        self.dateCancelPressed()
    }
    
    @objc private func dateCancelPressed() {
        self.view.endEditing(true)
    }

    private func setupGroupDropDown() {
        self.groupsDropDown.anchorView = self.groupButton
        self.groupsDropDown.topOffset = CGPoint(x: 0, y: self.groupButton.bounds.height)
        //        self.groupsDropDown.direction = .bottom
        
        self.groupsDropDown.selectionAction = { [weak self] (index, item) in
            self?.groupsDropDown.selectRow(index)
            guard let myGroup = self?.groups[index] else { return }
            self?.selectGroup(myGroup)
        }
    }
    
    private func selectGroup(_ group: StockGroup) {
        self.groupLabel.text = group._name
        self.selectedGroup = group
    }
    
    private func setupStocksDropDown() {
        self.stocksDropDown.anchorView = self.stockIDButton
        self.stocksDropDown.topOffset = CGPoint(x: 0, y: self.stockIDButton.bounds.height)
        //        self.stocksDropDown.direction = .bottom
        
        self.stocksDropDown.selectionAction = { [weak self] (index, item) in
            self?.groupsDropDown.selectRow(index)
            guard let myStock = self?.stocks[index] else { return }
            self?.selectStock(myStock)
        }
    }
    
    private func selectStock(_ stock: UserStock) {
        self.stockIDLabel.text = stock._name
        self.selectedStock = stock
    }
    
    private func setupMarketsDropDown() {
        self.marketsDropDown.anchorView = self.marketButton
        self.marketsDropDown.topOffset = CGPoint(x: 0, y: self.marketButton.bounds.height)
        //        self.marketsDropDown.direction = .bottom
        
        self.marketsDropDown.selectionAction = { [weak self] (index, item) in
            self?.marketsDropDown.selectRow(index)
            guard let myMarket = self?.markets[index] else { return }
            self?.selectMarket(myMarket)
        }
    }
    
    private func selectMarket(_ market: StockMarket) {
        self.marketLabel.text = market._name
        self.selectedMarket = market
    }
    private func setupDropDownAppearance() {
        let appearance = DropDown.appearance()

        appearance.direction = .bottom
//        self.groupDropDown.dismissMode = .automatic

        appearance.cellHeight = 40

        appearance.backgroundColor = .white
        appearance.selectionBackgroundColor = .lightGray
        appearance.cornerRadius = 10
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.animationduration = 0.25
        appearance.textColor = .mBrown
    }
}
