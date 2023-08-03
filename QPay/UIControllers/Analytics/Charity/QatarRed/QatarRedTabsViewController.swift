//
//  QatarRedTabsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class QatarRedTabsViewController: CharityController {

    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var donationsCollectionView: UICollectionView!
    
    private var tabs = [Tab]()

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
        
        self.changeStatusBarBG(color: .mCart_Qatar_Crescent_Red)
    }
}

extension QatarRedTabsViewController {
    
    func setupView() {
        self.tabsCollectionView.delegate = self
        self.tabsCollectionView.dataSource = self

        self.donationsCollectionView.delegate = self
        self.donationsCollectionView.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.tabs = [
            Tab(image: #imageLiteral(resourceName: "ic_shelter_yellow_qatar_tabs"), label: "Shelter", isSelected: true, completion: {
//                print("Shelter")
            }),
            Tab(image: #imageLiteral(resourceName: "ic_water_yellow_qatar_tabs"), label: "Water", isSelected: false, completion: {
//                print("Water")
            }),
            Tab(image: #imageLiteral(resourceName: "ic_health_yellow_qatar_tabs"), label: "Health", isSelected: false, completion: {
//                print("Health")
            }),
            Tab(image: #imageLiteral(resourceName: "ic_food_yellow_qatar_tabs"), label: "Food", isSelected: false, completion: {
//                print("Food")
            }),
            Tab(image: #imageLiteral(resourceName: "ic_local_yellow_qatar_tabs"), label: "Local Development", isSelected: false, completion: {
//                print("Local")
            })
        ]
        
        self.setViewTitleLabel(self.tabs[0].label)
    }
}

// MARK: - ACTIONS

extension QatarRedTabsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
        
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension QatarRedTabsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tabsCollectionView {
            return self.tabs.count
            
        } else {
            return self.donations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.tabsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.identifier, for: indexPath) as! TabCollectionViewCell
            
            cell.tab = self.tabs[indexPath.row]
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QatarRedDonationCollectionViewCell.identifier, for: indexPath) as! QatarRedDonationCollectionViewCell
            
            let object = self.donations[indexPath.row]
            cell.delegate = self
            cell.donation = object
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = self.view.width
        
        if collectionView == self.tabsCollectionView {
            return .init(width: (viewWidth/5), height: 70)
        }
        return .init(width: viewWidth, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.tabsCollectionView {
            let object = self.tabs[indexPath.row]
            self.setViewTitleLabel(object.label)
            
            for i in 0..<tabs.count {
                tabs[i].isSelected = i == indexPath.row
            }
            
            object.completion()
            collectionView.reloadData()
            
        } else {
            
        }
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension QatarRedTabsViewController: QatarRedDonationCollectionViewCellDelegate {
    
    func didTapDonationButton(with model: CharityDonation) {
        print("\(model._name)")
    }
}

// MARK: - CUSTOM FUNCTIONS

extension QatarRedTabsViewController {
    
    private func setViewTitleLabel(_ title: String) {
        self.titleLabel.text = title
    }
}

fileprivate struct Tab {
    let image: UIImage
    let label: String
    var isSelected: Bool
    let completion: voidCompletion
}

class TabCollectionViewCell: UICollectionViewCell {
    static let identifier = "TabCollectionViewCell"
    
    @IBOutlet weak var tabImageView: ImageViewDesign!
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var tabSelectedView: UIView!
    
    fileprivate var tab: Tab! {
        didSet {
            self.tabImageView.image = tab.image
            self.tabLabel.text = tab.label
            self.tabSelectedView.backgroundColor = tab.isSelected ? .mYellow : .clear
            self.tabLabel.textColor = tab.isSelected ? .mYellow : .white
            self.tabImageView.imageTintColor = tab.isSelected ? .mYellow : .white
        }
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
