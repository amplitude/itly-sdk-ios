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
                logger: Logger? = nil
    ) {
        self.environment = environment
        self.disabled = disabled
        self.plugins = plugins
        self.validation = validation ?? ValidationOptions(trackInvalid: environment == .production, errorOnInvalid: environment != .production)
        self.logger = logger
        super.init()
    }
}

@objc public extension Options {
    @objc func withOverrides(environment: Environment,
                             disabled: NSNumber? = nil,
                             plugins: [Plugin]? = nil,
                             validation: ValidationOptions? = nil,
                             logger: Logger? = nil
    ) -> Options {
        return Options(
            environment: environment,
            disabled: disabled?.boolValue ?? self.disabled,
            plugins: plugins ?? self.plugins,
            validation: validation ?? self.validation,
            logger: logger ?? self.logger
        )
    }

    @objc func withOverrides(disabled: NSNumber? = nil,
                             plugins: [Plugin]? = nil,
                             validation: ValidationOptions? = nil,
                             logger: Logger? = nil
    ) -> Options {
        self.withOverrides(environment: self.environment,
                           disabled: disabled,
                           plugins: plugins,
                           validation: validation,
                           logger: logger
                           )
    }
}

public extension Options {
    func withOverrides(environment: Environment? = nil,
                       disabled: Bool? = nil,
                       plugins: [Plugin]? = nil,
                       validation: ValidationOptions? = nil,
                       logger: Logger? = nil
    ) -> Options {
        self.withOverrides(
            environment: environment ?? self.environment,
            disabled: disabled.map{ NSNumber(booleanLiteral: $0)},
            plugins: plugins,
            validation: validation,
            logger: logger)
     }
}


@objc (ITLItlyOptionsBuilder) open class OptionsBuilder: NSObject {
    @objc public var environment: Environment = .development
    @objc public var disabled: Bool = false
    @objc public var plugins: [Plugin] = []
    @objc public var logger: Logger? = nil
    @objc public var validation: ValidationOptions

    @objc public override init() {
        self.validation = ValidationOptions(trackInvalid: environment == .production, errorOnInvalid: environment != .production)
        super.init()
    }

    @objc public func build() -> Options {
        return Options(environment: environment,
                       disabled: disabled,
                       plugins: plugins,
                       validation: validation, logger: logger)
    }
}
