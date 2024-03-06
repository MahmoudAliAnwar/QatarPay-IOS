//
//  CalendarPopup.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class CalendarPopup: UIView {
    
    var okBtnClosure: ((Date) -> ())?
    var dismissClosure: (() -> ())?
    
    let dPicker: UIDatePicker = {
        let v = UIDatePicker()
        return v
    }()
    
    let okButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
        let pickerHolderView: UIView = {
            let v = UIView()
            v.backgroundColor = .white
            v.layer.cornerRadius = 8
            return v
        }()
        
        self.setupOkButton()
        
        [blurredEffectView, pickerHolderView, dPicker, okButton].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(blurredEffectView)
        pickerHolderView.addSubview(dPicker)
        pickerHolderView.addSubview(okButton)
        addSubview(pickerHolderView)
        
        NSLayoutConstraint.activate([
            
            blurredEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pickerHolderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            pickerHolderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            pickerHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dPicker.topAnchor.constraint(equalTo: pickerHolderView.topAnchor, constant: 20.0),
            dPicker.leadingAnchor.constraint(equalTo: pickerHolderView.leadingAnchor, constant: 20.0),
            dPicker.trailingAnchor.constraint(equalTo: pickerHolderView.trailingAnchor, constant: -20.0),
            dPicker.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -20.0),
            
            okButton.topAnchor.constraint(equalTo: dPicker.bottomAnchor, constant: 20),
            okButton.leadingAnchor.constraint(equalTo: pickerHolderView.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: pickerHolderView.trailingAnchor, constant: -20),
            okButton.bottomAnchor.constraint(equalTo: pickerHolderView.bottomAnchor, constant: -20.0),
        ])
        
        if #available(iOS 14.0, *) {
            dPicker.preferredDatePickerStyle = .inline
        } else {
            // use default
        }
        
        dPicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        blurredEffectView.addGestureRecognizer(tap)
        
        okButton.addTarget(self, action: #selector(self.didTapOkBtn(_:)), for: .touchUpInside)
    }
    
    private func setupOkButton() {
        self.okButton.setTitle("OK", for: .normal)
        self.okButton.setTitleColor(.white, for: .normal)
        self.okButton.backgroundColor = .systemBlue
        self.okButton.layer.cornerRadius = 4
    }
    
    @objc
    private func didTapOkBtn(_ gesture: UITapGestureRecognizer) {
        self.hidePopup()
        okBtnClosure?(self.dPicker.date)
    }
    
    @objc
    private func tapHandler(_ gesture: UITapGestureRecognizer) {
        self.hidePopup()
        dismissClosure?()
    }
    
    @objc
    private func didChangeDate(_ sender: UIDatePicker) -> Void {
//        okBtnClosure?(sender.date)
    }
    
    private func hidePopup() {
        self.isHidden = true
    }
}
