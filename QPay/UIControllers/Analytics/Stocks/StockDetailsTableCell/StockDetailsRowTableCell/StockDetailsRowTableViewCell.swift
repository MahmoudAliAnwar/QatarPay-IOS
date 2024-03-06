//
//  StockDetailsRowTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class StockDetailsRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valuesCollectionView: UICollectionView!
    
    var model: StockDetailsTableViewCell.Model! {
        willSet {
            self.titleLabel.text = newValue.title
        }
        didSet {
            self.valuesCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        self.valuesCollectionView.delegate = self
        self.valuesCollectionView.dataSource = self
    }
}

// MARK: - COLLECTION VIEW DELEGATE

extension StockDetailsRowTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(StockDetailsRowValueCollectionViewCell.self, for: indexPath)
        
        let object = self.model.values[indexPath.row]
        cell.value = object.value
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let object = self.model[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsInRow: CGFloat = CGFloat(StockDetailsTableViewCell.ValueTypes.allCases.count)
        let flowLayout: UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightPadding: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing * cellsInRow
        
        let cellWidth = (collectionView.width - leftRightPadding - spaceBetweenCells) / cellsInRow
        return CGSize(width: cellWidth, height: 30)
    }
}

