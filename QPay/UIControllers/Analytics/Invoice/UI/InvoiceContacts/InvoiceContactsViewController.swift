//
//  InvoiceContactsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceContactsViewController: InvoiceViewController {
    
    @IBOutlet weak var navGradientView: NavGradientView!
    
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    private var contacts = [InvoiceContact]()
    
    private var successResponse: BaseResponse?
    
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

extension InvoiceContactsViewController {
    
    func setupView() {
        self.contactsCollectionView.registerNib(InvoiceContactCollectionViewCell.self)
        self.contactsCollectionView.delegate = self
        self.contactsCollectionView.dataSource = self
        
        self.navGradientView.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        
        let builder = InvoiceEndPoints.contacts
        self.showLoadingView(self)
        
        InvoiceRequestsService.shared.send(builder) { (result: Result<BaseArrayResponse<InvoiceContact>, InvoiceRequestErrors>) in
            switch result {
            case .success(let response):
                guard response._success else {
                    self.hideLoadingView(response._message)
                    return
                }
                self.hideLoadingView()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.contacts = response._list
                    self.contactsCollectionView.reloadData()
                    
                    if let response = self.successResponse {
                        self.showSuccessMessage(response._message)
                        self.successResponse = nil
                    }
                }
                break
                
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}

// MARK: - ACTIONS

extension InvoiceContactsViewController {
    
}

// MARK: - COLLECTION VIEW DELEGATE

extension InvoiceContactsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(InvoiceContactCollectionViewCell.self, for: indexPath)
        
        let object = self.contacts[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.contacts[indexPath.row]
        let vc = self.getStoryboardView(InvoiceContactDetailsViewController.self)
        vc.contact = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        
        let cellWidth = (collectionView.width - leftRightPadding)
        return CGSize(width: cellWidth, height: 60)
    }
}

// MARK: - NAV GRADIENT DELEGATE

extension InvoiceContactsViewController: NavGradientViewDelegate {
    
    /// Search button
    func didTapLeftButton(_ nav: NavGradientView) {
        
    }
    
    /// Add button
    func didTapRightButton(_ nav: NavGradientView) {
        let vc = self.getStoryboardView(InvoiceContactDetailsViewController.self)
        vc.successSaveCallBack = { (response) in
            self.successResponse = response
            self.fetchData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceContactsViewController {
    
}
