//
//  StocksDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class StocksDetailsViewController: StocksController {

    @IBOutlet weak var containerViewDesign: ViewDesign!

    @IBOutlet weak var stockDetailsTableView: UITableView!

//    var stocksDetailsCells = [StockDetailsCell]()

    var stock: Stock!

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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension StocksDetailsViewController {

    func setupView() {
        self.stockDetailsTableView.delegate = self
        self.stockDetailsTableView.dataSource = self

        self.statusBarView?.isHidden = true

        self.containerViewDesign.cornerRadius = 14
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
    }

    func localized() {
    }

    func setupData() {
    }

    func fetchData() {
    }
}

// MARK: - ACTIONS

extension StocksDetailsViewController {

    @IBAction func backAction(_ sender: UIButton) {

    }

    @IBAction func moreAction(_ sender: UIButton) {

    }

    @IBAction func addStockAction(_ sender: UIButton) {

    }
}

// MARK: - TABLE VIEW DELEGATE

extension StocksDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(StockDetailsTableViewCell.self, for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
// MARK: - CUSTOM FUNCTIONS

extension StocksDetailsViewController {
    
}
