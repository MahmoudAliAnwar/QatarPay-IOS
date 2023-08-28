//
//  KahramaaBillsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class KahramaaBillsViewController: KahramaaBillsController {
    
    @IBOutlet weak var totalBillsLabel: UILabel!
    
    @IBOutlet weak var numbersHeaderView: SelectAllHeaderView!
    @IBOutlet weak var numbersStackView: UIStackView!
    @IBOutlet weak var emptyNumbersStackView: UIStackView!
    
    @IBOutlet weak var numberCountLabel: UILabel!
    @IBOutlet weak var numberCountTotalLabel: UILabel!
    
    @IBOutlet weak var numbersCollectionView: UICollectionView!
    
    @IBOutlet weak var paymentViewDesign: ViewDesign!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    
    var groups = [GroupWithNumbers<KahramaaNumber>]()
    
    let colors: [UIColor] = [
        .systemIndigo,
        .systemTeal,
        .systemGreen,
        .systemYellow,
        .systemOrange,
        .lightGray,
    ]
    
    private var colorIndex: Int = 0
    private var isColorSetToSections: Bool = false
    private var startNumbersCount: Int = 0
    private var isSelectNumber: Bool = false
    private var selectedNumbers = [KahramaaNumber]()

    typealias ColorClosure = (section: Int, colorIndex: Int)
    var colorsDictionary: [ColorClosure] = []
    
    private lazy var phoneExpandableCellDesign: PhoneExpandableCellDesign = {
        return PhoneExpandableCellDesign()
    }()
    
    private var total: Double = 0
    
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
        
        self.isUserHasNumbers(false)
        
        self.dispatchGroup.enter()
        
        self.isColorSetToSections = false
        
        self.requestProxy.requestService()?.getGroupListWithKahramaaNumbers { (status, response) in
            guard status else { return }
            
            let groups = (response?._list ?? []).filter({ $0._numbers.isNotEmpty })
            self.isUserHasNumbers(groups.count > 0)
            self.groups = groups
            
            let count = self.groups.compactMap({ $0._numbers.count })
            self.startNumbersCount = count.reduce(0, +)
//            self.totalBillsLabel.text = "\(response?._grandTotal.formatNumber() ?? "0.0")"
            
            let allTotal = self.groups.reduce(0) { res, group in
                res  + group._total
            }
            
            self.totalBillsLabel.text = "\(allTotal.formatNumber())"
            
            self.setIsEnablePaymentButton(false)
            self.numbersHeaderView.setIsItemSelected(false)
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.numbersCollectionView.reloadData()
        }
    }
}

extension KahramaaBillsViewController {
    
    func setupView() {
        self.numbersCollectionView.registerNib(ExpandableCollectionViewCell.self)
        
        self.numbersCollectionView.delegate = self
        self.numbersCollectionView.dataSource = self
        
        self.numbersHeaderView.delegate = self
        
        self.changeStatusBarBG(color: UIColor(red: 4/255, green: 128/255, blue: 191/255, alpha: 1))

    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension KahramaaBillsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addNumberAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddKahramaaNumberViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func payAndGoAction(_ sender: UIButton) {
//        let vc = self.getStoryboardView(PayOnTheGoKahramaaViewController.self)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func paymentAction(_ sender: UIButton) {
        
        let groupDetails = self.selectedNumbers.compactMap({ GroupDetails(groupID: $0._groupID, number: [$0._number]) })
        
        var paymentRequestPhoneBillParams          = PaymentRequestPhoneBillParams()
        paymentRequestPhoneBillParams.groupDetails = groupDetails
        paymentRequestPhoneBillParams.isFullAmount = true
        paymentRequestPhoneBillParams.amount       = self.total
        
        self.requestProxy.requestService()?.savePaymentRequestkaharmaBill(paymentRequestPhoneBillParams: paymentRequestPhoneBillParams, { response in
            guard let resp = response else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                
                let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
                vc.paymentViaBillResponse = resp
                self.present(vc, animated: true)
            }
        })
        
//        guard self.isSelectNumber == true else {
//            self.showSnackMessage("Please, select number to continue")
//            return
//        }
//        let vc = self.getStoryboardView(PayOnTheGoKahramaaViewController.self)
//        vc.amount = self.total
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension KahramaaBillsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let myGroup = self.groups[section]
        if myGroup.isOpened {
            return myGroup._numbers.count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ExpandableCollectionViewCell.self, for: indexPath)
        cell.delegate = self
        
        let group = self.groups[indexPath.section]
        
        cell.isShowTopSeperator = indexPath.row == 1
        
        if indexPath.row == 0 {
            cell.titleLabel.text = group._name
            cell.descriptionLabel.text = "\(group._numbers.count) numbers"
            cell.totalLabel.text = "QAR \(group._total.formatNumber())"
            cell.isCellSelected = group.isSelected
            
            if !self.isColorSetToSections {
                /// Set colorIndex to zero if it greater than colors array count
                if self.colorIndex == self.colors.count {
                    self.colorIndex = 0
                }
                
                /// Save section color indexes to dictionary
                self.colorsDictionary.append((section: indexPath.section, colorIndex: self.colorIndex))
                cell.changeLeftViewDesignBackgroundColor(self.colors[self.colorIndex])
                
                self.colorIndex += 1
                self.isColorSetToSections = indexPath.section == self.groups.count-1
                
            } else {
                let cIndex = self.colorsDictionary[indexPath.section].colorIndex
                cell.changeLeftViewDesignBackgroundColor(self.colors[cIndex])
            }
            
            cell.setupCell(to: .Section(isOpened: group.isOpened), with: self.phoneExpandableCellDesign)
            
        } else {
            let object = group._numbers[indexPath.row-1]
            
            cell.titleLabel.text = object._subscriberName
            cell.descriptionLabel.text = object.number
            cell.totalLabel.text = "QAR \(object._currentBill.formatNumber())"
            cell.isCellSelected = object.isSelected
            
            let cIndex = self.colorsDictionary[indexPath.section].colorIndex
            cell.changeLeftViewDesignBackgroundColor(self.colors[cIndex])
            
            cell.setupCell(to: .Row(isLastRow: indexPath.row == group._numbers.count), with: self.phoneExpandableCellDesign)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let group = self.groups[indexPath.section]
        
        if indexPath.row == 0 {
            self.groups[indexPath.section].isOpened = !self.groups[indexPath.section].isOpened
            
            guard group._numbers.count > 0 else { return }
            collectionView.reloadSections([indexPath.section])
            
        }else {
            let vc = self.getStoryboardView(KahrmaBillOperationsViewController.self)
            vc.number = group._numbers[indexPath.row - 1]
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

extension KahramaaBillsViewController: SelectAllHeaderViewDelegate {
    
    var selectAllHeaderViewDesign: SelectAllHeaderViewDesign {
        get {
            return KahramaaSelectAllHeaderViewDesign()
        }
    }
    
    func didTapSelectAllCheckBox(with isSelected: Bool) {
        for i in 0..<self.groups.count {
            self.groups[i].isSelected = isSelected
        }
        
        self.numbersCollectionView.reloadData()
        self.calculateSelectedNumbers()
        self.setIsEnablePaymentButton(isSelected)
    }
}

// MARK: - EXPANDABLE CELL DELEGATE

extension KahramaaBillsViewController: ExpandableCollectionViewCellDelegate {
    
    var cellColor: UIColor {
        get {
            return self.selectAllHeaderViewDesign.viewColor
        }
    }
    
    func didTapCheckBox(_ cell: ExpandableCollectionViewCell,
                        isSelected: Bool,
                        cellType: ExpandableCollectionViewCell.CellType,
                        at indexPath: IndexPath) {
        
        switch cellType {
        case .Section(isOpened: _):
            self.groups[indexPath.section].isSelected = isSelected
            break
            
        case .Row(isLastRow: _):
            self.groups[indexPath.section]._numbers[indexPath.row-1].isSelected = isSelected
            
            let selectedStocksInSection = self.groups[indexPath.section]._numbers.filter({ $0.isSelected == true })
            if selectedStocksInSection.count == self.groups[indexPath.section]._numbers.count ||
                selectedStocksInSection.count == 0 {
                self.groups[indexPath.section].isSelected = isSelected
            }
            break
        }
        
        self.numbersCollectionView.reloadSections([indexPath.section])
        self.numbersHeaderView.setIsItemSelected(self.isSelectedAll())
        self.setIsEnablePaymentButton(self.isSelectedOneOrMore())
        self.calculateSelectedNumbers()
    }
}

// MARK: - REQUESTS DELEGATE

extension KahramaaBillsViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .getGroupListWithKahramaaNumbers ||
            request == .savePaymentRequestViaKaharmaBill {
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

extension KahramaaBillsViewController {
    
    private func isSelectedAll() -> Bool {
        
        let selectedSections = self.groups.filter({ $0.isSelected == true })
        
        if selectedSections.count == self.groups.count {
            var selectedCount: Int = 0
            
            for section in selectedSections {
                let selectedStocks = section._numbers.filter({ $0.isSelected == true })
                if selectedStocks.count == section._numbers.count {
                    selectedCount += selectedStocks.count
                }
            }
            return selectedCount == self.startNumbersCount
        }
        
        return false
    }
    
    private func isSelectedOneOrMore() -> Bool {
        
        for section in self.groups {
            let selectedNumbers = section._numbers.filter({ $0.isSelected == true })
            if selectedNumbers.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    private func calculateSelectedNumbers() {
        
        let selectedSectionWithNumbers = self.groups.flatMap({ $0._numbers.filter({ $0.isSelected == true }) })
        self.selectedNumbers = selectedSectionWithNumbers
        let selectedStocksTotal = selectedSectionWithNumbers.reduce(0) { (res, group) -> Double in
            return res + (group._currentBill)
        }
        self.total = selectedStocksTotal
        self.setNumbersLabelCount(selectedSectionWithNumbers.count)
        self.setNumbersLabelTotal(selectedStocksTotal)
    }
    
    private func setNumbersLabelCount(_ count: Int) {
        self.numberCountLabel.text = "\(count) number(s) selected"
    }
    
    private func setNumbersLabelTotal(_ total: Double) {
        self.numberCountTotalLabel.text = "QAR \(total == 0 ? "0.00" : total.formatNumber())"
    }
    
    private func isUserHasNumbers(_ status: Bool) {
        self.emptyNumbersStackView.isHidden = status
        self.numbersStackView.isHidden = !status
    }
    
    private func setIsEnablePaymentButton(_ status: Bool) {
        self.paymentButton.isEnabled = status
        self.paymentViewDesign.backgroundColor = status ? .mPhone_Bill_Red : .systemGray4
    }
}

class KahramaaSelectAllHeaderViewDesign: SelectAllHeaderViewDesign {
    
    var viewColor: UIColor {
        get {
            return .mKahramaa_Dark_Blue
        }
    }
    
    var isHideDeleteButton: Bool {
        get {
            return true
        }
    }
}
