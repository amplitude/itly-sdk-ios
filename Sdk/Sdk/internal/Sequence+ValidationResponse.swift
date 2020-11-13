//
//  Sequence+ValidationResponse.swift
//  ItlyCore
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

extension Sequence where Element == ValidationResponse {
    var valid: Bool {
        self.first{ !$0.valid } == nil
    }
}
