//
//  MyListViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension MyListViewController {
    func setupView() {
        //        self.tableView.delegate   = self
        //        self.tableView.dataSource = self
        self.tableView.registerNib(RequestCarTableViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}


// MARK: - Action

extension MyListViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addJobAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditAddMyJobtViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
