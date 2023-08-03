//
//  UIImageView+Extensions.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Kingfisher

extension UIImageView {
    
    func setImageWith(urlString: String?, placeHolder: UIImage? = nil) {
        
        guard let urlString = urlString, let imageURL = URL(string: urlString) else {
            self.image = placeHolder
            return
        }
        
        self.kf.setImage(with: imageURL,
                         placeholder: placeHolder,
                         options: [.cacheOriginalImage, .transition(.fade(0.2))])
    }
}
