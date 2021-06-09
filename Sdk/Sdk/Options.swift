//
//  Options.swift
//  Options for Itly
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

// DEFAULTS
public let ITLY_OPTIONS_DEFAULT_ENVIRONMENT: Environment = .development
public let ITLY_OPTIONS_DEFAULT_DISABLED: Bool = false
public let ITLY_OPTIONS_DEFAULT_PLUGINS: [Plugin] = []
public let ITLY_OPTIONS_DEFAULT_VALIDATION_OPTIONS: ValidationOptions? = nil
public let ITLY_OPTIONS_DEFAULT_LOGGER: Logger? = nil

@objc (ITLItlyOptions) open class Options: NSObject {
    @objc public let environment: Environment
    @objc public let disabled: Bool
    @objc public let plugins: [Plugin]
    @objc public let validation: ValidationOptions
    @objc public let logger: Logger?

    
    @objc public convenience override init() {
        self.init(
            environment: ITLY_OPTIONS_DEFAULT_ENVIRONMENT,
            disabled: ITLY_OPTIONS_DEFAULT_DISABLED,
            plugins: ITLY_OPTIONS_DEFAULT_PLUGINS,
            validation: ITLY_OPTIONS_DEFAULT_VALIDATION_OPTIONS,
            logger: ITLY_OPTIONS_DEFAULT_LOGGER
        )
    }
    
    @objc public init(
        environment: Environment = ITLY_OPTIONS_DEFAULT_ENVIRONMENT,
        disabled: Bool = ITLY_OPTIONS_DEFAULT_DISABLED,
        plugins: [Plugin] = ITLY_OPTIONS_DEFAULT_PLUGINS,
        validation: ValidationOptions? = ITLY_OPTIONS_DEFAULT_VALIDATION_OPTIONS,
        logger: Logger? = ITLY_OPTIONS_DEFAULT_LOGGER
    ) {
        self.environment = environment
        self.disabled = disabled
        self.plugins = plugins
        self.validation = validation ?? ValidationOptions.getValidationOptions(environment)
        self.logger = logger
        super.init()
    }
    
    @objc public func withOverrides(_ builderBlock: (OptionsBuilder) -> Void) -> Options {
        let builder = OptionsBuilder(self)
        builderBlock(builder)
        return builder.build()
    }
    
    // Convenience builder for ObjC, in Swift use Options() with optional params
    @objc public class func builderBlock(_ builderBlock: (OptionsBuilder) -> Void) -> Options {
        let builder = OptionsBuilder()
        builderBlock(builder)
        return builder.build()
    }
}

@objc (ITLItlyOptionsBuilder) open class OptionsBuilder: NSObject {
    @objc public var environment: Environment
    @objc public var disabled: Bool
    @objc public var plugins: [Plugin]
    @objc public var logger: Logger?
    @objc public var validation: ValidationOptions?
    
    @objc public init(_ options: Options = Options()) {
        self.disabled = options.disabled
        self.environment = options.environment
        self.plugins = options.plugins
        self.validation = options.validation
        self.logger = options.logger
    }
    
    @objc public func build() -> Options {
        return Options(environment: environment,
                       disabled: disabled,
                       plugins: plugins,
                       validation: validation,
                       logger: logger)
    }
}

