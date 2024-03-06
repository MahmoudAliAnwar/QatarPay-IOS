//
//  InvoiceHomeViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceHomeViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    
    @IBOutlet weak var invoicesCollectionView: UICollectionView!
    
    private var invoices = [InvoiceApp]()
    private var invoicesAll = [InvoiceApp]()
    private var tabModels = [TabModel]()
    
    struct TabModel {
        let tab: Tabs
        var isSelected: Bool = false
    }
    
    enum Tabs: String, CaseIterable {
        case All
        case Paid
        case Outstanding
        case Overdue
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return control
    }()
    
    private var tabSelectedIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        willSet {
            self.tabModels[newValue.row].isSelected = false
            self.tabsCollectionView.reloadData()
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
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension InvoiceHomeViewController {
    
    func setupView() {
        self.navGradientView.delegate = self
        
        self.tabsCollectionView.delegate = self
        self.tabsCollectionView.dataSource = self
        
        self.invoicesCollectionView.registerNib(InvoiceAppCollectionViewCell.self)
        self.invoicesCollectionView.delegate = self
        self.invoicesCollectionView.dataSource = self
        
        self.invoicesCollectionView.addSubview(self.refreshControl)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.tabModels = Tabs.allCases.compactMap({ return TabModel(tab: $0) })
        self.tabModels[0].isSelected = true
        
        self.sendInvoicesRequest()
    }
}

// MARK: - ACTIONS

extension InvoiceHomeViewController {
    
}

// MARK: - COLLECTION VIEW DELEGATE

extension InvoiceHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.tabsCollectionView ? self.tabModels.count : self.invoices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tabsCollectionView {
            let cell = collectionView.dequeueCell(InvoiceAppTabCollectionViewCell.self, for: indexPath)
            cell.isTabSelected = self.tabSelectedIndexPath == indexPath
            let object = self.tabModels[indexPath.row]
            cell.object = object
            return cell
        }
        
        let cell = collectionView.dequeueCell(InvoiceAppCollectionViewCell.self, for: indexPath)
        
        let object = self.invoices[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.tabsCollectionView {
            self.tabSelectedIndexPath = indexPath
            let object = self.tabModels[indexPath.row]
            self.setViewTab(to: object.tab)
            
        } else {
            let object = self.invoices[indexPath.row]
            let vc = self.getStoryboardView(InvoiceDetailsViewController.self)
            vc.invoiceID = object._id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        if collectionView == self.tabsCollectionView {
            let cellsInRow: CGFloat = 4
            let spaceBetweenCells: CGFloat = flowLayout.minimumLineSpacing * cellsInRow
            
            let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
            return CGSize(width: cellWidth, height: collectionView.height)
        }
        
        let cellWidth = (collectionView.width - leftRightPadding)
        return CGSize(width: cellWidth, height: 100)
    }
}

// MARK: - NAV GRADIENT DELEGATE

extension InvoiceHomeViewController: NavGradientViewDelegate {
    
    /// Search button
    func didTapLeftButton(_ nav: NavGradientView) {
    }
    
    /// Add button
    func didTapRightButton(_ nav: NavGradientView) {
        let vc = self.getStoryboardView(InvoiceTypeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceHomeViewController {
    
    private func setViewTab(to tab: Tabs) {
        switch tab {
        case .All:
            self.invoices = self.invoicesAll
            break
            
        case .Outstanding:
            self.invoices = self.invoicesAll.filter({ $0._statusObject == .pending })
            break
            
        case .Overdue:
            self.invoices = self.invoicesAll.filter({ invoice in
                guard let date = invoice._date.formatToDate(.Server2) else { return false }
                return invoice._statusObject == .pending && !date.isBeforeToday
            })
            break
            
        case .Paid:
            self.invoices = self.invoicesAll.filter({ $0._statusObject == .success })
            break
        }
        self.invoicesCollectionView.reloadData()
    }
    
    @objc
    private func onRefresh(_ refreshControl: UIRefreshControl) {
        self.sendInvoicesRequest()
    }
    
    private func sendInvoicesRequest() {
        
        self.showLoadingView(self)
        
        let builder = InvoiceEndPoints.invoiceList
        
        InvoiceRequestsService.shared.send(builder) { (result: Result<BaseArrayResponse<InvoiceApp>, InvoiceRequestErrors>) in
            switch result {
            case .success(let response):
                self.refreshControl.endRefreshing()
                self.hideLoadingView()
                guard response._success == true else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.showErrorMessage(response._message)
                    }
                    return
                }
                self.invoices = response._list
                self.invoicesAll = response._list
                self.invoicesCollectionView.reloadData()
                break
            case .failure(let error):
                self.refreshControl.endRefreshing()
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}
