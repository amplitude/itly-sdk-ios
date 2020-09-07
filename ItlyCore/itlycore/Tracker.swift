//
//  ItlyTracker.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 31.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

protocol Tracker {
    func alias(_ userId: String, previousId: String?) throws
    func identify(_ userId: String?, properties: ItlyProperties?) throws
    func group(_ userId: String?, groupId: String, properties: ItlyProperties?) throws
    func track(_ userId: String?, event: ItlyEvent) throws
}


private extension ItlyEvent {
    func superOf(_ superProperties: ItlyProperties?) -> GenericEvent {
        var props = superProperties?.properties ?? [:]
        props.merge(self.properties) { leftValue, rightValue in
            return rightValue
        }
        return GenericEvent(name: self.name, properties: props)
    }
}

class DefaultTracker {
    private let validator: Validator?
    private let trackInvalid: Bool
    private let logger: ItlyLogger?
    private let plugins: [String: ItlyPlugin]
    private let superProperties: ItlyProperties?
    
    private var destinations: [String: ItlyDestination] = [:]
    
    func alias(_ userId: String, previousId: String?) throws {
        destinations.forEach { id, destination in
            do {
                try destination.alias(userId, previousId: previousId)
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(id).alias(): \(error.localizedDescription)")
            }
        }
    }
    
    func identify(_ userId: String?, properties: ItlyProperties?) throws {
        let event = GenericEvent(name: "identify", properties: properties?.properties).superOf(self.superProperties)
        guard try shouldBeTracked(event) else { return }
        
        destinations.forEach { pluginId, destination in
            do {
                try destination.identify(userId, properties: event)
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(pluginId).identify(): \(error.localizedDescription)")
            }
        }
    }
    
    public func group(_ userId: String?, groupId: String, properties: ItlyProperties?) throws {
        let event = GenericEvent(name: "group", properties: properties?.properties).superOf(self.superProperties)
        guard try shouldBeTracked(event) else { return }
        
        destinations.forEach { pluginId, destination in
            do {
                try destination.group(userId, groupId: groupId, properties: event)
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(pluginId).group(): \(error.localizedDescription)")
            }
        }
    }
    
    public func track(_ userId: String?, event: ItlyEvent) throws {
        let event = event.superOf(self.superProperties)
        guard try shouldBeTracked(event) else {
            return
        }
        
        destinations.forEach { pluginId, destination in
            do {
                try destination.track(userId, event: event)
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(pluginId).track(\(event.name)): \(error.localizedDescription)")
            }
        }
    }
    
    private func shouldBeTracked(_ event: ItlyEvent) throws -> Bool  {
        do {
            try validator?.validateEvent(event)
        } catch PluginError.validationError(let error, let pluginId) {
            logger?.error("$LOG_TAG Error in \(pluginId).validationError(): \(error.localizedDescription).")
            return trackInvalid
        } catch(let error) {
            // in case of generic error
            logger?.error("$LOG_TAG Error in validator.validateEvent(): \(error.localizedDescription).")
            throw error
        }
        return true
    }
    
    init(plugins: [String: ItlyPlugin],
         superProperties: ItlyProperties?,
         validator: Validator?,
         trackInvalid: Bool,
         logger: ItlyLogger?
    ) throws {
        self.validator = validator
        self.trackInvalid = trackInvalid
        self.logger = logger
        self.plugins = plugins
        self.superProperties = superProperties
        
        try validator?.validateEvent(GenericEvent(name: "context", properties: superProperties?.properties))
    }
}

extension DefaultTracker: Tracker {}

