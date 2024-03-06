//
//  StocksHomeViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 14/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import SpreadsheetView

class StocksHomeViewController: StocksController {
    
    @IBOutlet weak var collectionView                : UICollectionView!
    
    @IBOutlet weak var todayDateLabel                : UILabel!
    
    @IBOutlet weak var todayQEIndexLabel             : UILabel!
    
    @IBOutlet weak var todayCurrentDiffereneLabel    : UILabel!
    
    @IBOutlet weak var todayYTDPercentageLabel       : UILabel!
    
    @IBOutlet weak var todayVolumeLabel              : UILabel!
    
    @IBOutlet weak var todayValueQARLabel            : UILabel!
    
    @IBOutlet weak var todayTradesLabel              : UILabel!
    
    @IBOutlet weak var previousDateLabel             : UILabel!
    
    @IBOutlet weak var previousQEIndexLabel          : UILabel!
    
    @IBOutlet weak var previousCurrentDiffereneLabel : UILabel!
    
    @IBOutlet weak var previousYTDPercentageLabel    : UILabel!
    
    @IBOutlet weak var previousVolumeLabel           : UILabel!
    
    @IBOutlet weak var previousValueQARLabel         : UILabel!
    
    @IBOutlet weak var previousTradesLabel           : UILabel!
    
    @IBOutlet weak var upLabel                       : UILabel!
    
    @IBOutlet weak var downLabel                     : UILabel!
    
    @IBOutlet weak var unchangedLabel                : UILabel!
    
    @IBOutlet weak var indexStackView                : UIStackView!
    
    @IBOutlet weak var marketStackView               : UIStackView!
    
    @IBOutlet weak var newsStackView                 : UIStackView!
    
    @IBOutlet weak var marketSpreadSheetView         : SpreadsheetView!
    
    @IBOutlet weak var newsTableView                 : UITableView!
    
    @IBOutlet weak var historyStackView              : UIStackView!
    
    @IBOutlet weak var historySpreadSheetView        : SpreadsheetView!
    
    @IBOutlet weak var marketSpreadSheetViewHeightConstraint  : NSLayoutConstraint!
    
    @IBOutlet weak var historySpreadSheetViewHeightConstraint : NSLayoutConstraint!
    
    enum Tabs : String, CaseIterable {
        case index
        case market
        case myStocks
        case history
        case news
        
        var imageBG : UIImage {
            get {
                switch self {
                case .index    : return .stock_index
                case .market   : return .stock_market
                case .myStocks : return .stock_mystocks
                case .history  : return .stock_history
                case .news     : return .stock_news
                }
            }
        }
    }
    
    private var tab : Tabs   = .index
    private let spreadSheetViewHeight: CGFloat = 40
    private var marketDetails = [MarketSummaryDetails]()
    private var stocksNews    = [StocksNews]()
    private var stocksHistory = [StockHistory]()
    
    private enum TableHeaderOptions: Int, CaseIterable {
        case code = 0
        case preClose
        case openPrice
        case low
        case high
        case lastPrice
        
        var indexPath: IndexPath {
            get {
                return IndexPath(row: 0, column: self.rawValue)
            }
        }
        
        var title: String {
            get {
                switch self {
                case .code      : return "Code"
                case .preClose  : return "Pre Close"
                case .openPrice : return "Open Price"
                case .low       : return "Low"
                case .high      : return "High"
                case .lastPrice : return "Last Price"
                }
            }
        }
    }
    
    private enum HistoryTableHeaderOptions: Int, CaseIterable {
        case code = 0
        case action
        case margin
        case buyingPrice
        case sellingPrice
        case quantity
        case actionDate
        case group
        
        var indexPath: IndexPath {
            get {
                return IndexPath(row: 0, column: self.rawValue)
            }
        }
        
        var title: String {
            get {
                switch self {
                case .code         : return "Code"
                case .action       : return "Action"
                case .margin       : return "Margins"
                case .buyingPrice  : return "Buy Price"
                case .sellingPrice : return "Sell Price"
                case .quantity     : return "QTY"
                case .actionDate   : return "Action Date"
                case .group        : return "Group"
                }
            }
        }
    }
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension StocksHomeViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(StocksTabCollectionViewCell.self)
        
        self.newsTableView.delegate   = self
        self.newsTableView.dataSource = self
        self.newsTableView.registerNib(StocksNewsTableViewCell.self)
        
        self.marketSpreadSheetView.delegate                       = self
        self.marketSpreadSheetView.dataSource                     = self
        self.marketSpreadSheetView.showsHorizontalScrollIndicator = false
        self.marketSpreadSheetView.showsVerticalScrollIndicator   = false
        self.marketSpreadSheetView.gridStyle  = .solid(width: 0.8, color: .systemGray4)
        self.marketSpreadSheetView.register(MarketDateSpreadViewCell.self,
                                            forCellWithReuseIdentifier: MarketDateSpreadViewCell.reuseIdentifier
        )
        
        self.historySpreadSheetView.delegate                       = self
        self.historySpreadSheetView.dataSource                     = self
        self.historySpreadSheetView.showsHorizontalScrollIndicator = false
        self.historySpreadSheetView.showsVerticalScrollIndicator   = false
        self.historySpreadSheetView.gridStyle  = .solid(width: 0.8, color: .systemGray4)
        self.historySpreadSheetView.register(MarketDateSpreadViewCell.self,
                                             forCellWithReuseIdentifier: MarketDateSpreadViewCell.reuseIdentifier
        )
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.requestProxy.requestService()?.getMarketSummary({ marketSummary in
            guard let summary = marketSummary else { return }
            self.marketDetails = summary._marketSummaryDetails
            self.marketSpreadSheetViewHeightConstraint.constant = (self.spreadSheetViewHeight * CGFloat(self.marketDetails.count + 1)) + 10
            self.marketSpreadSheetView.reloadData()
            
            if let todaySummary = summary._todaysDateSummaryDetails.first {
                self.todayDateLabel.text = todaySummary._todaysDate
                
                if todaySummary._current_difference_Amt > 0 {
                    self.todayCurrentDiffereneLabel.textColor = self.stockUpColor
                    self.todayQEIndexLabel.textColor          = self.stockUpColor
                    
                } else if todaySummary._current_difference_Amt < 0 {
                    self.todayCurrentDiffereneLabel.textColor = self.stockDownColor
                    self.todayQEIndexLabel.textColor          = self.stockDownColor
                    
                } else {
                    self.todayCurrentDiffereneLabel.textColor = self.stockUnchangedColor
                    self.todayQEIndexLabel.textColor          = self.stockUnchangedColor
                }
                
                self.todayQEIndexLabel.text          = "\(todaySummary._qeIndex)"
                self.todayCurrentDiffereneLabel.text = "\(todaySummary._current_difference_Amt) (\(todaySummary._current_difference_Percntge)%)"
                self.todayYTDPercentageLabel.text    = "\(todaySummary._ytd_Percntge)"
                self.todayVolumeLabel.text           = "\(todaySummary._volume)"
                self.todayValueQARLabel.text         = "\(todaySummary._valueQAR)"
                self.todayTradesLabel.text           = "\(todaySummary._trades)"
            }
            
            if let previousSummary = summary._previousDateSummaryDetails.first {
                self.previousDateLabel.text = previousSummary._previousDate
                
                if previousSummary._current_difference_Amt > 0 {
                    self.previousCurrentDiffereneLabel.textColor = self.stockUpColor
                    self.previousQEIndexLabel.textColor          = self.stockUpColor
                    
                } else if previousSummary._current_difference_Amt < 0 {
                    self.previousCurrentDiffereneLabel.textColor = self.stockDownColor
                    self.previousQEIndexLabel.textColor          = self.stockDownColor
                    
                } else {
                    self.previousCurrentDiffereneLabel.textColor = self.stockUnchangedColor
                    self.previousQEIndexLabel.textColor          = self.stockUnchangedColor
                }
                
                self.previousQEIndexLabel.text          = "\(previousSummary._qeIndex)"
                self.previousCurrentDiffereneLabel.text = "\(previousSummary._current_difference_Amt) (\(previousSummary._current_difference_Percntge)%)"
                self.previousYTDPercentageLabel.text    = "\(previousSummary._ytd_Percntge)"
                self.previousVolumeLabel.text           = "\(previousSummary._volume)"
                self.previousValueQARLabel.text         = "\(previousSummary._valueQAR)"
                self.previousTradesLabel.text           = "\(previousSummary._trades)"
                
                self.upLabel.text        = "Up \(summary._up)"
                self.downLabel.text      = "Down \(summary._down)"
                self.unchangedLabel.text = "Unchanged \(summary._unchanged)"
            }
        })
    }
}

// MARK: - ACTIONS

extension StocksHomeViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension StocksHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Tabs.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueCell(StocksTabCollectionViewCell.self, for: indexPath)
        let object  = Tabs.allCases[indexPath.row]
        cell.object = object
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Tabs.allCases[indexPath.row] {
        case .index:
            self.setTab(to: .index)
            break
            
        case .market:
            self.setTab(to: .market)
            break
            
        case .myStocks:
            let vc = self.getStoryboardView(StocksTrackerViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .history:
            self.setTab(to: .history)
            self.requestProxy.requestService()?.getStockHistory({ respons in
                guard let resp = respons else { return }
                self.stocksHistory = resp
                self.historySpreadSheetViewHeightConstraint.constant = (self.spreadSheetViewHeight * CGFloat(self.stocksHistory.count + 1)) + 10
                self.historySpreadSheetView.reloadData()
            })
            break
            
        case .news:
            self.setTab(to: .news)
            self.requestProxy.requestService()?.getStockNews({ respons in
                guard let resp = respons else { return }
                self.stocksNews = resp
                self.newsTableView.reloadData()
            })
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow: CGFloat = 5
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let topBottomPadding : CGFloat = flowLayout.sectionInset.top + flowLayout.sectionInset.bottom
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
        let cellHeight = (collectionView.height - topBottomPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: 50, height: cellHeight)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension StocksHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocksNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    = tableView.dequeueCell(StocksNewsTableViewCell.self, for: indexPath)
        let object  = self.stocksNews[indexPath.row]
        cell.object = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - SPREAD VIEW DELEGATE

extension StocksHomeViewController: SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        
        if spreadsheetView == self.marketSpreadSheetView {
            let count = TableHeaderOptions.allCases.count
            return count
            
        } else if spreadsheetView == self.historySpreadSheetView {
            let count = HistoryTableHeaderOptions.allCases.count
            return count
        }
        return 0
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        
        if spreadsheetView == self.marketSpreadSheetView {
            let count = self.marketDetails.count + 1
            return count
            
        } else if spreadsheetView == self.historySpreadSheetView {
            let count = self.stocksHistory.count + 1
            return count
        }
        return 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if spreadsheetView == self.marketSpreadSheetView {
            return column == 0 ? 90 : 60
            
        } else if spreadsheetView == self.historySpreadSheetView {
            return column == 0 ? 90 : 80
        }
        return 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return self.spreadSheetViewHeight
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: MarketDateSpreadViewCell.reuseIdentifier, for: indexPath) as! MarketDateSpreadViewCell
        
        if spreadsheetView == self.marketSpreadSheetView {
            
            guard let option = TableHeaderOptions(rawValue: indexPath.section) else { return cell }
            
            if indexPath.row == 0 {
                cell.text                    = option.title
                cell.configuration.textFont  = UIFont.sfDisplay(11)
                cell.backgroundColor         = .mMarketWatch
                cell.configuration.textColor = .white
                return cell
            }
            
            let market = self.marketDetails[indexPath.row - 1]
            cell.backgroundColor = .white
            cell.configuration.textColor = .black
            
            if option == .code {
                cell.configuration.textFont = UIFont.sfDisplay(12)?.bold
                
            } else {
                cell.configuration.textFont = UIFont.sfDisplay(12)
            }
            switch option {
            case .code:
                cell.text = market._name
                return cell
                
            case .preClose:
                cell.text = "\(market._preClose)"
                return cell
                
            case .openPrice:
                cell.text = "\(market._openPrice)"
                return cell
                
            case .low:
                cell.text = "\(market._low)"
                return cell
                
            case .high:
                cell.text = "\(market._high)"
                return cell
                
            case .lastPrice:
                if market._lastPrice > market._openPrice {
                    cell.configuration.textColor = self.stockUpColor
                    
                } else if market._lastPrice < market._openPrice {
                    cell.configuration.textColor = self.stockDownColor
                    
                } else {
                    cell.configuration.textColor = self.stockUnchangedColor
                }
                cell.text = "\(market._lastPrice)"
                return cell
            }
            
        } else if spreadsheetView == self.historySpreadSheetView{
            guard let option = HistoryTableHeaderOptions(rawValue: indexPath.section) else { return cell }
            
            if indexPath.row == 0 {
                cell.text                    = option.title
                cell.configuration.textFont  = UIFont.sfDisplay(11)
                cell.backgroundColor         = .mStockHistory
                cell.configuration.textColor = .black
                cell.configuration.textFont = UIFont.sfDisplay(12)?.bold
                return cell
            }
            
            let history = self.stocksHistory[indexPath.row - 1]
            cell.backgroundColor = .white
            cell.configuration.textColor = .black
            
            if option == .code {
                cell.configuration.textFont = UIFont.sfDisplay(12)?.bold
                
            } else {
                cell.configuration.textFont = UIFont.sfDisplay(12)
            }
            
            switch option {
            case .code:
                cell.text = history._marketName
                return cell
                
            case .action:
                cell.text = "\(history._action)"
                return cell
                
            case .margin:
                cell.text = "\(history._margin)"
                return cell
                
            case .buyingPrice:
                cell.text = "\(history._buyingPrice)"
                return cell
                
            case .sellingPrice:
                cell.text = "\(history._sellingPrice)"
                return cell
                
            case .quantity:
                cell.text = "\(history._quantity)"
                return cell
                
            case .actionDate:
                guard let date  = history._actionDate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) else {
                    break
                }
                cell.text  = "\(date.formatDate("dd/MM/yyyy"))"
                return cell
                
            case .group:
                cell.text = "\(history._group)"
                return cell
            }
        }
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension StocksHomeViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request  == .getMarketSummary ||
            request == .getStocksNews
        {
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

extension StocksHomeViewController {
    
    private func setTab(to tab: Tabs) {
        self.indexStackView.isHidden   = tab != .index
        self.marketStackView.isHidden  = tab != .market
        self.newsStackView.isHidden    = tab != .news
        self.historyStackView.isHidden = tab != .history
    }
}
