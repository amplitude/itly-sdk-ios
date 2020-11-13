//
//  ValidationOptions.swift
//  ItlyCore
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

public let VALIDATION_OPTIONS_DEFAULT_DISABLED = false;
public let VALIDATION_OPTIONS_DEFAULT_TRACK_INVALID = true;
public let VALIDATION_OPTIONS_DEFAULT_ERROR_ON_INVALID = false;
public let VALIDATION_OPTIONS_DEVELOPMENT: ValidationOptions = ValidationOptions(
    disabled: false, trackInvalid: false, errorOnInvalid: true
)
public let VALIDATION_OPTIONS_PRODUCTION: ValidationOptions = ValidationOptions(
    disabled: false, trackInvalid: true, errorOnInvalid: false
)

@objc (ITLValidationOptions) public class ValidationOptions: NSObject {
    @objc public let disabled: Bool
    @objc public let trackInvalid: Bool
    @objc public let errorOnInvalid: Bool

    @objc public convenience override init() {
        self.init(
            disabled: VALIDATION_OPTIONS_DEFAULT_DISABLED,
            trackInvalid: VALIDATION_OPTIONS_DEFAULT_TRACK_INVALID,
            errorOnInvalid: VALIDATION_OPTIONS_DEFAULT_ERROR_ON_INVALID
        );
    }
    
    @objc public init(
        disabled: Bool = VALIDATION_OPTIONS_DEFAULT_DISABLED,
        trackInvalid: Bool = VALIDATION_OPTIONS_DEFAULT_TRACK_INVALID,
        errorOnInvalid: Bool = VALIDATION_OPTIONS_DEFAULT_ERROR_ON_INVALID
    ) {
        self.disabled = disabled
        self.trackInvalid = trackInvalid
        self.errorOnInvalid = errorOnInvalid
        super.init()
    }
    
    public class func getValidationOptions(_ environment: Environment) -> ValidationOptions {
        return (environment == .production) ? VALIDATION_OPTIONS_PRODUCTION : VALIDATION_OPTIONS_DEVELOPMENT;
    }
    
    // Convenience builder for ObjC, in Swift use ValidationOptions() with optional params
    @objc public class func builderBlock(
        _ builderBlock: (ValidationOptionsBuilder) -> Void
    ) -> ValidationOptions {
        let builder = ValidationOptionsBuilder()
        builderBlock(builder)
        return builder.build()
    }
    
    // Convenience builder for ObjC, in Swift use ValidationOptions() with optional params
    @objc(disabled:trackInvalid:errorOnInvalid:) public class func create(
        disabled: Bool = VALIDATION_OPTIONS_DEFAULT_DISABLED,
        trackInvalid: Bool = VALIDATION_OPTIONS_DEFAULT_TRACK_INVALID,
        errorOnInvalid: Bool = VALIDATION_OPTIONS_DEFAULT_ERROR_ON_INVALID
    ) -> ValidationOptions {
        return ValidationOptions(
            disabled: disabled,
            trackInvalid: trackInvalid,
            errorOnInvalid: errorOnInvalid
        )
    }
}

@objc (ITLValidationOptionsBuilder) open class ValidationOptionsBuilder: NSObject {
    @objc public var disabled: Bool = VALIDATION_OPTIONS_DEFAULT_DISABLED
    @objc public var trackInvalid: Bool = VALIDATION_OPTIONS_DEFAULT_TRACK_INVALID
    @objc public var errorOnInvalid: Bool = VALIDATION_OPTIONS_DEFAULT_ERROR_ON_INVALID
        
    @objc public func build() -> ValidationOptions {
        return ValidationOptions(
            disabled: self.disabled,
            trackInvalid: self.trackInvalid,
            errorOnInvalid: self.errorOnInvalid
        )
    }
}
