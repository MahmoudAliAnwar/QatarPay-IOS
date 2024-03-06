//
//  HomeBarPagerCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/08/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView

protocol HomeBarPagerCellDelegate: AnyObject {
}

class HomeBarCarouselView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    weak var delegate: HomeBarPagerCellDelegate?
    
    var model: HomeViewController.CarouselActionModel! {
        willSet {
            self.iconImageView.image = newValue.action.icon
            self.titleLabel.text = newValue.action.rawValue
        }
    }
    
    var cellPosition: CellPosition = .center {
        willSet {
            self.configureArrows(by: newValue)
        }
    }
    
    enum CellPosition {
        case center
        case left
        case right
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func customInit() {
        guard let view = self.loadViewFromNib() else { return }
        
        self.addSubview(view)
        view.frame = self.bounds
        
        self.leftImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension HomeBarCarouselView {
    
    private func configureArrows(by position: CellPosition) {
        self.leftImageView.isHidden = position == .right
        self.rightImageView.isHidden = position == .left
    }
}
