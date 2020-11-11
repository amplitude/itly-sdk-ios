//
//  Options.swift
//  Options for Itly
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

// DEFAULTS
public let DEFAULT_ENVIRONMENT: Environment = .development
public let DEFAULT_DISABLED: Bool = false
public let DEFAULT_PLUGINS: [Plugin] = []
public let DEFAULT_LOGGER: Logger? = nil
public let DEFAULT_VALIDATION_OPTIONS: ValidationOptions? = nil
public let VALIDATION_OPTIONS_DEV: ValidationOptions = ValidationOptions(
    disabled: false, trackInvalid: false, errorOnInvalid: true
)
public let VALIDATION_OPTIONS_PROD: ValidationOptions = ValidationOptions(
    disabled: false, trackInvalid: true, errorOnInvalid: false
)


@objc (ITLItlyOptions) open class Options: NSObject {
    @objc public let environment: Environment
    @objc public let disabled: Bool
    @objc public let plugins: [Plugin]
    @objc public let validation: ValidationOptions
    @objc public let logger: Logger?

    @objc public init(
        environment: Environment = DEFAULT_ENVIRONMENT,
        disabled: Bool = DEFAULT_DISABLED,
        plugins: [Plugin] = DEFAULT_PLUGINS,
        validation: ValidationOptions? = DEFAULT_VALIDATION_OPTIONS,
        logger: Logger? = DEFAULT_LOGGER
    ) {
        self.environment = environment
        self.disabled = disabled
        self.plugins = plugins
        self.validation = validation ?? ((environment == .production)
            ? VALIDATION_OPTIONS_PROD
            : VALIDATION_OPTIONS_DEV)
        self.logger = logger
        super.init()
    }
    
    @objc public func withOverrides(
        _ builderBlock: (OptionsBuilder) -> Void
    ) -> Options {
        let builder = OptionsBuilder()
        builder.setOptions(self)
        builderBlock(builder)
        return builder.build()
    }
    
    // Convenience builder for ObjC, in Swift use Options() with optional params
    @objc public class func builderBlock(
        _ builderBlock: (OptionsBuilder) -> Void
    ) -> Options {
        let builder = OptionsBuilder()
        builderBlock(builder)
        return builder.build()
    }
}

@objc (ITLItlyOptionsBuilder) open class OptionsBuilder: NSObject {
    @objc public var environment: Environment = DEFAULT_ENVIRONMENT
    @objc public var disabled: Bool = DEFAULT_DISABLED
    @objc public var plugins: [Plugin] = DEFAULT_PLUGINS
    @objc public var logger: Logger? = DEFAULT_LOGGER
    @objc public var validation: ValidationOptions? = DEFAULT_VALIDATION_OPTIONS
    
    @objc public func setOptions(_ options: Options) {
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

