//
//  CustomPageControl.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class CustomPageControl: UIControl {
    
    //MARK:- Properties
    
    private var numberOfDots = [CustomPageControlView]() {
        didSet{
            if numberOfDots.count == numberOfPages {
                setupViews()
            }
        }
    }
    
    @IBInspectable var pageIndicatorTintColor: UIColor = .lightGray
    @IBInspectable var currentPageIndicatorTintColor: UIColor = .darkGray
    
    @IBInspectable var numberOfPages: Int = 0 {
        didSet{
            for tag in 0 ..< numberOfPages {
                let dot = getDotView()
                dot.tag = tag
                self.numberOfDots.append(dot)
            }
        }
    }
    
    var currentPage: Int! {
        didSet{
            self.onChangeCurrentPage()
        }
    }
    
    private lazy var stackView = UIStackView(frame: self.bounds)
    
//    override var bounds: CGRect {
//        didSet{
//            self.numberOfDots.forEach { (dot) in
//                self.setupDotAppearance(dot: dot)
//            }
//        }
//    }
    
    //MARK:- Intialisers
    convenience init() {
        self.init(frame: .zero)
    }
    
    init(withNoOfPages pages: Int) {
        self.numberOfPages = pages
        self.currentPage = 0
        super.init(frame: .zero)
        
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        
        self.numberOfDots.forEach { (dot) in
            self.stackView.addArrangedSubview(dot)
        }
        
        self.stackView.alignment = .center
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 6
        
        self.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
        
        self.numberOfDots.forEach { dot in
            self.addConstraints([
                dot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
                dot.widthAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 1, constant: 0),
                dot.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 1, constant: 0)
            ])
        }
    }
    
    @objc private func onPageControlTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    private func onChangeCurrentPage() {
        
        if currentPage >= 0 && currentPage < self.numberOfPages {
            let selectedDot = self.numberOfDots[self.currentPage]
            
            numberOfDots.forEach { (dot) in
                setupDotAppearance(dot: dot)
                
                if dot.tag == selectedDot.tag {
                        UIView.animate(withDuration: 0.3, animations: {
                        selectedDot.outerView.layer.borderColor = UIColor.appBackgroundColor.cgColor
                        selectedDot.outerView.backgroundColor = self.currentPageIndicatorTintColor
                    })
                    self.sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    //MARK: Helper methods...
    private func getDotView() -> CustomPageControlView {
        let dot = CustomPageControlView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPageControlTapped(_:))))
        return dot
    }
    
    private func setupDotAppearance(dot: CustomPageControlView) {
        dot.outerView.layer.borderColor = UIColor.clear.cgColor
        dot.outerView.backgroundColor = self.pageIndicatorTintColor
    }
}
