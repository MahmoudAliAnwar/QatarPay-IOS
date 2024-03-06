//
//  ResultsCVSearchViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 11/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class ResultsCVSearchViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultsSearchCV = [CV]()
    
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

extension ResultsCVSearchViewController {
    
    func setupView() {
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(SearchCvTableViewCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

extension ResultsCVSearchViewController {
    
    @IBAction func backAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension ResultsCVSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsSearchCV.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SearchCvTableViewCell.self, for: indexPath)
        let object = self.resultsSearchCV[indexPath.row]
        cell.object = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.resultsSearchCV[indexPath.row]
        let vc = self.getStoryboardView(ShowCVDetailsViewController.self)
        vc.status = .searchCV
        vc.cv = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
