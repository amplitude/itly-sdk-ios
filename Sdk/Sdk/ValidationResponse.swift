//
//  ValidationResponse.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 14.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
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
