//
//  Advertisment2TableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 07/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class Advertisment2TableViewCell: UITableViewCell {
    
    static let identifier = String(describing: Advertisment2TableViewCell.self)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var advertisements: [HomeScene.Advertisements.Advertisement] = []
    private var isShimmering: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.registerCell(Advertismet2CollectioViewCell.identifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func configureCell(_ data: [HomeScene.Advertisements.Advertisement], _ isShimmering: Bool) {
        self.isShimmering = isShimmering
        self.advertisements = data
        self.collectionView.reloadData()
    }
}

extension Advertisment2TableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isShimmering ? 3 : self.advertisements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Advertismet2CollectioViewCell.identifier, for: indexPath) as! Advertismet2CollectioViewCell
        self.isShimmering ? cell.startAnimation() : cell.updateCell(self.advertisements[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height)
    }
}
