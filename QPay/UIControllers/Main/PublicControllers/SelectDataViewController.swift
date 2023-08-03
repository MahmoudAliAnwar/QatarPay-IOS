//
//  SelectDataViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 24/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class SelectDataViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var list = [String]()
    var searchList = [String]()
    
    var onSelect: ((String) -> Void)?
    
    private var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    // TODO: fix
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarView?.isHidden = true
        
        if let lastController = self.presentingViewController?.children.last {
            self.dispatchGroup.enter()
            
//            if lastController is AddBankAccountViewController {
//                self.requestProxy.requestService()?.countriesList { (status, list) in
//                    let arr = list ?? []
//                    self.list = arr
//                    
//                    self.dispatchGroup.leave()
//                }
//                
//            }
            
            self.dispatchGroup.notify(queue: .main, execute: {
                self.tableView.reloadData()
            })
        }
    }
}

extension SelectDataViewController {
    
    func setupView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension SelectDataViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - SEARCH BAR DELEGATE

extension SelectDataViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty {
            isSearching = false
            
        }else {
            let sText = searchText.lowercased()
            self.searchList = self.list.filter({ (title) -> Bool in
                return title.lowercased().contains(sText)
            })
            
            isSearching = true
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - TABLE VIEW DELEGATE

extension SelectDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? self.searchList.count : self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SelectDataTableViewCell.self, for: indexPath)
        
        let title: String
        
        if isSearching {
            title = self.searchList[indexPath.row]
        }else {
            title = self.list[indexPath.row]
        }
        
        cell.setupData(title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title: String
        
        if isSearching {
            title = self.searchList[indexPath.row]
        }else {
            title = self.list[indexPath.row]
        }
        
        self.dismiss(animated: true) {
            self.onSelect?(title)
        }
    }
}
