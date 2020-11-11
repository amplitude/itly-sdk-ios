//
//  Properties.swift
//  Sdk
//
//  Created by Konstantin Dorogan on 26.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

public extension Properties {
    convenience init(optionalDict: [String: Any?]) {
        self.init(Properties.compact(optionalDict))
    }

    static func compact(_ propertiesDict: [String: Any?]?) -> [String: Any] {
        return propertiesDict?.mapValues{ $0 ?? NSNull() } ?? [:]
    }
}
