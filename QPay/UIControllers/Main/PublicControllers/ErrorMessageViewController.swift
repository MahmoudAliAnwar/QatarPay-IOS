//
//  ErrorMessageViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ErrorMessageViewController: ViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorImage  : UIImageView!
    

    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.messageLabel.text = self.message ?? ""
        self.errorImage.rotate()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.tryAgainAction(sender)
    }
    
    @IBAction func tryAgainAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 0.15) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue    = -0.3
            rotationAnimation.toValue      = 0.3
            rotationAnimation.duration     = duration
            rotationAnimation.repeatCount  = Float.infinity
            rotationAnimation.autoreverses = true
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
