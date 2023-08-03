//
//  EndPoints.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/11/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

typealias InternetConnectionChecker = (Bool) -> Void
typealias CallBack = (Bool) -> Void
typealias CallObjectBack<T> = (T?) -> Void
typealias CallArrayBack<T> = ([T]?) -> Void

typealias ClosureObjectBack<T> = (Bool, T?) -> Void
typealias ClosureArrayBack<T> = (Bool, [T]?) -> Void
