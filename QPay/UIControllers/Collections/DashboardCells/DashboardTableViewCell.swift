//
//  DashboardTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/13/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol DashboardTableViewCellDelegate: AnyObject {
    func didTapService(with service: Service, for cellRow: Int, parentRow: Int)
}

class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var leftView: UIView!
  
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    var services = [Service]()
    var cellIndexPath: IndexPath?
    weak var delegate: DashboardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.servicesCollectionView.delegate = self
        self.servicesCollectionView.dataSource = self
        
        self.servicesCollectionView.registerNib(ServiceCollectionViewCell.self)
        
        self.titleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setupData(_ serviceCategory: ServiceCategory, backgroundImage: String, leftViewColor: UIColor, title: String) {
        
        self.titleLabel.text = title
        self.backgroundImageView.image = UIImage(named: backgroundImage)
        self.leftView.backgroundColor = leftViewColor
        
        if let services = serviceCategory.services {
            self.services = services
//            print("\(self.services)")
        }
        self.servicesCollectionView.reloadData()
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension DashboardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ServiceCollectionViewCell.self, for: indexPath)
        
        let service = self.services[indexPath.row]
        cell.setupData(service)
        
        cell.serviceCounterViewDesign.isHidden = self.cellIndexPath!.row > 0
        
        if self.cellIndexPath!.row == 0 , let count = service.count {
             cell.serviceCounterLabel.text = "\(count)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionSize = collectionView.height
        return CGSize(width: (collectionSize * 1.3), height: collectionSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parentIndex = self.cellIndexPath else { return }
        self.delegate?.didTapService(with: self.services[indexPath.row], for: indexPath.row, parentRow: parentIndex.row)
    }
}
