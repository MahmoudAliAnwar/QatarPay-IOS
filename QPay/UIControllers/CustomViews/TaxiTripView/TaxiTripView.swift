//
//  TaxiTripView.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class TaxiTripView: UIView {

    @IBOutlet weak var currentLocationNameLabel: UILabel!
    @IBOutlet weak var destinationLocationNameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInt()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.customInt()
    }
    
    private func customInt() {
        let nibView = Bundle.main.loadNibNamed("TaxiTripView", owner: self, options: nil)?.first as! UIView
        self.addSubview(nibView)
        nibView.frame = self.bounds
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
