//
//  HistoryKahrmaBillViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 23/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class HistoryKahrmaBillViewController: ViewController {

    @IBOutlet weak var tableView         : UITableView!
    
    private var previousBillArray = [PreviousBill]()
    var number : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension HistoryKahrmaBillViewController {
    
    func setupView() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.registerNib(HistoryTableViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        guard let data = self.number else { return }
        
        self.showLoadingView(self)
        self.requestProxy.requestService()?.getPaymentsHistoryKaharma(kaharmaNumber: data, { response in
            self.hideLoadingView()
            guard let resp = response else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            guard resp._success else {
                self.showErrorMessage(resp._message)
                return
            }
            
            self.previousBillArray = resp._list.first?._previousBills ?? []
            self.tableView.reloadData()
        })
    }
}

// MARK: - ACTIONS

extension HistoryKahrmaBillViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - TABLE VIEW DELEGATE

extension HistoryKahrmaBillViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.previousBillArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(HistoryTableViewCell.self, for: indexPath)
        
        let object = self.previousBillArray[indexPath.row]
        cell.object = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let object = self.<#Array#>[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


// MARK: - CUSTOM FUNCTIONS

extension HistoryKahrmaBillViewController {
    
}
