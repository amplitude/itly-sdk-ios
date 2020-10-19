//
//  Options.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 14.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc (ITLItlyOptions) open class Options: NSObject {
    @objc public let environment: Environment
    @objc public let disabled: Bool
    @objc public let plugins: [Plugin]
    @objc public let validation: ValidationOptions
    @objc public let logger: Logger?
    
    @objc public init(environment: Environment = .development,
                disabled: Bool = false,
                plugins: [Plugin] = [],
                validation: ValidationOptions? = nil,
                logger: Logger?
    ) {
        self.environment = environment
        self.disabled = disabled
        self.plugins = plugins
        self.validation = validation ?? ValidationOptions(trackInvalid: environment == .production, errorOnInvalid: environment != .production)
        self.logger = logger
        super.init()
    }
}
