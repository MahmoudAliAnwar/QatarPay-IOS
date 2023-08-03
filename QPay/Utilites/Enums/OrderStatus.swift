//
//  InvoicePaidStatus.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/28/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum OrderStatus: String, CaseIterable {
    case Pending
    case Paid
    case CashCollected = "Cash Collected"
}
