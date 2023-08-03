//
//  StocksViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import MarqueeLabel
import SpreadsheetView

class StocksViewController: StocksController {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var todayDateLabel: UILabel!
    
    @IBOutlet weak var todayQEIndexLabel: UILabel!
    
    @IBOutlet weak var todayCurrentDiffereneLabel: UILabel!
    
    @IBOutlet weak var todayYTDPercentageLabel: UILabel!
    
    @IBOutlet weak var todayVolumeLabel: UILabel!
    
    @IBOutlet weak var todayValueQARLabel: UILabel!
    
    @IBOutlet weak var todayTradesLabel: UILabel!
    
    @IBOutlet weak var previousDateLabel: UILabel!
    
    @IBOutlet weak var previousQEIndexLabel: UILabel!
    
    @IBOutlet weak var previousCurrentDiffereneLabel: UILabel!
    
    @IBOutlet weak var previousYTDPercentageLabel: UILabel!
    
    @IBOutlet weak var previousVolumeLabel: UILabel!
    
    @IBOutlet weak var previousValueQARLabel: UILabel!
    
    @IBOutlet weak var previousTradesLabel: UILabel!
    
    @IBOutlet weak var spreedSheetView: SpreadsheetView!
    
    
    
    private var marketDetails = [MarketSummaryDetails]()
    
    enum TableHeaderOptions: Int, CaseIterable {
        case empty = 0
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
                case .empty: return ""
                case .preClose: return "Pre Close"
                case .openPrice: return "Open Price"
                case .low: return "Low"
                case .high: return "High"
                case .lastPrice: return "Last Price"
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
}

extension StocksViewController {
    
    func setupView() {
        self.containerViewDesign.cornerRadius = 10
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.spreedSheetView.delegate = self
        self.spreedSheetView.dataSource = self
        self.spreedSheetView.gridStyle = .solid(width: 0.8, color: .systemGray4)
        self.spreedSheetView.register(MarketDateSpreadViewCell.self,
                                      forCellWithReuseIdentifier: MarketDateSpreadViewCell.reuseIdentifier)
        
        self.requestProxy.requestService()?.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.requestProxy.requestService()?.getMarketSummary({ marketSummary in
            guard let summary = marketSummary else { return }
            
            self.marketDetails = summary._marketSummaryDetails
            self.spreedSheetView.reloadData()
            
            if let todaySummary = summary._todaysDateSummaryDetails.first {
                self.todayDateLabel.text = todaySummary._todaysDate
                
                if todaySummary._current_difference_Amt > 0 {
                    self.todayCurrentDiffereneLabel.textColor = self.stockUpColor
                    self.todayQEIndexLabel.textColor = self.stockUpColor
                    
                } else if todaySummary._current_difference_Amt < 0 {
                    self.todayCurrentDiffereneLabel.textColor = self.stockDownColor
                    self.todayQEIndexLabel.textColor = self.stockDownColor
                    
                } else {
                    self.todayCurrentDiffereneLabel.textColor = self.stockUnchangedColor
                    self.todayQEIndexLabel.textColor = self.stockUnchangedColor
                }
                
                self.todayQEIndexLabel.text = "\(todaySummary._qeIndex)"
                self.todayCurrentDiffereneLabel.text = "\(todaySummary._current_difference_Amt) (\(todaySummary._current_difference_Percntge)%)"
                self.todayYTDPercentageLabel.text = "\(todaySummary._ytd_Percntge)"
                self.todayVolumeLabel.text = "\(todaySummary._volume)"
                self.todayValueQARLabel.text = "\(todaySummary._valueQAR)"
                self.todayTradesLabel.text = "\(todaySummary._trades)"
            }
            
            if let previousSummary = summary._previousDateSummaryDetails.first {
                self.previousDateLabel.text = previousSummary._previousDate
                
                if previousSummary._current_difference_Amt > 0 {
                    self.previousCurrentDiffereneLabel.textColor = self.stockUpColor
                    self.previousQEIndexLabel.textColor = self.stockUpColor

                } else if previousSummary._current_difference_Amt < 0 {
                    self.previousCurrentDiffereneLabel.textColor = self.stockDownColor
                    self.previousQEIndexLabel.textColor = self.stockDownColor
                    
                } else {
                    self.previousCurrentDiffereneLabel.textColor = self.stockUnchangedColor
                    self.previousQEIndexLabel.textColor = self.stockUnchangedColor
                }
                
                self.previousQEIndexLabel.text = "\(previousSummary._qeIndex)"
                self.previousCurrentDiffereneLabel.text = "\(previousSummary._current_difference_Amt) (\(previousSummary._current_difference_Percntge)%)"
                self.previousYTDPercentageLabel.text = "\(previousSummary._ytd_Percntge)"
                self.previousVolumeLabel.text = "\(previousSummary._volume)"
                self.previousValueQARLabel.text = "\(previousSummary._valueQAR)"
                self.previousTradesLabel.text = "\(previousSummary._trades)"
            }
        })
    }
}

// MARK: - ACTIONS

extension StocksViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stocksWatchAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(StocksTrackerViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addStockAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddStockViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - SPREAD VIEW DELEGATE

extension StocksViewController: SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        let count = TableHeaderOptions.allCases.count
        return count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        let count = self.marketDetails.count + 1
        return count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return column == 0 ? 90 : 60
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 30
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: MarketDateSpreadViewCell.reuseIdentifier, for: indexPath) as! MarketDateSpreadViewCell
        
        guard let option = TableHeaderOptions(rawValue: indexPath.section) else { return cell }
        
        if indexPath.row == 0 {
            cell.configuration.textFont = UIFont.sfDisplay(11)
            cell.backgroundColor = .mBrown
            cell.configuration.textColor = .white
            cell.text = option.title
            return cell
        }
        
        let market = self.marketDetails[indexPath.row - 1]
        cell.backgroundColor = .white
        cell.configuration.textColor = .black
        
        if option == .empty {
            cell.configuration.textFont = UIFont.sfDisplay(12)?.bold
            
        } else {
            cell.configuration.textFont = UIFont.sfDisplay(12)
        }
        
        switch option {
        case .empty:
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
    }
}

// MARK: - REQUESTS DELEGATE

extension StocksViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getMarketSummary {
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

extension StocksViewController {
    
//    private func drawTopTriangle() {
//
//        let heightWidth = self.upTriangleView.width
//
//        upTriangleView.backgroundColor = .clear
//
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 0, y: heightWidth))
//        path.addLine(to: CGPoint(x: heightWidth / 2, y: heightWidth / 2))
//        path.addLine(to: CGPoint(x: heightWidth, y: heightWidth))
//        path.addLine(to: CGPoint(x: 0, y: heightWidth))
//
//        let shape = CAShapeLayer()
//        shape.path = path
//        shape.fillColor = UIColor.systemGreen.cgColor
//
//        upTriangleView.layer.insertSublayer(shape, at: 0)
//    }
//
//    private func drawBottomTriangle() {
//
//        let heightWidth = self.downTriangleView.width
//
//        upTriangleView.backgroundColor = .clear
//
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
//        path.addLine(to: CGPoint(x:heightWidth, y:0))
//        path.addLine(to: CGPoint(x:0, y:0))
//
//        let shape = CAShapeLayer()
//        shape.path = path
//        shape.fillColor = UIColor.systemRed.cgColor
//
//        downTriangleView.layer.insertSublayer(shape, at: 0)
//    }
}
