//
//  ItlyCore.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 24.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public class ItlyInstance: NSObject, ItlyCoreApi {
    private var pluginManager: PluginManager!
    private var tracker: Tracker!

    public let environment: ItlyEnvironment
    public let isDisabled: Bool
    public let logger: ItlyLogger?
    public let superProperties: ItlyProperties?
    public let validationModes: [Int]
    public var plugins: [String: ItlyPlugin] { pluginManager?.plugins ?? [:] }
    
    public func alias(_ userId: String, previousId: String?) {
        do {
            try tracker?.alias(userId, previousId: previousId)
        } catch (let error) {
            logger?.error("$LOG_TAG Error in tracker.alias(): \(error.localizedDescription)")
        }
    }
    
    public func identify(_ userId: String?, properties: ItlyProperties?) {
        do {
            try tracker?.identify(userId, properties: properties)
        } catch (let error) {
            logger?.error("$LOG_TAG Error in tracker.identify(): \(error.localizedDescription)")
        }
    }
    
    public func group(_ userId: String?, groupId: String, properties: ItlyProperties?) {
        do {
            try tracker?.group(userId, groupId: groupId, properties: properties)
        } catch (let error) {
            logger?.error("$LOG_TAG Error in tracker.group(): \(error.localizedDescription)")
        }
    }
    
    public func track(_ userId: String?, event: ItlyEvent) {
        do {
            try tracker?.track(userId, event: event)
        } catch (let error) {
            logger?.error("$LOG_TAG Error in tracker.track(\(event.name)): \(error.localizedDescription)")
        }
    }
    
    public func reset() {
        do {
            try pluginManager?.reset()
        } catch (let error) {
            logger?.error("$LOG_TAG Error in pluginManager.reset(): \(error.localizedDescription)")
        }
    }
    
    public func flush() {
        do {
            try pluginManager?.flush()
        } catch (let error) {
            logger?.error("$LOG_TAG Error in pluginManager.flush(): \(error.localizedDescription)")
        }
    }
    
    public func shutdown() {
        do {
            try pluginManager?.shutdown()
        } catch (let error) {
            logger?.error("$LOG_TAG Error in pluginManager.shutdown(): \(error.localizedDescription)")
        }
    }

    public init(environment: ItlyEnvironment = .development,
         isDisabled: Bool = false,
         logger: ItlyLogger? = nil,
         superProperties: ItlyProperties? = nil,
         validationModes: [Int],
         plugins: [String: ItlyPlugin]
    ) {
        self.environment = environment
        self.isDisabled = isDisabled
        self.logger = logger
        self.superProperties = superProperties
        self.validationModes = validationModes//.map{ $0.rawValue }
        super.init()

        let validationModes = validationModes.compactMap{ ItlyValidationMode.init(rawValue: $0) }
        if isDisabled {
            self.pluginManager = nil
            self.tracker = nil
            logger?.info("$LOG_TAG disabled = true")
            return
        }

        let pluginManager = DefaultPluginManager(
            plugins: plugins,
            logger: logger
        )
        self.pluginManager = pluginManager

        do {
            try pluginManager.didPlugIntoInstance(self)
        } catch(let error) {
            self.logger?.error("$LOG_TAG Error on plugins initialization: \(error.localizedDescription)")
        }
        
        var tracker: Tracker? = nil
        do {
            let validator = !validationModes.contains(.disabled) ?
                DefaultValidator(
                    plugins: pluginManager.plugins,
                    errorOnInvalid: validationModes.contains(.errorOnInvalid),
                    logger: logger
                ) : nil

            tracker = try DefaultTracker(
                plugins: plugins,
                superProperties: superProperties,
                validator: validator,
                trackInvalid: validationModes.contains(.trackInvalid),
                logger: logger
            )
        } catch(let error) {
            self.logger?.error("$LOG_TAG Error on tracker instantiation: \(error.localizedDescription)")
        }
        self.tracker = tracker
    }
}
