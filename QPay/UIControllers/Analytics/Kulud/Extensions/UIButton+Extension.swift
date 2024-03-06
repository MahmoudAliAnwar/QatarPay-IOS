//
//  UIButton+Extension.swift
//  kulud
//
//  Created by Hussam Elsadany on 04/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

extension UIButton {
    var activityIndicatorTag: Int {
        return 1
    }

    func startLoading(style: UIActivityIndicatorView.Style = .medium) {
        setTitle("", for: .disabled)
        isEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = self.titleLabel?.textColor
        activityIndicator.tag = activityIndicatorTag
        addSubview(activityIndicator)
        pinItemToEdges(item: activityIndicator)
        activityIndicator.startAnimating()
        UIView.performWithoutAnimation { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    func stopLoading() {
        isEnabled = true
        if let activityIndicator = viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }

        UIView.performWithoutAnimation { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    private func pinItemToEdges(item: UIView, constants: [CGFloat] = [0, 0, 0 ,0]) {
        item.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .trailing, .bottom, .leading]
        activateLayoutAttributes(attributes, for: item, constants: constants)
    }
    
    private func activateLayoutAttributes(_ attributes: [NSLayoutConstraint.Attribute], for item: UIView, constants: [CGFloat] = [0, 0, 0, 0]) {
        var i = -1
        NSLayoutConstraint.activate(attributes.map {
            i += 1
            return NSLayoutConstraint(item: item, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: constants[i])
        })
    }
}

