//
//  StocksTrackerViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 16/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit
import MarqueeLabel

class StocksTrackerViewController: StocksController {
    
    /// Market Info Labels...
    
    @IBOutlet weak var marketStatusLabel                   : UILabel!
    
    @IBOutlet weak var lastUpdateLabel                     : UILabel!
    
    @IBOutlet weak var qeIndexLabel                        : UILabel!
    
    @IBOutlet weak var infoCurrentDifferenceAmountLabel    : UILabel!
    
    @IBOutlet weak var infoCurrentDifferencePercentLabel   : UILabel!
    
    @IBOutlet weak var newsMarqueeLabel                    : MarqueeLabel!
    
    /// Short summary Labels...
    
    @IBOutlet weak var todayDataLabel                       : UILabel!
    
    @IBOutlet weak var currentIndexLabel                    : UILabel!
    
    @IBOutlet weak var previousIndexLabel                   : UILabel!
    
    @IBOutlet weak var currentDifferenceAmountLabel         : UILabel!
    
    @IBOutlet weak var currentDifferencePercentLabel        : UILabel!
    
    @IBOutlet weak var tradesLabel                          : UILabel!
    
    @IBOutlet weak var volumeLabel                          : UILabel!
    
    @IBOutlet weak var volumeQARLabel                       : UILabel!
    
    @IBOutlet weak var stockGroupsCollectionView            : UICollectionView!
    
    @IBOutlet weak var stocksCollectionViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var candleChartStackView                 : UIStackView!
    
    @IBOutlet weak var marketSummaryStackView               : UIStackView!
    
    private var stockGroupDetails = [StockGroupDetails]() {
        didSet {
            self.startStocksCount = self.stockGroupDetails.count
            self.updateCollectionHeightConstraint()
        }
    }
    
    private let colors: [UIColor] = [
        .systemIndigo,
        .systemTeal,
        .systemGreen,
        .systemYellow,
        .systemOrange,
        .lightGray,
    ]
    
    private var colorIndex           : Int = 0
    private var startStocksCount     : Int = 0
    private var isColorSetToSections : Bool = false
    
    private typealias ColorClosure = (section: Int, colorIndex: Int)
    private var colorsDictionary: [ColorClosure] = []
    
    private lazy var stocksExpandableCellDesign: StocksExpandableCellDesign = {
        return StocksExpandableCellDesign()
    }()
    
    private var stockGroup = [MyStocksGroupDetails]() {
        didSet {
            self.startStocksCount = self.stockGroup.count
            self.updateCollectionHeightConstraint()
        }
    }
    
    private var onCilck : Bool = false
    
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
        
        self.showLoadingView(self)
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getStocks({ stocks in
            self.dispatchGroup.leave()
            guard let list = stocks else { return }
            self.stockGroup = list
            self.stockGroupsCollectionView.reloadData()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.hideLoadingView()
        }
    }
}

extension StocksTrackerViewController {
    
    func setupView() {
        self.newsMarqueeLabel.speed = .duration(40)
        
        self.stockGroupsCollectionView.delegate   = self
        self.stockGroupsCollectionView.dataSource = self
        self.stockGroupsCollectionView.registerNib(ExpandableCollectionViewCell.self)
        self.changeToggleBtn()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getStockTracker({ stockTracker in
            self.dispatchGroup.leave()
            guard let tracker = stockTracker else { return }
            
            if let marketInfo = tracker.marketPrimaryInfoDetails?.first {
                self.marketStatusLabel.text                 = marketInfo._status
                self.lastUpdateLabel.text                   = marketInfo._lastUpdate
                self.qeIndexLabel.text                      = "\(marketInfo._qeIndex)"
                self.infoCurrentDifferenceAmountLabel.text  = "\(marketInfo._current_difference_Amt)"
                self.infoCurrentDifferencePercentLabel.text = "\(marketInfo._current_difference_Percntge)%"
                self.newsMarqueeLabel.text                  = marketInfo._stockNews
            }
            
            if let shortSummary = tracker._marketShortSummaryDetails.first {
                self.todayDataLabel.text = shortSummary._todaysDate
                
                if shortSummary._current_difference_Amt > 0 {
                    self.currentDifferenceAmountLabel.textColor  = self.stockUpColor
                    self.currentDifferencePercentLabel.textColor = self.stockUpColor
                    self.currentIndexLabel.textColor             = self.stockUpColor
                    self.previousIndexLabel.textColor            = self.stockUpColor
                    
                } else if shortSummary._current_difference_Amt < 0 {
                    self.currentDifferenceAmountLabel.textColor  = self.stockDownColor
                    self.currentDifferencePercentLabel.textColor = self.stockDownColor
                    self.currentIndexLabel.textColor             = self.stockDownColor
                    self.previousIndexLabel.textColor            = self.stockDownColor
                    
                } else {
                    self.currentDifferenceAmountLabel.textColor  = self.stockUnchangedColor
                    self.currentDifferencePercentLabel.textColor = self.stockUnchangedColor
                    self.currentIndexLabel.textColor             = self.stockUnchangedColor
                    self.previousIndexLabel.textColor            = self.stockUnchangedColor
                }
                
                self.currentIndexLabel.text                      = "\(shortSummary._currentIndex)"
                self.previousIndexLabel.text                     = "\(shortSummary._previousIndex)"
                self.currentDifferenceAmountLabel.text           = "\(shortSummary._current_difference_Amt)"
                self.currentDifferencePercentLabel.text          = "\(shortSummary._current_difference_Percntge)"
                self.volumeLabel.text                            = "\(shortSummary._volume)"
                self.tradesLabel.text                            = "\(shortSummary._trades)"
                self.volumeQARLabel.text                         = "QAR \(shortSummary._valueQAR)"
            }
        })
    }
}

// MARK: - ACTIONS

extension StocksTrackerViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addStockAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddStockViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chartAction(_ sender: UIButton) {
        self.changeToggleBtn()
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension StocksTrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.stockGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let mySection = self.stockGroup[section]
        if mySection.isOpened {
            return mySection._stockList.count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ExpandableCollectionViewCell.self, for: indexPath)
        
        let section = self.stockGroup[indexPath.section]
        
        cell.delegate = self
        
        cell.isShowTopSeperator = indexPath.row == 1
        
        if indexPath.row == 0 {
            
            cell.titleLabel.text = section._groupName
            cell.descriptionLabel.text = "\(section._stockList.count) stocks"
            //            cell.isCellSelected = section.isSelected
            
            if !self.isColorSetToSections {
                /// Set colorIndex to zero if it greater than colors array count
                if self.colorIndex == self.colors.count {
                    self.colorIndex = 0
                }
                
                /// Save section color indexes to dictionary
                self.colorsDictionary.append((section: indexPath.section, colorIndex: self.colorIndex))
                cell.changeLeftViewDesignBackgroundColor(self.colors[self.colorIndex])
                
                self.colorIndex += 1
                self.isColorSetToSections = indexPath.section == self.stockGroup.count - 1
                
            } else {
                let cIndex = self.colorsDictionary[indexPath.section].colorIndex
                cell.changeLeftViewDesignBackgroundColor(self.colors[cIndex])
            }
            
            cell.setupCell(to: .Section(isOpened: section.isOpened), with: self.stocksExpandableCellDesign)
            
        } else {
            let object = section._stockList[indexPath.row - 1]
            let totalPrice = Double(object._quantity) * object._price
            
            cell.titleLabel.text       = object._marketName
            cell.descriptionLabel.text = "\(object._quantity) stocks"
            cell.totalLabel.text       = "QAR \(totalPrice.formatNumber())"
            //            cell.isCellSelected        = object.isSelected
            
            let cIndex = self.colorsDictionary[indexPath.section].colorIndex
            cell.changeLeftViewDesignBackgroundColor(self.colors[cIndex])
            
            cell.setupCell(to: .Row(isLastRow: indexPath.row == section._stockList.count), with: self.stocksExpandableCellDesign)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
                let section = self.stockGroup[indexPath.section]
        
        if indexPath.row == 0 {
            self.stockGroup[indexPath.section].isOpened = !self.stockGroup[indexPath.section].isOpened
            
            collectionView.reloadSections([indexPath.section])
            self.updateCollectionHeightConstraint()
            
        } else {
            let stock = section._stockList[indexPath.row - 1]
            let vc = self.getStoryboardView(UpdateStockViewController.self)
            vc.groupName = section._groupName
            vc.stock = stock
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
        
        let cellWidth = (collectionView.width - spaceBetweenCells - leftRightPadding)
        return CGSize(width: cellWidth, height: 80)
    }
}

// MARK: - HEADER VIEW DELEGATE

extension StocksTrackerViewController: SelectAllHeaderViewDelegate {
    
    var selectAllHeaderViewDesign: SelectAllHeaderViewDesign {
        get {
            return StocksSelectAllHeaderViewDesign()
        }
    }
    
    func didTapSelectAllCheckBox(with isSelected: Bool) {
        //        for i in 0..<self.stockGroupDetails.count {
        //            self.stockGroup[i].isSelected = isSelected
        //        }
        //
        //        self.calculateSelectedStocks()
        //        self.stockGroup.reloadData()
    }
}

// MARK: - EXPANDABLE CELL DELEGATE

extension StocksTrackerViewController: ExpandableCollectionViewCellDelegate {
    
    func didTapCheckBox(_ cell: ExpandableCollectionViewCell, isSelected: Bool, cellType: ExpandableCollectionViewCell.CellType, at indexPath: IndexPath) {
    }
    
    var cellColor: UIColor {
        get {
            return .mStocks_Blue
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension StocksTrackerViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getStockTracker {
//            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
//        hideLoadingView()
        
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

extension StocksTrackerViewController {
    
    private func isSelectedAll() -> Bool {
        
        let selectedSections = self.stockGroupDetails.filter({ $0.isSelected == true })
        
        if selectedSections.count == self.stockGroupDetails.count {
            var selectedCount: Int = 0
            
            for section in selectedSections {
                let selectedStocks = section._list.filter({ $0.isSelected == true })
                if selectedStocks.count == section._list.count {
                    selectedCount += selectedStocks.count
                }
            }
            return selectedCount == self.startStocksCount
        }
        
        return false
    }
    
    private func calculateSelectedStocks() {
        
        let selectedSectionWithStocks = self.stockGroupDetails.flatMap({ $0._list.filter({ $0.isSelected == true }) })
        let selectedStocksTotal = selectedSectionWithStocks.reduce(0) { partialResult, model in
            return partialResult + model._valueQAR
        }
    }
    
    private func updateCollectionHeightConstraint() {
        self.stockGroupsCollectionView.reloadData()
        self.stocksCollectionViewHeightConstraint.constant = self.stockGroupsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func changeToggleBtn() {
        self.marketSummaryStackView.isHidden = onCilck
        self.candleChartStackView.isHidden = !onCilck
        self.onCilck = !onCilck
    }
}

class StocksSelectAllHeaderViewDesign: SelectAllHeaderViewDesign {
    
    var viewColor: UIColor {
        get {
            return .mStocks_Blue
        }
    }
    
    var isHideDeleteButton: Bool {
        get {
            return true
        }
    }
}

class StocksExpandableCellDesign: ExpandableCollectionViewCellDesign {
    
    func isSectionTotalHidden(for type: ExpandableCollectionViewCell.CellType) -> Bool {
        switch type {
        case .Section(isOpened: _):
            return true
        case .Row(isLastRow: _):
            return false
        }
    }
    
    func isCheckBoxHidden(for type: ExpandableCollectionViewCell.CellType) -> Bool {
        return true
    }
    
    func sectionTotalFont(for type: ExpandableCollectionViewCell.CellType) -> UIFont? {
        return .sfDisplay(14)?.regular
    }
}
