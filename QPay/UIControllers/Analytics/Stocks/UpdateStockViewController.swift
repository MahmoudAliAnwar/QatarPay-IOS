//
//  UpdateStockViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class UpdateStockViewController: ViewController {
    
    @IBOutlet weak var marketLabel       : UILabel!
    
    @IBOutlet weak var stockNameLabel    : UILabel!
    
    @IBOutlet weak var stockPriceLabel   : UILabel!
    
    @IBOutlet weak var quantityLabel     : UILabel!
    
    @IBOutlet weak var totalAmountLabel  : UILabel!
    
    @IBOutlet weak var groupLabel        : UILabel!
    
    @IBOutlet weak var groupButton       : UIButton!
    
    @IBOutlet weak var marketEditLabel   : UILabel!
    
    @IBOutlet weak var marketButton      : UIButton!
    
    @IBOutlet weak var stockIDLabel      : UILabel!
    
    @IBOutlet weak var stockIDButton     : UIButton!
    
    @IBOutlet weak var quantityTextField : UITextField!
    
    @IBOutlet weak var priceTextField    : UITextField!
    
    @IBOutlet weak var updateView        : UIView!
    
    var stock     : MyStockList?
    var groupName : String?
    
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
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
}

extension UpdateStockViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.updateView.isHidden = true
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
            if let name = self.groupName {
                self.selectedGroup = self.groups.first(where: { $0._name == name })
             }
        })
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getUserStocks({ userStocks in
            self.dispatchGroup.leave()
            guard let list = userStocks else { return }
            self.stocks = list
            self.setupStocksDropDown()
            if let name = self.stock?._stockName {
                self.selectedStock = self.stocks.first(where: { $0._name == name })
            }
        })
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getStockMarkets({ stockMarkets in
            self.dispatchGroup.leave()
            guard let list = stockMarkets else { return }
            self.markets = list
            self.setupMarketsDropDown()
            if let name = self.stock?._marketName {
                self.selectedMarket = self.markets.first(where: { $0._name == name })
            }
        })
        
        self.dispatchGroup.notify(queue: .main) {

        }
     }
    
    func fetchData() {
        guard let myStock = stock ,
              let name = groupName else {
            return
        }
        
        self.marketLabel.text        = ":  \(myStock._marketName)"
        self.stockNameLabel.text     = ":  \(myStock._stockName)"
        self.stockPriceLabel.text    = ":  \(myStock._price)"
        self.quantityLabel.text      = ":  \(myStock._quantity)"
        let total                    =  Double(myStock._quantity) * myStock._price
        self.totalAmountLabel.text   = ":  \(total)"
        
        self.marketEditLabel.text    = "\(myStock._marketName)"
        self.stockIDLabel.text       = "\(myStock._stockName)"
        self.priceTextField.text     = "\(myStock._price)"
        self.quantityTextField.text  = "\(myStock._quantity)"
        self.groupLabel.text         =  name
    }
}

// MARK: - ACTIONS

extension UpdateStockViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        self.updateView.isHidden = false
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let id = stock?._requestID else { return }
        let alert = UIAlertController(title: "Alert", message: "Do you want to Delete this stock ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            
            self.requestProxy.requestService()?.removeStocks(requestID: id, { respons in
                guard let resp = respons else { return }
                
                if resp._success {
                    self.navigationController?.popViewController(animated: true)
                    self.showSuccessMessage(resp._message)
                } else {
                    self.showErrorMessage(resp._message)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
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
    
    @IBAction func updateAction(_ sender: UIButton) {
        guard var mStock     = self.stock ,
              let quantity   = self.quantityTextField.text ,
              let price      = self.priceTextField.text,
              let marketName = self.selectedMarket?._name,
              let stockName  = self.selectedStock?._name else {
            return
        }
        mStock.quantity = Int(quantity)
        mStock.price    = Double(price)
        self.marketLabel.text        = ":  \(marketName)"
        self.stockNameLabel.text     = ":  \(stockName)"
        self.stockPriceLabel.text    = ":  \(mStock._price)"
        self.quantityLabel.text      = ":  \(mStock._quantity)"
        let total                    =  Double(mStock._quantity) * mStock._price
        self.totalAmountLabel.text   = ":  \(total)"
        self.requestProxy.requestService()?.updateStocks(stock    : mStock,
                                                         groupID  : self.selectedGroup?._id  ?? 0 ,
                                                         marketID : self.selectedMarket?._id ?? 0 ,
                                                         stockID  : self.selectedStock?._id  ?? 0 ,{ response in
            guard let resp = response else {
                return }
            
            if resp._success {
                self.navigationController?.popViewController(animated: true)
                self.showSuccessMessage(resp._message)
            } else {
                self.showErrorMessage(resp._message)
            }
        })
    }
}

// MARK: - REQUESTS DELEGATE

extension UpdateStockViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .removeStocks ||
            request == .updateStocks {
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

// MARK: - CUSTOM FUNCTIONS

extension UpdateStockViewController {
    
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
        self.marketEditLabel.text = market._name
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
