//
//  DueToPaySectionController.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/03/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class DueToPaySectionController: ViewController {
    
    public var selectedCardType: BillCardTypes = .credit
    
    public enum BillCardTypes: Int, CaseIterable {
        case credit = 1
        case debit
        case wallet
    }
    
    public enum SectionTypes: String, CaseIterable {
        case phone = "phonebil"
        case kahramaa = "kahrama"
        case qatar_cool = "qatarcool"
    }
    
    public let qidMaxDigit: Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    public func sendPaymentRequest(for section: SectionTypes, paymentMethod: BillCardTypes, amount: Double, qidNumber: String, serviceNumber: String, mobile: String) {
        
        self.requestProxy.requestService()?.paymentDueToPay(amount: amount,
                                                            qidNumber: qidNumber,
                                                            serviceNumber: serviceNumber,
                                                            mobile: mobile,
                                                            paymentMethod: paymentMethod.rawValue,
                                                            type: section.rawValue,
                                                            completion: { status, response in
            guard status else { return }
            self.showSuccessMessage(response?._message)
        })
    }
}
