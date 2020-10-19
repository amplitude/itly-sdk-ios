//
//  ItlyCore.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 24.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc (ITLItly) public class Itly: NSObject {
    private var config: Options!
    private var context: Event!

    private var isDisabled: Bool { config?.disabled ?? true }
    
    @objc public func alias(_ userId: String, previousId: String?) {
        guard !isDisabled else { return }
        
        self.config.plugins.alias(userId, previousId: previousId, options: config!)
    }
    
    @objc public func identify(_ userId: String?, properties: Properties?) {
        guard !isDisabled else { return }

        let event = Event(name: "identify", properties: properties)
        let validation = validate(event)
        
        config.plugins.identify(userId, properties: event, validationResults: validation, options: config!)
        
        validation.filter{ !$0.valid }.forEach{ invalidResult in
            config.logger?.error("Itly Error in tracker.identify(): \(invalidResult.message ?? "")")
        }
    }
    
    @objc public func group(_ groupId: String, properties: Properties?) {
        guard !isDisabled else { return }

        let event = Event(name: "group", properties: properties)
        let validation = validate(event)
        
        config.plugins.group(nil, groupId: groupId, properties: event, validationResults: validation, options: config!)

        validation.filter{ !$0.valid }.forEach{ invalidResult in
            config.logger?.error("Itly Error in tracker.group(): \(invalidResult.message ?? "")")
        }
    }
    
    @objc public func track(_ event: Event) {
        guard !isDisabled else { return }

        let validation = validateContextWithEvent(event)
        
        let combinedEvent = event.mergeProperties(context)
        config.plugins.track(nil, event: combinedEvent, validationResults: validation, options: config!)

        validation.filter{ !$0.valid }.forEach{ invalidResult in
            config.logger?.error("Itly Error in tracker.track(\(event.name)): \(invalidResult.message ?? "")")
        }
    }
    
    @objc public func reset() {
        guard !isDisabled else { return }

        config.plugins.reset(options: config!)
    }
    
    @objc public func flush() {
        guard !isDisabled else { return }

        config.plugins.flush(options: config!)
    }
    
    @objc public func shutdown() {
        guard !isDisabled else { return }

        config.plugins.shutdown(options: config!)
    }

    @objc public func load(_ context: Properties?, options: Options) {
        guard !options.disabled else {
            options.logger?.info("Itly disabled = true")
            return
        }
        
        self.config = options
        self.context = Event(name: "context", properties: context)
        
        self.config.logger?.debug("Itly load")
        self.config.logger?.debug("Itly \(config.plugins.count) plugins are enabled")

        self.config.plugins.load(options)
    }
    
    private func validate(_ event: Event) -> [ValidationResponse] {
        guard !config.validation.disabled else {
            return []
        }
        
        return config.plugins.validate(event, options: config!)
    }
    
    private func validateContextWithEvent(_ event: Event) -> [ValidationResponse] {
        let validatedContext = validate(context)
        let validatedEvent = validate(event)
        
        return validatedContext + validatedEvent
    }
}
