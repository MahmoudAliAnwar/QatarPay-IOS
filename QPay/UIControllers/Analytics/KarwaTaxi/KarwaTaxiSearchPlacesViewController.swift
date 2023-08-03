//
//  KarwaTaxiSearchPlacesViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class KarwaTaxiSearchPlacesViewController: KarwaTaxiController {

    @IBOutlet weak var searchBar: UISearchBar!

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

extension KarwaTaxiSearchPlacesViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension KarwaTaxiSearchPlacesViewController {
    
    @IBAction func Action(_ sender: UIButton) {
    }
}

// MARK: - CUSTOM FUNCTIONS

extension KarwaTaxiSearchPlacesViewController {
    
}
