//
//  BaseInfoAdapter.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol BaseInfoTabAdapter {
    func convert() -> [BaseInfoTabModel]
 }

protocol BaseInfoDataAdapter {
    func convert() -> [BaseInfoDataModel]
 }

protocol BaseInfoImageAdapter {
    func convert() -> [BaseInfoImageModel]
 }

