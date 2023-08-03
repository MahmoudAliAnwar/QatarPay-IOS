//
//  DropOffLocationViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class DropOffLocationViewController: KarwaTaxiController {

    @IBOutlet weak var currentlocationLabel: UILabel!
    @IBOutlet weak var destinationLocationTextField: UITextField!
    @IBOutlet weak var locationsTableView: UITableView!
    
    @IBOutlet weak var addressesBottomView: UIView!
    @IBOutlet weak var favoritesBottomView: UIView!

    var locations = [KarwaLocation]()
    
    private var tabSelected: Tab = .Addresses {
        didSet {
            self.setViewTab(tabSelected)
        }
    }
    
    private enum Tab: String, CaseIterable {
        case Addresses
        case Favorites
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
        
        self.statusBarView?.backgroundColor = .mKarwa_Dark_Red
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension DropOffLocationViewController {
    
    func setupView() {
        self.locationsTableView.delegate = self
        self.locationsTableView.dataSource = self
        
        self.locationsTableView.tableFooterView = UIView()
        self.tabSelected = .Addresses
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.locations = [1,2,3,4,5,6,7,8,9].compactMap({ return KarwaLocation(name: "Hamad General Hospital \($0)") })
    }
}

// MARK: - ACTIONS

extension DropOffLocationViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func addressesTabAction(_ sender: UIButton) {
        self.tabSelected = .Addresses
    }
    
    @IBAction func favoritesTabAction(_ sender: UIButton) {
        self.tabSelected = .Favorites
    }
}

// MARK: - TABLE VIEW DELEGATE

extension DropOffLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KarwaLocationTableViewCell.identifier, for: indexPath) as! KarwaLocationTableViewCell
        
        let object = self.locations[indexPath.row]
        cell.delegate = self
        cell.location = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object = locations[indexPath.row]
    }
}

// MARK: - LCATION CELL DELEGATE

extension DropOffLocationViewController: KarwaLocationTableViewCellDelegate {
    
    func didTapMenuButton(_ location: KarwaLocation) {
        print("Location menu \(location.name)")
    }
}

// MARK: - CUSTOM FUNCTIONS

extension DropOffLocationViewController {
    
    private func setViewTab(_ tab: Tab) {
        
        self.addressesBottomView.backgroundColor = tab == .Addresses ? .mYellow : .clear
        self.favoritesBottomView.backgroundColor = tab == .Favorites ? .mYellow : .clear
        
        switch tab {
        case .Addresses:
            
            break
        case .Favorites:
            
            break
        }
    }
}
