//
//  ValidationResponse.swift
//  ItlyCore
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

@objc (ITLValidationResponse) public class ValidationResponse: NSObject {
    @objc public let valid: Bool
    @objc public let message: String?
    @objc public let pluginId: String?

    @objc public init(valid: Bool, message: String? = nil, pluginId: String? = nil) {
        self.valid = valid
        self.message = message
        self.pluginId = pluginId

        super.init()
    }
}
