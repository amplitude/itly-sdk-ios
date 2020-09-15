//
//  Options.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 14.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc open class Options: NSObject {
    public let context: Properties?
    public let environment: Environment
    public let disabled: Bool
    public let plugins: [Plugin]
    public let validation: ValidationOptions
    public let logger: Logger?
    
    public init(context: Properties? = nil,
                environment: Environment = .development,
                disabled: Bool = false,
                plugins: [Plugin] = [],
                validation: ValidationOptions? = nil,
                logger: Logger?
    ) {
        self.context = context
        self.environment = environment
        self.disabled = disabled
        self.plugins = plugins
        self.validation = validation ?? ValidationOptions(trackInvalid: environment == .production, errorOnInvalid: environment != .production)
        self.logger = logger
        super.init()
    }
}
