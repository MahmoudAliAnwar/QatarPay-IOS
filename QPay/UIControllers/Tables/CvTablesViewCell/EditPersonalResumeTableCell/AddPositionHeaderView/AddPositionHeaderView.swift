//
//  AddPositionHeaderView.swift
//  QPay
//
//  Created by Mohammed Hamad on 14/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol AddPositionHeaderViewDelegate : AnyObject {
    func didTapAddPosition(_ view: AddPositionHeaderView)
}

protocol AddPositionHeaderViewConfig {
    var icon: UIImage { get }
    var title: String { get }
    var isTitleStackHidden: Bool { get }
}

extension AddPositionHeaderViewConfig {
    
    var icon: UIImage {
        get { return .ic_avatar }
    }
    
    var title: String {
        get { return "" }
    }
    
    var isTitleStackHidden: Bool {
        get { return false }
    }
}

class AddPositionHeaderView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleStackView: UIStackView!
    
    var delegate : AddPositionHeaderViewDelegate?
    
    var config : AddPositionHeaderViewConfig? {
        willSet {
            guard let conf = newValue else { return }
            self.iconImageView.image = conf.icon
            self.titleLabel.text = conf.title
            self.titleStackView.isHidden = conf.isTitleStackHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    private func setupView() {
        guard let view = self.loadViewFromNib() else { return }
        self.addSubview(view)
        view.frame = self.bounds
        view.backgroundColor = .white
    }
}

extension AddPositionHeaderView {
    
    @IBAction func addPosition(_ sender : UIButton){
        self.delegate?.didTapAddPosition(self)
    }
}

extension AddPositionHeaderView {
    
}
