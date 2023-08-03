//
//  TransactionsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class TransactionsViewController: MainController {
    
    @IBOutlet weak var transactionsTable: UITableView!

    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var inView: UIView!
    @IBOutlet weak var outView: UIView!
    
    private var tableTransactionsAll = [TableTransaction]()
    private var tableTransactions = [TableTransaction]()
    private var sections = [Grouping<Date, Transaction>]()
    
    private let tableHeaderHeight: CGFloat = 40
    
    struct TableTransaction: Equatable, Comparable {
        var date: Date
        var transactions: [Transaction]

        static func < (lhs: TableTransaction, rhs: TableTransaction) -> Bool {
            return lhs.date < rhs.date
        }
        
        static func groupTransactions(_ transactions: [Transaction]) -> [TableTransaction] {
            
            let groups = Dictionary(grouping: transactions) { (transaction) -> Date in
                if let dateString = transaction.date {
                    if let date = dateString.server1StringToDate() {
                        var calender = Calendar.current
                        calender.locale = .EN_US_POSIX
                        calender.timeZone = .GMT
                        let comp = calender.dateComponents([.year, .month], from: date)
                        return calender.date(from: comp)!
                    }
                }
                return Date()
            }
            return groups.map { (date, trans) -> TableTransaction in
                return TableTransaction(date: date, transactions: trans)
            }.sorted { (left, right) -> Bool in
                return left.date > right.date
            }
        }
    }
    
    private enum TabButton {
        case All
        case In
        case Out
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.transactionsList ( weakify { strong, list in
            let transactions = list ?? []
            
            strong.tableTransactionsAll = TableTransaction.groupTransactions(transactions)
            strong.tableTransactions = strong.tableTransactionsAll
            strong.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.transactionsTable.reloadData()
        }
    }
}

extension TransactionsViewController {
    
    func setupView() {
        self.transactionsTable.delegate = self
        self.transactionsTable.dataSource = self
        self.transactionsTable.tableFooterView = nil
        
        self.transactionsTable.registerNib(TransactionTableViewCell.self)
        
        setTabButton()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension TransactionsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allAction(_ sender: UIButton) {
        setTabButton()
    }
    
    @IBAction func inAction(_ sender: UIButton) {
        setTabButton(tab: .In)
    }
    
    @IBAction func outAction(_ sender: UIButton) {
        setTabButton(tab: .Out)
    }
}

// MARK: - TABLE DELEGATE

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableTransactions[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(TransactionTableViewCell.self, for: indexPath)
        
        let trans = self.tableTransactions[indexPath.section].transactions[indexPath.row]
        cell.parent = self
        cell.setupData(transaction: trans)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: self.tableHeaderHeight))
        headerView.backgroundColor = self.view.backgroundColor

        let label = UILabel()
        label.frame = CGRect(x: 15, y: 5, width: (headerView.width - 30), height: (headerView.height - 10))
        label.text = self.tableTransactions[section].date.formatDate("MMMM yyyy")
        label.font = .sfDisplay(12)?.regular
        label.textColor = .darkGray

        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trans = self.tableTransactions[indexPath.section].transactions[indexPath.row]
        
        let vc = self.getStoryboardView(TransactionDetailsViewController.self)
        vc.transaction = trans
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - TRANSACTION DETAILS DELEGATE

extension TransactionsViewController: TransactionDetailsViewControllerDelegate {
    
    func didTapAddBenefeciary(_ view: TransactionDetailsViewController, with transaction: Transaction) {
        guard let qpan = transaction.QPAN else { return }
        let vc = self.getStoryboardView(AddBeneficiaryViewController.self)
        vc.qpan = qpan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension TransactionsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .transactionsList {
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

extension TransactionsViewController {

    private func setTabButton(tab: TabButton = .All) {
        
        UIView.animate(withDuration: 0.3) {
            switch tab {
            case .All:
                self.allView.backgroundColor = .orange
                self.inView.backgroundColor = .clear
                self.outView.backgroundColor = .clear
                
                self.tableTransactions = self.tableTransactionsAll
                
            case .In:
                self.allView.backgroundColor = .clear
                self.inView.backgroundColor = .orange
                self.outView.backgroundColor = .clear
                
                self.tableTransactions = self.getTransactionBy(tab: tab)
                
            case .Out:
                self.allView.backgroundColor = .clear
                self.inView.backgroundColor = .clear
                self.outView.backgroundColor = .orange
                
                self.tableTransactions = self.getTransactionBy(tab: tab)
            }
            
//            self.transactionsTable.reloadSections(IndexSet(self.tableTransactions.indices), with: .automatic)
            self.transactionsTable.reloadData()
        }
    }
    
    private func getTransactionBy(tab: TabButton) -> [TableTransaction] {
        
        var sortedTableTransactions = [TableTransaction]()
        
        for table in self.tableTransactionsAll {
            
            var sortedTransactions = [Transaction]()
            
            switch tab {
            case .All:
                break
            case .In:
                sortedTransactions = table.transactions.filter({ $0.typeID != 7 && (!(41...61).contains($0._typeID) || $0.typeID == 55) })
            case .Out:
                sortedTransactions = table.transactions.filter({ $0.typeID == 7 || ((41...61).contains($0._typeID) && $0.typeID != 55) })
            }
            sortedTableTransactions.append(TableTransaction(date: table.date, transactions: sortedTransactions))
        }
        
        sortedTableTransactions.removeAll(where: { $0.transactions.isEmpty })
        return sortedTableTransactions
    }
}
