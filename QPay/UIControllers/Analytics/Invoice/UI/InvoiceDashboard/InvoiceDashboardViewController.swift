//
//  InvoiceDashboardViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceDashboardViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
    @IBOutlet weak var statisticsCollectionView: UICollectionView!
    
    @IBOutlet weak var transactionsCollectionView: UICollectionView!
    
    private var statistics = [InvoiceStatistics]()
    private var transactions = [InvoiceApp]()
    
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

extension InvoiceDashboardViewController {
    
    func setupView() {
        self.navGradientView.delegate = self
        
        self.transactionsCollectionView.registerNib(InvoiceAppCollectionViewCell.self)
        self.transactionsCollectionView.delegate = self
        self.transactionsCollectionView.dataSource = self
        
        self.statisticsCollectionView.delegate = self
        self.statisticsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.statistics = InvoiceStatistics.demoData()
        
        let builder = InvoiceEndPoints.invoiceList
        self.showLoadingView(self)
        
        InvoiceRequestsService.shared.send(builder) { (result: Result<BaseArrayResponse<InvoiceApp>, InvoiceRequestErrors>) in
            switch result {
            case .success(let response):
                self.hideLoadingView()
                guard response._success == true else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.showErrorMessage(response._message)
                    }
                    return
                }
                self.transactions = response._list.suffix(10)
                self.transactionsCollectionView.reloadData()
                break
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}

// MARK: - ACTIONS

extension InvoiceDashboardViewController {
    
}

// MARK: - COLLECTION VIEW DELEGATE

extension InvoiceDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.statisticsCollectionView ? self.statistics.count : self.transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.statisticsCollectionView {
            let cell = collectionView.dequeueCell(InvoiceAppStatisticsCollectionViewCell.self, for: indexPath)
            let object = self.statistics[indexPath.row]
            cell.object = object
            return cell
        }
        
        let cell = collectionView.dequeueCell(InvoiceAppCollectionViewCell.self, for: indexPath)
        let object = self.transactions[indexPath.row]
        cell.object = object
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.statisticsCollectionView {
            
        } else {
            let object = self.transactions[indexPath.row]
            let vc = self.getStoryboardView(InvoiceDetailsViewController.self)
            vc.invoiceID = object._id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        if collectionView == self.statisticsCollectionView {
            let cellsInRow: CGFloat = 2
            let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
            
            let cellHeight = (collectionView.height - flowLayout.minimumLineSpacing) / cellsInRow
            let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        let cellWidth = (collectionView.width - leftRightPadding)
        return CGSize(width: cellWidth, height: 100)
    }
}

// MARK: - NAV GRADIENT DELEGATE

extension InvoiceDashboardViewController: NavGradientViewDelegate {
    
    func didTapLeftButton(_ nav: NavGradientView) {
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceDashboardViewController {
    
}
