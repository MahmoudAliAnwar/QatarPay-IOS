//
//  CustomProgressView.swift
//  ZakariaApp01
//
//  Created by Dev. Mohmd on 11/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class CustomUploadView {
    
    private lazy var progressView: CustomProgress = {
        let progress = CustomProgress()
        
        progress.backgroundColor = .white
        progress.tintColor = .mDark_Red
        progress.progress = 0.0
        
        return progress
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [progressView, label])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.40)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerStack)
        
        return view
    }()
    
    private var view: UIView
    
    public var progressValue: Float = 0 {
        didSet {
            self.progressView.progress = progressValue
            self.label.text = "\(String.init(format: "%.1f", progressValue * 100)) %"
        }
    }
    
    init(_ view: UIView) {
        self.view = view
    }
    
    public func show() {
        
        self.view.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.containerStack.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.containerStack.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.containerStack.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.8)
        ])
        
        NSLayoutConstraint.activate([
            self.progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    public func hide() {
        self.containerView.removeFromSuperview()
    }
}
