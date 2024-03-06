//
//  CustomProgressView.swift
//  ZakariaApp01
//
//  Created by Dev. Mohmd on 11/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class CustomLoadingView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.40)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.activityIndicator)
        
        return view
    }()
    
    private var view: UIView
    
    private static var object: CustomLoadingView?
    
    private init(_ view: UIView) {
        self.view = view
    }
    
    public static func getInstance(_ view: UIView) -> CustomLoadingView {
        
        if object == nil {
            object = CustomLoadingView(view)
        }
        return object!
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
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.activityIndicator.widthAnchor.constraint(equalTo: self.activityIndicator.heightAnchor,
                                                          multiplier: 1, constant: 60)
        ])
    }
    
    public func hide() {
        self.activityIndicator.stopAnimating()
        self.containerView.removeFromSuperview()
    }
}
