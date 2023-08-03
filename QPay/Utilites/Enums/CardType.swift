//
//  CardType.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

enum CardType: String, CaseIterable {
    
    case Visa
    case Master = "MasterCard"
    case American = "AmericanExpress"
    case Diners = "DinersClub"
    case JCB
    case Maestro
}
