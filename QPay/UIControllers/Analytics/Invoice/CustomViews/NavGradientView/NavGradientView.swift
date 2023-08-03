//
//  NavGradientView.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

@objc
protocol NavGradientViewDelegate: AnyObject {
    func didTapLeftButton(_ nav: NavGradientView)
    @objc optional func didTapRightButton(_ nav: NavGradientView)
}

class NavGradientView: UIView {
    
    @IBOutlet weak private var containerGradientView: GradientView!
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak private var leftButton: UIButton!
    
    @IBOutlet weak private var rightButton: UIButton!
    
    weak var delegate: NavGradientViewDelegate?
    
    @IBInspectable
    var title: String? {
        get { return self.titleLabel.text ?? "" }
        set { return self.titleLabel.text = newValue }
    }
    
    @IBInspectable
    var leftImage: UIImage? {
        get { return self.leftButton.image(for: .normal) }
        set { return self.leftButton.setImage(newValue, for: .normal) }
    }
    
    @IBInspectable
    var rightImage: UIImage? {
        get { return self.rightButton.image(for: .normal) }
        set { return self.rightButton.setImage(newValue, for: .normal) }
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
    }
}

// MARK: - CUSTOM FUNCTIONS

extension NavGradientView {
    
    @IBAction func leftAction(_ sender: UIButton) {
        self.delegate?.didTapLeftButton(self)
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        self.delegate?.didTapRightButton?(self)
    }
    
    public func goBack() {
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
}

