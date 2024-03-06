//
//  PickUpLocationViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol PickUpLocationViewControllerDelegate: AnyObject {
    func didTapPickupLocationButton(_ location: String)
    func didTapSavePlacesCollectionCell(_ place: KarwaPlace)
}

class PickUpLocationViewController: KarwaTaxiController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var pickupLocationLabel: UILabel!
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    @IBOutlet weak var placesCollectionView: UICollectionView!
    @IBOutlet weak var destinationsTableView: UITableView!

    var places = [KarwaPlace]()
    
    weak var delegate: PickUpLocationViewControllerDelegate?
    
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

extension PickUpLocationViewController {
    
    func setupView() {
        self.placesCollectionView.delegate = self
        self.placesCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.places = [1,2,3,4,5].compactMap({ return KarwaPlace(image: UIImage(systemName: "house.fill")!, name: "Home  \($0)".uppercased(), description: "Home Sweet Home") })
    }
}

// MARK: - ACTIONS

extension PickUpLocationViewController {
    
    @IBAction func pickupLocationAction(_ sender: UIButton) {
        self.delegate?.didTapPickupLocationButton(self.pickupLocationLabel.text!)
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension PickUpLocationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KarwaTaxiSavePlacesCollectionViewCell.identifier, for: indexPath) as! KarwaTaxiSavePlacesCollectionViewCell
        
        let object = self.places[indexPath.row]
        cell.place = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let place = self.places[indexPath.row]
        self.delegate?.didTapSavePlacesCollectionCell(place)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = (collectionView.width-60)/2.5
        return .init(width: viewWidth, height: collectionView.height-20)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension PickUpLocationViewController {
    
}
