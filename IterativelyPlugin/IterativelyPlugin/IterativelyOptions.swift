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

public let OMIT_VALUES: Bool = false
public let BATCH_SIZE: Int = 100
public let FLUSH_QUEUE_SIZE: Int = 10
public let FLUSH_INTERVAL_SIZE: Int = 10000
public let MAX_RETRIES: Int = 25 // ~1 day
public let DELAY_INITIAL_MILLIS: Int = 10 * MS_IN_S // 10 seconds
public let DELAY_MAXIMUM_MILLIS: Int = 1 * MS_IN_S * S_IN_M * M_IN_H // = 1 hr
public let DISABLED: Bool = false

@objc(ITLIterativelyOptions) public class IterativelyOptions: NSObject {
    @objc public let disabled: Bool
    @objc public let omitValues: Bool
    @objc public let batchSize: Int
    @objc public let flushQueueSize: Int
    @objc public let flushIntervalMs: Int
    @objc public let maxRetries: Int
    @objc public let delayInitialMillis: Int
    @objc public let delayMaximumMillis: Int

    @objc public init(
        omitValues: Bool = OMIT_VALUES,
        batchSize: Int = BATCH_SIZE,
        flushQueueSize: Int = FLUSH_QUEUE_SIZE,
        flushIntervalMs: Int = FLUSH_INTERVAL_SIZE,
        maxRetries: Int = MAX_RETRIES,
        delayInitialMillis: Int = DELAY_INITIAL_MILLIS,
        delayMaximumMillis: Int = DELAY_MAXIMUM_MILLIS,
        disabled: Bool = DISABLED
    ) {
        self.disabled = disabled;
        self.omitValues = omitValues
        self.batchSize = batchSize
        self.flushQueueSize = flushQueueSize
        self.flushIntervalMs = flushIntervalMs
        self.maxRetries = maxRetries
        self.delayInitialMillis = delayInitialMillis
        self.delayMaximumMillis = delayMaximumMillis
    }
    
    // Convenience builder for ObjC, in Swift use IterativelyOptions() with optional params
    @objc(builderBlock:) public class func builderBlock(
        builderBlock: (IterativelyOptionsBuilder) -> Void
    ) -> IterativelyOptions {
        let o = IterativelyOptionsBuilder()
        builderBlock(o)
        return IterativelyOptions(
            omitValues: o.omitValues != nil ? o.omitValues!.boolValue : OMIT_VALUES,
            batchSize: o.batchSize != nil ? o.batchSize!.intValue : BATCH_SIZE,
            flushQueueSize: o.flushQueueSize != nil ? o.flushQueueSize!.intValue : FLUSH_QUEUE_SIZE,
            flushIntervalMs: o.flushIntervalMs != nil ? o.flushIntervalMs!.intValue : FLUSH_INTERVAL_SIZE,
            maxRetries: o.maxRetries != nil ? o.maxRetries!.intValue : MAX_RETRIES,
            delayInitialMillis: o.delayInitialMillis != nil ? o.delayInitialMillis!.intValue : DELAY_INITIAL_MILLIS,
            delayMaximumMillis: o.delayMaximumMillis != nil ? o.delayMaximumMillis!.intValue : DELAY_MAXIMUM_MILLIS,
            disabled: o.disabled != nil ? o.disabled!.boolValue : DISABLED
        )
    }
}


// Convenience for ObjC, in Swift use IterativelyOptions() with optional params
@objc(ITLIterativelyOptionsBuilder) public class IterativelyOptionsBuilder: NSObject {
    @objc public var disabled: NSNumber? = nil
    @objc public var omitValues: NSNumber? = nil
    @objc public var batchSize: NSNumber? = nil
    @objc public var flushQueueSize: NSNumber? = nil
    @objc public var flushIntervalMs: NSNumber? = nil
    @objc public var maxRetries: NSNumber? = nil
    @objc public var delayInitialMillis: NSNumber? = nil
    @objc public var delayMaximumMillis: NSNumber? = nil
}
