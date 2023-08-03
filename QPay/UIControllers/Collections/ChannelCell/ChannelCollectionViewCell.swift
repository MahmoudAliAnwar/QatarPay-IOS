//
//  ChannelCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/07/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

final class ChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var channelImageView: UIImageView!
    
    var channel: Channel! {
        willSet {
            newValue._imageLocation.getImageFromURLString { status, image in
                guard status else { return }
                self.channelImageView.image = image
            }
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
