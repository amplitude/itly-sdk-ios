//
//  ValidationOptions.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 01.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc (ITLValidationOptions) public class ValidationOptions: NSObject {
    public let disabled: Bool
    public let trackInvalid: Bool
    public let errorOnInvalid: Bool
    
    public init(disabled: Bool = false, trackInvalid: Bool = true, errorOnInvalid: Bool = false) {
        self.disabled = disabled
        self.trackInvalid = trackInvalid
        self.errorOnInvalid = errorOnInvalid
        super.init()
    }
}
