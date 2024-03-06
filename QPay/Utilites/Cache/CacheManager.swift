//
//  CacheManager.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/09/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Cache

typealias CachableModel = Codable

final class CacheManager<Model: CachableModel> {
    
    var storage: Storage<String, Model>?
    
    private let diskConfig = DiskConfig(
        // The name of disk storage, this will be used as folder name within directory
        name: "DiskConfig",
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the `setObject(forKey:expiry:)` method
        expiry: .never,
        // Maximum size of the disk cache storage (in bytes)
        maxSize: 10000,
        // Where to store the disk cache. If nil, it is placed in `cachesDirectory` directory.
        directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                appropriateFor: nil, create: true).appendingPathComponent("MyPreferences"),
        // Data protection is used to store files in an encrypted format on disk and to decrypt them on demand
        protectionType: .complete
    )
    
    private let memoryConfig = MemoryConfig(
        // Expiry date that will be applied by default for every added object
        // if it's not overridden in the `setObject(forKey:expiry:)` method
        expiry: .seconds(604800), /// 1 Week
        /// The maximum number of objects in memory the cache should hold
        countLimit: 40,
        /// The maximum total cost that the cache can hold before it starts evicting objects
        totalCostLimit: 0
    )
    
    public init?() {
        do {
            self.storage = try Storage<String, Model>(diskConfig: self.diskConfig,
                                                            memoryConfig: memoryConfig,
                                                            transformer: TransformerFactory.forCodable(ofType: Model.self))
        } catch {
            print("\(#file) init ERROR \(error.localizedDescription)")
        }
    }
}

//struct CacheConfiguration {
//
//}
