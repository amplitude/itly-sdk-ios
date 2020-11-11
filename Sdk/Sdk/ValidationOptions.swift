//
//  ValidationOptions.swift
//  ItlyCore
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

@objc (ITLValidationOptions) public class ValidationOptions: NSObject {
    @objc public let disabled: Bool
    @objc public let trackInvalid: Bool
    @objc public let errorOnInvalid: Bool

    @objc public init(disabled: Bool = false, trackInvalid: Bool = true, errorOnInvalid: Bool = false) {
        self.disabled = disabled
        self.trackInvalid = trackInvalid
        self.errorOnInvalid = errorOnInvalid
        super.init()
    }
}
