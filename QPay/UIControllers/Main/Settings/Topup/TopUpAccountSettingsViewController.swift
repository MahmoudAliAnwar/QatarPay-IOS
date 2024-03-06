//
//  TopUpAccountSettingsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

// api/NoqoodyUser/GetTopupSetting
// api/NoqoodyUser/UpdateTopupSetting

class TopUpAccountSettingsViewController: MainController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var maxPerDayLabel: UILabel!
    @IBOutlet weak var maxPerMonthLabel: UILabel!
    @IBOutlet weak var notLessThanLabel: UILabel!
    
    @IBOutlet weak var topupAccountsTableView: UITableView!
    
    var accounts = [Topup]()

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
        
        self.topupSettingsRequest()
        self.topupCardListRequest()
    }
}

extension TopUpAccountSettingsViewController {
    
    func setupView() {
        self.topupAccountsTableView.delegate = self
        self.topupAccountsTableView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
        guard let user = self.userProfile.getUser() else { return }
        self.usernameLabel.text = "\(user._fullName)"
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension TopUpAccountSettingsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func editBalanceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditBalanceViewController.self)
        vc.updateViewDelegate = self
        self.present(vc, animated: true)
    }

    @IBAction func editSavedAccountsAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditSavedTopupViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func selectAccountAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectTopupAccountViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension TopUpAccountSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(TopupTableViewCell.self, for: indexPath)
        
        let acc = self.accounts[indexPath.row]
        cell.topup = acc
        
        return cell
    }
}

// MARK: - REQUESTS DELEGATE

extension TopUpAccountSettingsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getTopupSettings {
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

// MARK: - UPDATE VIEW DELEGATE

extension TopUpAccountSettingsViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        guard status else { return }
        self.viewWillAppear(true)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension TopUpAccountSettingsViewController {
    
    private func topupSettingsRequest() {
        
        self.requestProxy.requestService()?.getTopupSettings { (status, response) in
            guard status,
                  let resp = response else {
                return
            }
            if let maxDay = resp.maxAmountPerDay {
                let maxDayFormatted = maxDay.formatNumber()
                self.maxPerDayLabel.text = "QAR \(maxDayFormatted)"
            }
            if let maxMonth = resp.maxAmountPerMonth {
                let maxMonthFormatted = maxMonth.formatNumber()
                self.maxPerMonthLabel.text = "QAR \(maxMonthFormatted)"
            }
            if let defaultTopup = resp.defaultTopupAmount {
                let defaultTopupFormatted = defaultTopup.formatNumber()
                self.notLessThanLabel.text = "QAR \(defaultTopupFormatted)"
            }
        }
    }
    
    private func topupCardListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getTopupCardList(completion: { (status, list) in
            guard status else { return }
         
            let cards = list ?? []
            let sortCards = cards.sorted(by: { $1.isDefault == false })
            
            self.accounts = sortCards
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.topupAccountsTableView.reloadData()
        }
    }
}
