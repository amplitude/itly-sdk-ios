//
//  IterativelyOptions.swift
//  Options for IterativelyPlugin
//
//  Created by Iteratively 2020.
//

import Foundation
import ItlySdk

public let MS_IN_S: Int = 1000
public let S_IN_M: Int = 60
public let M_IN_H: Int = 60

public let ITERATIVELY_OPTIONS_DEFAULT_OMIT_VALUES: Bool = false
public let ITERATIVELY_OPTIONS_DEFAULT_BATCH_SIZE: Int = 100
public let ITERATIVELY_OPTIONS_DEFAULT_FLUSH_QUEUE_SIZE: Int = 10
public let ITERATIVELY_OPTIONS_DEFAULT_FLUSH_INTERVAL_SIZE: Int = 10000
public let ITERATIVELY_OPTIONS_DEFAULT_MAX_RETRIES: Int = 25 // ~1 day
public let ITERATIVELY_OPTIONS_DEFAULT_DELAY_INITIAL_MILLIS: Int = 10 * MS_IN_S // 10 seconds
public let ITERATIVELY_OPTIONS_DEFAULT_DELAY_MAXIMUM_MILLIS: Int = 1 * MS_IN_S * S_IN_M * M_IN_H // = 1 hr
public let ITERATIVELY_OPTIONS_DEFAULT_DISABLED: Bool = false

@objc(ITLIterativelyOptions) public class IterativelyOptions: NSObject {
    @objc public let disabled: Bool
    @objc public let omitValues: Bool
    @objc public let batchSize: Int
    @objc public let flushQueueSize: Int
    @objc public let flushIntervalMs: Int
    @objc public let maxRetries: Int
    @objc public let delayInitialMillis: Int
    @objc public let delayMaximumMillis: Int

    @objc public convenience override init() {
        self.init(
            omitValues: ITERATIVELY_OPTIONS_DEFAULT_OMIT_VALUES,
            batchSize: ITERATIVELY_OPTIONS_DEFAULT_BATCH_SIZE,
            flushQueueSize: ITERATIVELY_OPTIONS_DEFAULT_FLUSH_QUEUE_SIZE,
            flushIntervalMs: ITERATIVELY_OPTIONS_DEFAULT_FLUSH_INTERVAL_SIZE,
            maxRetries: ITERATIVELY_OPTIONS_DEFAULT_MAX_RETRIES,
            delayInitialMillis: ITERATIVELY_OPTIONS_DEFAULT_DELAY_INITIAL_MILLIS,
            delayMaximumMillis: ITERATIVELY_OPTIONS_DEFAULT_DELAY_MAXIMUM_MILLIS,
            disabled: ITERATIVELY_OPTIONS_DEFAULT_DISABLED
        )
    }
    
    @objc public init(
        omitValues: Bool = ITERATIVELY_OPTIONS_DEFAULT_OMIT_VALUES,
        batchSize: Int = ITERATIVELY_OPTIONS_DEFAULT_BATCH_SIZE,
        flushQueueSize: Int = ITERATIVELY_OPTIONS_DEFAULT_FLUSH_QUEUE_SIZE,
        flushIntervalMs: Int = ITERATIVELY_OPTIONS_DEFAULT_FLUSH_INTERVAL_SIZE,
        maxRetries: Int = ITERATIVELY_OPTIONS_DEFAULT_MAX_RETRIES,
        delayInitialMillis: Int = ITERATIVELY_OPTIONS_DEFAULT_DELAY_INITIAL_MILLIS,
        delayMaximumMillis: Int = ITERATIVELY_OPTIONS_DEFAULT_DELAY_MAXIMUM_MILLIS,
        disabled: Bool = ITERATIVELY_OPTIONS_DEFAULT_DISABLED
    ) {
        self.disabled = disabled;
        self.omitValues = omitValues
        self.batchSize = batchSize
        self.flushQueueSize = flushQueueSize
        self.flushIntervalMs = flushIntervalMs
        self.maxRetries = maxRetries
        self.delayInitialMillis = delayInitialMillis
        self.delayMaximumMillis = delayMaximumMillis
        super.init()
    }
    
    // Convenience builder for ObjC, in Swift use IterativelyOptions() with optional params
    @objc public class func builderBlock(
        _ builderBlock: (IterativelyOptionsBuilder) -> Void
    ) -> IterativelyOptions {
        let builder = IterativelyOptionsBuilder()
        builderBlock(builder)
        return builder.build();
    }
}


// Convenience for ObjC, in Swift use IterativelyOptions() with optional params
@objc (ITLIterativelyOptionsBuilder) open class IterativelyOptionsBuilder: NSObject {
    @objc public var disabled: Bool = ITERATIVELY_OPTIONS_DEFAULT_DISABLED
    @objc public var omitValues: Bool = ITERATIVELY_OPTIONS_DEFAULT_OMIT_VALUES
    @objc public var batchSize: Int = ITERATIVELY_OPTIONS_DEFAULT_BATCH_SIZE
    @objc public var flushQueueSize: Int = ITERATIVELY_OPTIONS_DEFAULT_FLUSH_QUEUE_SIZE
    @objc public var flushIntervalMs: Int = ITERATIVELY_OPTIONS_DEFAULT_FLUSH_INTERVAL_SIZE
    @objc public var maxRetries: Int = ITERATIVELY_OPTIONS_DEFAULT_MAX_RETRIES
    @objc public var delayInitialMillis: Int = ITERATIVELY_OPTIONS_DEFAULT_DELAY_INITIAL_MILLIS
    @objc public var delayMaximumMillis: Int = ITERATIVELY_OPTIONS_DEFAULT_DELAY_MAXIMUM_MILLIS
    
    @objc public func build() -> IterativelyOptions {
        return IterativelyOptions(
            omitValues: self.omitValues,
            batchSize: self.batchSize,
            flushQueueSize: self.flushQueueSize,
            flushIntervalMs: self.flushIntervalMs,
            maxRetries: self.maxRetries,
            delayInitialMillis: self.delayInitialMillis,
            delayMaximumMillis: self.delayMaximumMillis,
            disabled: self.disabled)
    }
}
