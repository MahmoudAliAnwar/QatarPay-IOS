//
//  ArrayExtension.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element:Equatable {
    
    public func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension Array {
    
    /// Get after index in array, if last index return first one
    public func safeNextIndex(for index: Int) -> Int {
        let indexAfter = self.index(after: index)
        if indexAfter == self.count {
            return 0
        }
        return indexAfter
    }
    
    /// Get previous index in array, if first index return last one
    public func safePreviousIndex(for index: Int) -> Int {
        let indexBefore = self.index(before: index)
        if indexBefore == -1 {
            return self.count - 1
        }
        return indexBefore
    }
}
