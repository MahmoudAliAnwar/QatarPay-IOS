//
//  PhoneVodafoneViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class PhoneVodafoneViewController: PhoneBillsController {

    @IBOutlet weak var phoneHeaderView: SelectAllHeaderView!
    
    @IBOutlet weak var totalBillsLabel: UILabel!
    
    @IBOutlet weak var phonesSelectedCountLabel: UILabel!
    
    @IBOutlet weak var phonesSelectedTotalLabel: UILabel!
    
    @IBOutlet weak var numbersCollectionView: UICollectionView!
    
    @IBOutlet weak var paymentViewDesign: ViewDesign!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    
    var groups = [GroupWithNumbers<PhoneNumber>]()
    
    private let colors: [UIColor] = [
        .systemIndigo,
        .systemTeal,
        .systemGreen,
        .systemYellow,
        .systemOrange,
        .lightGray,
    ]
    
    private var colorIndex: Int = 0
    private var isColorSetToSections: Bool = false
    private var startPhonesCount: Int = 0
    private var selectedNumbers = [PhoneNumber]()
    
    typealias ColorClosure = (section: Int, colorIndex: Int)
    private var colorsDictionary: [ColorClosure] = []
    
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
        
        self.changeStatusBarBG(color: .clear)
        
        self.requestProxy.requestService()?.delegate = self
        
        self.groupListRequest()
    }
}

extension PhoneVodafoneViewController {
    
    func setupView() {
        self.numbersCollectionView.delegate = self
        self.numbersCollectionView.dataSource = self
        
        self.numbersCollectionView.registerNib(ExpandableCollectionViewCell.self)
        
        self.phoneHeaderView.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PhoneVodafoneViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payOnTheGoAction(_ sender: UIButton) {
//        let vc = self.getStoryboardView(PayOnTheGoPhoneBillsViewController.self)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNumberAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddPhoneBillsCardViewController.self)
        vc.operatorType = .vodafone
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func proccedWithPaymentAction(_ sender: UIButton) {
        
        let groupDetails = self.selectedNumbers.compactMap({ GroupDetails(groupID: $0._groupID, number: [$0._number]) })
        
        var paymentRequestPhoneBillParams          = PaymentRequestPhoneBillParams()
        paymentRequestPhoneBillParams.operatorID   = 2
        paymentRequestPhoneBillParams.groupDetails = groupDetails
        paymentRequestPhoneBillParams.isFullAmount = true
        paymentRequestPhoneBillParams.amount       = self.total
        
        self.requestProxy.requestService()?.savePaymentRequestPhoneBill(paymentRequestPhoneBillParams: paymentRequestPhoneBillParams, { response in
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
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension PhoneVodafoneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let mySection = self.groups[section]
        if mySection.isOpened {
            return mySection._numbers.count+1
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
            cell.descriptionLabel.text = "\(group._numbers.count) mobile numbers"
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
            cell.descriptionLabel.text = "\(object._number)"
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
        
        let section = self.groups[indexPath.section]
        
        if indexPath.row == 0 {
            self.groups[indexPath.section].isOpened = !self.groups[indexPath.section].isOpened
            
            guard section._numbers.count > 0 else { return }
            collectionView.reloadSections([indexPath.section])
            
        }else {
//            let number = section.list[indexPath.row-1]
            
            let vc = self.getStoryboardView(PhoneBillOperationsViewController.self)
            vc.phoneNumber = section._numbers[indexPath.row - 1]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells)
        return CGSize(width: cellWidth, height: 80)
    }
}

// MARK: - EXPANDABLE CELL DELEGATE

extension PhoneVodafoneViewController: ExpandableCollectionViewCellDelegate {
    
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
            
            let selectedNumbersInSection = self.groups[indexPath.section]._numbers.filter({ $0.isSelected == true })
            if selectedNumbersInSection.count == self.groups[indexPath.section]._numbers.count ||
                selectedNumbersInSection.count == 0 {
                self.groups[indexPath.section].isSelected = isSelected
            }
            break
        }
        
        self.numbersCollectionView.reloadSections([indexPath.section])
        self.phoneHeaderView.setIsItemSelected(self.isSelectedAll())
        self.setIsEnablePaymentButton(self.isSelectedOneOrMore())
        self.calculateSelectedPhones()
    }
}

// MARK: - HEADER VIEW DELEGATE

extension PhoneVodafoneViewController: SelectAllHeaderViewDelegate {
    
    var selectAllHeaderViewDesign: SelectAllHeaderViewDesign {
        get {
            return PhoneSelectAllHeaderViewDesign()
        }
    }
    
    func didTapSelectAllCheckBox(with isSelected: Bool) {
        for i in 0..<self.groups.count {
            self.groups[i].isSelected = isSelected
        }
        
        self.numbersCollectionView.reloadData()
        self.calculateSelectedPhones()
        self.setIsEnablePaymentButton(self.isSelectedOneOrMore())
    }
}

// MARK: - REQUESTS DELEGATE

extension PhoneVodafoneViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getGroupListWithPhoneNumbers ||
            request == .savePaymentRequestViaPhoneBill {
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

extension PhoneVodafoneViewController {
    
    private func groupListRequest() {
        self.dispatchGroup.enter()
        
        self.isColorSetToSections = false
        
        self.requestProxy.requestService()?.getGroupListWithPhoneNumbers(operatorID: 2) { (status, response) in
            guard status == true else { return }
            
            let list = response?._list ?? []
            self.groups = list.filter({ $0._numbers.isNotEmpty })
            
            let count = self.groups.compactMap({ $0._numbers.count })
            self.startPhonesCount = count.reduce(0, +)
//            self.totalBillsLabel.text = "\(response?._grandTotal.formatNumber() ?? "")"
            
            let allTotal = self.groups.reduce(0) { res, group in
                res  + group._total
            }
            
            self.totalBillsLabel.text = "\(allTotal.formatNumber())"
            
            self.setIsEnablePaymentButton(false)
            self.phoneHeaderView.setIsItemSelected(false)
            
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            self.numbersCollectionView.reloadData()
        }
    }
    
    private func isSelectedAll() -> Bool {
        
        let selectedGroups = self.groups.filter({ $0.isSelected == true })
        
         if selectedGroups.count == self.groups.count {
            var selectedCount: Int = 0
            
            for group in selectedGroups {
                let selectedGroups = group._numbers.filter({ $0.isSelected == true })
                if selectedGroups.count == group._numbers.count {
                    selectedCount += selectedGroups.count
                }
            }
            return selectedCount == self.startPhonesCount
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
    
    private func calculateSelectedPhones() {
        
        let selectedSectionWithPhones = self.groups.flatMap({ $0._numbers.filter({ $0.isSelected == true }) })
        self.selectedNumbers = selectedSectionWithPhones
        let selectedPhonesTotal = selectedSectionWithPhones.reduce(0) { (res, phone) -> Double in
            return res + (phone._currentBill)
        }
        self.total = selectedPhonesTotal
        self.setPhonesLabelCount(selectedSectionWithPhones.count)
        self.setPhonesLabelTotal(selectedPhonesTotal)
    }
    
    private func setPhonesLabelCount(_ count: Int) {
        self.phonesSelectedCountLabel.text = "\(count) number(s) selected"
    }
    
    private func setPhonesLabelTotal(_ total: Double) {
        self.phonesSelectedTotalLabel.text = "QAR \(total == 0 ? "0.00" : total.formatNumber())"
    }
    
    private func setIsEnablePaymentButton(_ status: Bool) {
        self.paymentButton.isEnabled = status
        self.paymentViewDesign.backgroundColor = status ? .mPhone_Bill_Red : .systemGray4
    }
}
