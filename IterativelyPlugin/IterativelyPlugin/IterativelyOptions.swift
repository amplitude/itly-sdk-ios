//
//  IterativelyOptions.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 18.09.2020.
//

import Foundation
import ItlySdk

public let MS_IN_S: Int = 1000
public let S_IN_M: Int = 60
public let M_IN_H: Int = 60

@objc(ITLIterativelyOptions) public class IterativelyOptions: NSObject {
    @objc public let url: String
    @objc public let environment: Environment
    @objc public let omitValues: Bool
    @objc public let batchSize: Int
    @objc public let flushQueueSize: Int
    @objc public let flushIntervalMs: Int
    @objc public let maxRetries: Int
    @objc public let delayInitialMillis: Int
    @objc public let delayMaximumMillis: Int
    
    @objc public init(url: String,
                environment: Environment = .development,
                omitValues: Bool = false,
                batchSize: Int = 100,
                flushQueueSize: Int = 10,
                flushIntervalMs: Int = 10_000,
                maxRetries: Int = 25, // ~1 day
                delayInitialMillis: Int = 10 * MS_IN_S, // 10 seconds
                delayMaximumMillis: Int = 1 * MS_IN_S * S_IN_M * M_IN_H // = 1 hr
                ) {
        self.url = url
        self.environment = environment
        self.omitValues = omitValues
        self.batchSize = batchSize
        self.flushQueueSize = flushQueueSize
        self.flushIntervalMs = flushIntervalMs
        self.maxRetries = maxRetries
        self.delayInitialMillis = delayInitialMillis
        self.delayMaximumMillis = delayMaximumMillis
    }
}
