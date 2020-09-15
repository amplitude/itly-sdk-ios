//
//  ValidationResponse.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 14.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public class ValidationResponse: NSObject {
    public let valid: Bool
    public let message: String?
    public let pluginId: String?
    
    public init(valid: Bool, message: String? = nil, pluginId: String? = nil) {
        self.valid = valid
        self.message = message
        self.pluginId = pluginId
        
        super.init()
    }
}
