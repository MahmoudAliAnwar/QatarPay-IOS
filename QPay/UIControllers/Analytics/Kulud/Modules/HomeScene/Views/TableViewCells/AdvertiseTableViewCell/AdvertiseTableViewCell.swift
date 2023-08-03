//
//  AdvertiseTableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class AdvertiseTableViewCell: UITableViewCell {

    static let identifier = String(describing: AdvertiseTableViewCell.self)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var advertisements: [HomeScene.Advertisements.Advertisement] = []
    private var isShimmering: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.registerCell(AnnouncementCollectionViewCell.identifier)
    }
    
    func configureCell(_ data: [HomeScene.Advertisements.Advertisement], _ isShimmering: Bool) {
        self.isShimmering = isShimmering
        self.advertisements = data
        self.pageControl.numberOfPages = self.advertisements.count
        self.collectionView.reloadData()
    }
}

extension AdvertiseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isShimmering ? 3 : self.advertisements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouncementCollectionViewCell.identifier, for: indexPath) as! AnnouncementCollectionViewCell
        self.isShimmering ? cell.startAnimation() : cell.updateCell(self.advertisements[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension AdvertiseTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        self.pageControl.currentPage = page
    }
}
