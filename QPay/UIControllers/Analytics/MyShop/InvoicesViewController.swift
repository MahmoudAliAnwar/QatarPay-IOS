//
//  InvoicesViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoicesViewController: ShopController {
    
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    
    @IBOutlet weak var invoicesCollectionView: UICollectionView!
    
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var collectedView: UIView!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var cancelledView: UIView!
    
    var tableOrders = [TableOrder]()
    var tableOrdersAll = [TableOrder]()
    var archiveTableOrders = [TableOrder]()
    var filteredTableOrders = [TableOrder]()
    
    var sections = [Grouping<Date, Transaction>]()
    
    private var tabSelected: TabButton = .All {
        willSet {
            self.setViewOrders(to: newValue)
        }
    }
    
    private let dateFormat = "MMMM yyyy"
    private var isFiltered = false
    private var updateClosure: UpdateClosure?
    
    struct TableOrder: Equatable, Comparable {
        
        var date: Date
        var orders: [Order]
        
        static func < (lhs: TableOrder, rhs: TableOrder) -> Bool {
            return lhs.date < rhs.date
        }
        
        static func groupOrders(_ orders: [Order]) -> [TableOrder] {
            
            let groups = Dictionary(grouping: orders) { (order) -> Date in
                if var dateString = order.orderDate,
                   let tRange = dateString.range(of: "T") {
                    dateString.removeSubrange(tRange.lowerBound..<dateString.endIndex)
                    
                    if let date = dateString.convertFormatStringToDate(ServerDateFormat.DateWithoutTime.rawValue) {
                        var calender = Calendar.current
                        calender.locale = .EN_US_POSIX
                        calender.timeZone = .GMT
                        let comp = calender.dateComponents([.year, .month], from: date)
                        return calender.date(from: comp)!
                    }
                }
                return Date()
            }
            
            return groups.map { (date, orders) -> TableOrder in
                return TableOrder(date: date, orders: orders)
            }.sorted { (left, right) -> Bool in
                left.date > right.date
            }
        }
    }
    
    enum TabButton: String, CaseIterable {
        case All
        case Pending
        case Cash
        case Online
        case Archive
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
        
        self.requestProxy.requestService()?.delegate = self
        
        self.tabSelected = .All
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getOrderList ( weakify { strong, myOrders in
            guard let orders = myOrders else { return }
            
            self.tableOrdersAll.removeAll()
            
            let sortedTableOrders = TableOrder.groupOrders(orders)
            self.tableOrdersAll = sortedTableOrders
            self.tableOrders = sortedTableOrders
            
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.requestProxy.requestService()?.getArchiveOrderList ( self.weakify { strong, list in
                    guard let orders = list else { return }
                    
                    let sortedTableOrders = TableOrder.groupOrders(orders)
                    
                    self.archiveTableOrders = sortedTableOrders
                    self.invoicesCollectionView.reloadData()
                })
            }
        }
    }
}

extension InvoicesViewController {
    
    func setupView() {
        self.invoicesCollectionView.delegate = self
        self.invoicesCollectionView.dataSource = self
        
        self.tabsCollectionView.delegate = self
        self.tabsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InvoicesViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(InvoicesFilterViewController.self)
        vc.filterOrdersDelegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension InvoicesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.tabsCollectionView {
            return 1
        }
        return self.tableOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tabsCollectionView {
            return TabButton.allCases.count
        }
        return self.tableOrders[section].orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tabsCollectionView {
            let cell = collectionView.dequeueCell(InvoiceTabCollectionViewCell.self, for: indexPath)
            
            let cellTab = TabButton.allCases[indexPath.row]
            cell.tab = cellTab
            cell.tabBottomView.backgroundColor = cellTab == self.tabSelected ? .orange : .clear
            
            return cell
        }
        
        let cell = collectionView.dequeueCell(InvoiceCollectionViewCell.self, for: indexPath)
        
        cell.delegate = self
        
        let order = self.tableOrders[indexPath.section].orders[indexPath.row]
        cell.isArchiveOrder = self.tabSelected == .Archive
        cell.order = order
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = self.view.width
        
        if collectionView == self.tabsCollectionView {
            let count: CGFloat = CGFloat(TabButton.allCases.count)
            var collectionWidth = viewWidth/count
            collectionWidth = viewWidth+(collectionWidth/2)
            return .init(width: collectionWidth/count, height: collectionView.height)
        }
        return .init(width: viewWidth, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueHeader(InvoicesSectionHeaderReusableView.self, for: indexPath)
        
        let headerDate = self.tableOrders[indexPath.section].date
        headerView.date = headerDate.formatDate("MMMM yyyy")
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.tabsCollectionView {
            self.tabSelected = TabButton.allCases[indexPath.row]
            collectionView.reloadData()
            
        } else {
            let order = self.tableOrders[indexPath.section].orders[indexPath.row]
            
            let vc = self.getStoryboardView(PreviewOrderViewController.self)
            vc.order = order
            vc.isArchiveOrder = self.tabSelected == .Archive
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - INVOICE CELL DELEGATE

extension InvoicesViewController: InvoiceCollectionViewCellDelegate {
    
    func didTapArchive(order: Order) {
        
        showConfirmation(message: "You want to archive this order") {
            self.requestProxy.requestService()?.archiveOrder(order._id, shopID: order._shopID, ( self.weakify { strong, response in
                guard response?.success == true else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.updateClosure = (true, response?.message ?? "Order archived successfully")
                    self.viewWillAppear(true)
                }
            }))
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension InvoicesViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getOrderList ||
            request == .getArchiveOrderList ||
            request == .archiveOrder {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                guard request == .getArchiveOrderList,
                      let closure = self.updateClosure else {
                    return
                }
                
                if closure.isSuccess {
                    self.showSuccessMessage(closure.message)
                    self.updateClosure = nil
                }
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
                        self.showSnackMessage(err.localizedDescription, messageStatus: .Error)
                    }
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - FILTER ORDERS DELEGATE

extension InvoicesViewController: FilterOrdersDelegate {
    
    func filterOrdersCallBack(with orders: [Order]) {
        
        self.isFiltered = true
        let sortedTableOrders = TableOrder.groupOrders(orders)
        self.filteredTableOrders = sortedTableOrders
        self.setViewOrders(to: self.tabSelected)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension InvoicesViewController {
    
    private func setViewOrders(to btn: TabButton) {
        
        UIView.animate(withDuration: 0.3) {
            
            var myTableOrders: [TableOrder]
            
            if btn == .Archive {
                myTableOrders = self.archiveTableOrders
            } else {
                myTableOrders = self.isFiltered ? self.filteredTableOrders : self.tableOrdersAll
            }
            
            switch btn {
            case .All:
                self.tableOrders = myTableOrders
                
            case .Pending:
                self.tableOrders = self.getTableOrdersBy(myTableOrders, status: .Pending)
                
            case .Cash:
                self.tableOrders = self.getTableOrdersBy(myTableOrders, status: .Cash)
                
            case .Online:
                self.tableOrders = self.getTableOrdersBy(myTableOrders, status: .Online)
                
            case .Archive:
                self.tableOrders = myTableOrders
            }
            
            self.invoicesCollectionView.reloadData()
            self.tabsCollectionView.reloadData()
        }
    }
    
    private func getTableOrdersBy(_ array: [TableOrder], status: InvoicePaidStatus) -> [TableOrder] {
        
        var sortedTableOrders = [TableOrder]()
        
        for table in array {
            var sortedOrders = [Order]()
            
            if status == .Pending {
                sortedOrders = table.orders.filter({ $0.paymentStatusID == status.rawValue ||
                                                    $0.paymentStatusID == InvoicePaidStatus.Failed.rawValue })
            }else {
                sortedOrders = table.orders.filter({ $0.paymentStatusID == status.rawValue })
            }
            
            sortedTableOrders.append(.init(date: table.date, orders: sortedOrders))
        }
        sortedTableOrders.removeAll(where: { $0.orders.isEmpty })
        return sortedTableOrders
    }
}

// MARK: - INVOICE TAB CELL CLASS

final class InvoiceTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var tabBottomView: UIView!
    
    var tab: InvoicesViewController.TabButton! {
        willSet {
            self.tabLabel.text = newValue.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
