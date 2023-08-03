//
//  OrdersTableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 09/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class KuludOrderTableViewCell: UITableViewCell {

    static let identifier = String(describing: KuludOrderTableViewCell.self)
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var orderItemsCountLabel: UILabel!
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    var object: KuludOrder! {
        willSet {
            self.stopAnimation()
            self.orderNumberLabel.text = "Order \(newValue._id)"
            self.orderItemsCountLabel.text = "items: \(newValue._count)"
            self.orderStatusLabel.text = newValue.statusObject?.title ?? ""
            /// 2020-11-12T06:42:36.0056886
            if let date = newValue._created.formatToDate(ServerDateFormat.Server1.rawValue) {
                self.orderDateLabel.text = "Date \(date.formatDate("dd-MM-yyyy"))"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension KuludOrderTableViewCell {
    
    func startAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
    }
    
    func stopAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
}
