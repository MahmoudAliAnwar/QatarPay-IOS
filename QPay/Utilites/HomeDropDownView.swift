//
//  HomeDropDownView.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class HomeDropDownView: ViewDesign {
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        
        // resize your layers based on the view's new frame
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        let color1 = "5a092a".hexStringToUIColor().cgColor
        let color2 = "7e1732".hexStringToUIColor().cgColor
//        let color1 = UIColor.systemRed.cgColor
//        let color2 = UIColor.mRed.cgColor
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    let iconsWidth: CGFloat = 24
    let stacksHeight: CGFloat = 34
    let buttonsFontSize: CGFloat = 16
    
    lazy var aboutStackView: UIStackView = {
        
        let aboutImage = Images.info_circle_fill.image
        
        let aboutImageView = UIImageView(image: aboutImage)
        aboutImageView.widthAnchor.constraint(equalToConstant: self.iconsWidth).isActive = true
        aboutImageView.widthAnchor.constraint(equalTo: aboutImageView.heightAnchor, multiplier: 1.0 / 1.0).isActive = true
        aboutImageView.tintColor = .white
        aboutImageView.contentMode = .scaleAspectFit
        aboutImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.aboutButtonClicked(_:))))
        
        let aboutBtn = UIButton(frame: CGRect())
        aboutBtn.setTitle("About App", for: .normal)
        aboutBtn.titleLabel?.font = .systemFont(ofSize: buttonsFontSize)
        aboutBtn.contentHorizontalAlignment = .leading
////        aboutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.aboutButtonClicked(_:))))
        
        let aboutStack = UIStackView(frame: CGRect())
        aboutStack.axis = .horizontal
        aboutStack.spacing = 8
        aboutStack.alignment = .fill
        aboutStack.distribution = .fill
        aboutStack.heightAnchor.constraint(equalToConstant: self.stacksHeight).isActive = true
        aboutStack.addArrangedSubview(aboutImageView)
        aboutStack.addArrangedSubview(aboutBtn)
        
        return aboutStack
    }()
    
    lazy var contactStackView: UIStackView = {
        
        let contactImage = Images.ic_contact_home.image
        
        let contactImageView = UIImageView(image: contactImage)
        contactImageView.widthAnchor.constraint(equalToConstant: self.iconsWidth).isActive = true
        contactImageView.widthAnchor.constraint(equalTo: contactImageView.heightAnchor, multiplier: 1.0 / 1.0).isActive = true
        contactImageView.contentMode = .scaleAspectFit
        
        let contactBtn = UIButton(frame: CGRect())
        contactBtn.setTitle("Contact", for: .normal)
        contactBtn.titleLabel?.font = .systemFont(ofSize: buttonsFontSize)
        contactBtn.contentHorizontalAlignment = .leading
        contactBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.contactButtonClicked(_:))))
        
        let contactStack = UIStackView(frame: CGRect())
        contactStack.axis = .horizontal
        contactStack.spacing = 8
        contactStack.alignment = .fill
        contactStack.distribution = .fill
        contactStack.heightAnchor.constraint(equalToConstant: self.stacksHeight).isActive = true
        contactStack.addArrangedSubview(contactImageView)
        contactStack.addArrangedSubview(contactBtn)
        
        return contactStack
    }()
    
    lazy var settingsStackView: UIStackView = {
        
        let settingsImage = Images.ic_gear.image
        let settingsImageView = UIImageView(image: settingsImage)
        settingsImageView.widthAnchor.constraint(equalToConstant: self.iconsWidth).isActive = true
        settingsImageView.widthAnchor.constraint(equalTo: settingsImageView.heightAnchor, multiplier: 1.0 / 1.0).isActive = true
        settingsImageView.contentMode = .scaleAspectFit
        
        let settingsBtn = UIButton(frame: CGRect())
        settingsBtn.setTitle("Settings", for: .normal)
        settingsBtn.titleLabel?.font = .systemFont(ofSize: buttonsFontSize)
        settingsBtn.contentHorizontalAlignment = .leading
        settingsBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.settingsButtonClicked(_:))))

        let settingsStack = UIStackView(frame: CGRect())
        settingsStack.axis = .horizontal
        settingsStack.spacing = 8
        settingsStack.alignment = .fill
        settingsStack.distribution = .fill
        settingsStack.heightAnchor.constraint(equalToConstant: self.stacksHeight).isActive = true
        settingsStack.addArrangedSubview(settingsImageView)
        settingsStack.addArrangedSubview(settingsBtn)
        
        return settingsStack
    }()
    
    lazy var logoutStackView: UIStackView = {
        
        let logoutImage = Images.ic_logout_home.image
        let logoutImageView = UIImageView(image: logoutImage)
        logoutImageView.widthAnchor.constraint(equalToConstant: self.iconsWidth).isActive = true
        logoutImageView.widthAnchor.constraint(equalTo: logoutImageView.heightAnchor, multiplier: 1.0 / 1.0).isActive = true
        logoutImageView.contentMode = .scaleAspectFit
        
        let logoutBtn = UIButton(frame: CGRect())
        logoutBtn.setTitle("Logout", for: .normal)
        logoutBtn.backgroundColor = .systemOrange
        logoutBtn.titleLabel?.font = .systemFont(ofSize: buttonsFontSize)
        logoutBtn.contentHorizontalAlignment = .leading
        logoutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.logoutButtonClicked(_:))))

        let logoutStack = UIStackView(frame: CGRect())
        logoutStack.axis = .horizontal
        logoutStack.spacing = 8
        logoutStack.alignment = .fill
        logoutStack.distribution = .fill
        logoutStack.heightAnchor.constraint(equalToConstant: self.stacksHeight).isActive = true
        logoutStack.addArrangedSubview(logoutImageView)
        logoutStack.addArrangedSubview(logoutBtn)
        
        return logoutStack
    }()
    
    lazy var popupView: HomeDropDownView = {
        
        let containerStack = UIStackView(frame: CGRect())
        containerStack.axis = .vertical
        containerStack.spacing = 10
        containerStack.clipsToBounds = true
        containerStack.alignment = .fill
        containerStack.distribution = .fill
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let containerChildStack = UIStackView(frame: CGRect())
        containerChildStack.axis = .vertical
        containerChildStack.spacing = 24
        containerChildStack.clipsToBounds = true
        containerChildStack.alignment = .fill
        containerChildStack.distribution = .fillEqually
        containerChildStack.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = HomeDropDownView(frame: CGRect())
        containerView.layer.cornerRadius = 0
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let solutionView = UIView(frame: CGRect())
        solutionView.backgroundColor = .systemOrange
        let solutionView2 = UIView(frame: CGRect())
        
        containerStack.addArrangedSubview(solutionView)
        containerStack.addArrangedSubview(self.aboutStackView)
        containerStack.addArrangedSubview(self.settingsStackView)
        containerStack.addArrangedSubview(self.contactStackView)
        containerStack.addArrangedSubview(self.logoutStackView)
        containerStack.addArrangedSubview(solutionView2)
        
        solutionView.heightAnchor.constraint(equalTo: solutionView2.heightAnchor, multiplier: 1.0 / 1.0).isActive = true
        
        containerView.addSubview(containerStack)
        
        let containerStackPadding: CGFloat = 4
        let stackLeadingConstraint = NSLayoutConstraint(item: containerStack, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: (containerStackPadding * 5))
        let stackTrailingConstraint = NSLayoutConstraint(item: containerStack, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: containerStackPadding)
        
        let stackTopConstraint = NSLayoutConstraint(item: containerStack, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: (containerStackPadding / 2))
        let stackBottomConstraint = NSLayoutConstraint(item: containerStack, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: (containerStackPadding / 2))
        
        containerView.addConstraints([stackLeadingConstraint, stackTrailingConstraint, stackTopConstraint, stackBottomConstraint])
        
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        return containerView
    }()

    func showHidePopupView(_ sender: UIButton) {
        
//            self.view.addSubview(self.popupView)
//
//            let popupLeadingConstraint = NSLayoutConstraint(item: self.popupView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: (self.view.frame.width / 2.2))
//            let popupTrailingConstraint = NSLayoutConstraint(item: self.popupView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
//            let popupTopConstraint = NSLayoutConstraint(item: self.popupView, attribute: .top, relatedBy: .equal, toItem: sender, attribute: .bottom, multiplier: 1, constant: -10)
//            self.view.addConstraints([popupLeadingConstraint, popupTrailingConstraint, popupTopConstraint])
        
//            UIView.animate(withDuration: 0.3) {
//                self.popupView.alpha = 1
//            }
    }
    
    @objc private func aboutButtonClicked(_ gesture: UIGestureRecognizer) {
        print("About App")
    }
    
    @objc private func contactButtonClicked(_ gesture: UIGestureRecognizer) {
        print("Contact")
    }
    
    @objc private func settingsButtonClicked(_ gesture: UIGestureRecognizer) {
        print("Settings")
    }
    
    @objc private func logoutButtonClicked(_ gesture: UIGestureRecognizer) {
        print("Logout")
    }
    
}
