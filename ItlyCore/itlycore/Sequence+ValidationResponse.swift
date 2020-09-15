//
//  Sequence+ValidationResponse.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 15.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

extension Sequence where Element == ValidationResponse {
    var valid: Bool {
        self.first{ !$0.valid } == nil
    }
}
