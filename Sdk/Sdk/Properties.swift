//
//  Properties.swift
//  Sdk
//
//  Created by Konstantin Dorogan on 26.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

public extension Properties {
    convenience init(_ optionalDict: [String: Any?]) {
        self.init(optionalDict.mapValues{ $0 ?? NSNull() })
    }
}
