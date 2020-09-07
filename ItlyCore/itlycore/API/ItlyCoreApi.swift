//
//  ItlyCoreApi.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 27.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public protocol ItlyCoreApi {
    var environment: ItlyEnvironment { get }
    var isDisabled: Bool { get }
    var logger: ItlyLogger? { get }
    var plugins: [String: ItlyPlugin] { get }
    var superProperties: ItlyProperties? { get }
    var validationModes: [Int] { get }
    
    func alias(_ userId: String, previousId: String?)
    func identify(_ userId: String?, properties: ItlyProperties?)
    func group(_ userId: String?, groupId: String, properties: ItlyProperties?)
    func track(_ userId: String?, event: ItlyEvent)

    func reset()
    func flush()
    func shutdown()
}

