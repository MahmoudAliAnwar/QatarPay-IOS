//
//  String+Extension.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation

extension String {
    func formatted(with args: [String]?) -> String {
        guard let args = args, args.count > 0 else {
            return self
        }
        
        var data = self
        for i in 0...args.count - 1 {
            data = data.replacingOccurrences(of: "{\(i)}", with: args[i])
        }
        return data
    }
}

extension String {
     struct NumFormatter {
         static let instance = NumberFormatter()
     }

     var doubleValue: Double? {
         return NumFormatter.instance.number(from: self)?.doubleValue
     }

     var integerValue: Int? {
         return NumFormatter.instance.number(from: self)?.intValue
     }
}
