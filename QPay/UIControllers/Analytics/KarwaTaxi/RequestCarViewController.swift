//
//  RequestCarViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol RequestCarViewControllerDelegate: AnyObject {
    func didTapPromoButton()
    func didTapCashButton()
    func didTapScheduleButton()
    func didTapRequestKarwaButton()
    func didTapCarCell(with model: KarwaTaxiCar)
}

class RequestCarViewController: KarwaTaxiController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var carsTableView: UITableView!
    
    var cars = [KarwaTaxiCar]()
    weak var delegate: RequestCarViewControllerDelegate?

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

extension RequestCarViewController {
    
    func setupView() {
        self.carsTableView.delegate = self
        self.carsTableView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.cars = [1,2,3,4,5,6,7,8,9,10,11].compactMap({ return KarwaTaxiCar(image: UIImage(named: "ic_car_request_car")!, name: "Taxi \($0)", passengers: $0, amount: $0, time: $0) })
    }
}

// MARK: - ACTIONS

extension RequestCarViewController {
    
    @IBAction func promoAction(_ sender: UIButton) {
        self.delegate?.didTapPromoButton()
    }
    
    @IBAction func cashAction(_ sender: UIButton) {
        self.delegate?.didTapCashButton()
    }
    
    @IBAction func scheduleAction(_ sender: UIButton) {
        self.delegate?.didTapScheduleButton()
    }
    
    @IBAction func requestKarwaAction(_ sender: UIButton) {
        self.delegate?.didTapRequestKarwaButton()
    }
}

// MARK: - TABLE VIEW DELEGATE

extension RequestCarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestCarTableViewCell.identifier, for: indexPath) as! RequestCarTableViewCell
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = .systemGray6
        } else {
            cell.backgroundColor = .clear
        }
        let object = self.cars[indexPath.row]
        cell.car = object
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = cars[indexPath.row]
        self.delegate?.didTapCarCell(with: object)
    }
}
// MARK: - CUSTOM FUNCTIONS

extension RequestCarViewController {
    
}
