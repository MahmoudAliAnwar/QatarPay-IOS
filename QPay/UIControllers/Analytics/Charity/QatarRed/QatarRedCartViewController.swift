//
//  QatarRedCartViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class QatarRedCartViewController: CharityController {

    @IBOutlet weak var cartItemsCollectionView: UICollectionView!
    @IBOutlet weak var charityHeaderView: SelectAllHeaderView!
    @IBOutlet weak var bottomViewDesign: ViewDesign!
    
    var items = [CharityDetails]()
    
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
        
        self.changeStatusBarBG(color: self.selectAllHeaderViewDesign.viewColor)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension QatarRedCartViewController {
    
    func setupView() {
        self.cartItemsCollectionView.delegate = self
        self.cartItemsCollectionView.dataSource = self
        self.cartItemsCollectionView.registerNib(CharityCartDetailsCollectionViewCell.self)
        self.bottomViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.charityHeaderView.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.items = [
            .init(image: .ic_maroon_card_home, title: "Quran Centers 01", desc: "General Donation  |  Quran Centers", amount: 123, isSelected: false),
            .init(image: .ic_blue_card_home, title: "Quran Centers 02", desc: "General Donation  |  Quran Centers", amount: 321, isSelected: true),
            .init(image: .ic_blue_card_home, title: "Quran Centers 03", desc: "General Donation  |  Quran Centers", amount: 123, isSelected: true),
            .init(image: .ic_blue_card_home, title: "Quran Centers 04", desc: "General Donation  |  Quran Centers", amount: 321, isSelected: true),
            .init(image: .ic_blue_card_home, title: "Quran Centers 05", desc: "General Donation  |  Quran Centers", amount: 123, isSelected: true),
            .init(image: .ic_blue_card_home, title: "Quran Centers 06", desc: "General Donation  |  Quran Centers", amount: 321, isSelected: true),
            .init(image: .ic_blue_card_home, title: "Quran Centers 07", desc: "General Donation  |  Quran Centers", amount: 123, isSelected: true)
        ]
    }
}

// MARK: - ACTIONS

extension QatarRedCartViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
    }
    
    @IBAction func donateAction(_ sender: UIButton) {
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension QatarRedCartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(CharityCartDetailsCollectionViewCell.self, for: indexPath)
        
        let object = self.items[indexPath.row]
        cell.delegate = self
        cell.item = object
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: collectionView.width, height: 90)
    }
}

// MARK: - CHARITY CELL DELEGATE

extension QatarRedCartViewController: CharityCartDetailsCollectionViewCellDelegate {
    
    var cellColor: UIColor {
        get {
            return self.selectAllHeaderViewDesign.viewColor
        }
    }
    
    func didTapSelect(with model: CharityDetails, isSelected: Bool) {
    }
}

// MARK: - CHARITY HEADER DELEGATE

extension QatarRedCartViewController: SelectAllHeaderViewDelegate {
    
    var selectAllHeaderViewDesign: SelectAllHeaderViewDesign {
        get {
            return QatarRedSelectAllHeaderViewDesign()
        }
    }
    
    func didTapSelectAllCheckBox(with isSelected: Bool) {
        for i in 0..<self.items.count {
            self.items[i].isSelected = isSelected
        }
        self.cartItemsCollectionView.reloadData()
    }
    
    func didTapDeleteButton() {
    }
}

// MARK: - CUSTOM FUNCTIONS

extension QatarRedCartViewController {
    
}

class QatarRedSelectAllHeaderViewDesign: SelectAllHeaderViewDesign {
    
    var viewColor: UIColor {
        get {
            return .mCart_Qatar_Crescent_Red
        }
    }
    
    var isHideDeleteButton: Bool {
        get {
            return false
        }
    }
}
