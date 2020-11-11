//
//  Properties.swift
//  Sdk
//
//  Copyright © 2020 Iteratively. All rights reserved.
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
