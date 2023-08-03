//
//  BeneficiariesViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class BeneficiariesViewController: MainController {

    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var emptyStackView: UIStackView!
    @IBOutlet weak var tableStackView: UIStackView!
    
    @IBOutlet weak var beneficiariesTableView: UITableView!

    var beneficiaries = [Beneficiary]()
    
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
        
        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            if status, let blnc = balance {
                self.balanceLabel.text = blnc.formatNumber()
            }
        }
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getBeneficiaryList( weakify { strong, list in
            self.beneficiaries = list ?? []
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.beneficiariesTableView.reloadData()
            self.isUserHasBeneficiaries(!self.beneficiaries.isEmpty)
        }
    }
}

extension BeneficiariesViewController {
    
    func setupView() {
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.beneficiariesTableView.delegate = self
        self.beneficiariesTableView.dataSource = self
        let footerView = UIView()
        footerView.backgroundColor = .clear
        self.beneficiariesTableView.tableFooterView = footerView
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension BeneficiariesViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewBeneficiariesAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddBeneficiaryViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension BeneficiariesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beneficiaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(BeneficiaryTableViewCell.self, for: indexPath)
        
        let object = self.beneficiaries[indexPath.row]
        cell.beneficiary = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.beneficiaries[indexPath.row]
        
        let vc = self.getStoryboardView(BeneficiaryInformationViewController.self)
        vc.beneficiary = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension BeneficiariesViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getBeneficiaryList {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
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

extension BeneficiariesViewController {
    
    private func isUserHasBeneficiaries(_ status: Bool) {
        self.emptyStackView.isHidden = status
        self.tableStackView.isHidden = !status
    }
}
