//
//  ImageFSPagerCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView

final class ImageFSPagerCell: FSPagerViewCell {
    static let identifier = String(describing: ImageFSPagerCell.self)
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: ImageViewDesign!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
