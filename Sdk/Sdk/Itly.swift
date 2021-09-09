//
//  ItlyCore.swift
//  Iteratively_example
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

@objc (ITLItly) public class Itly: NSObject {
    private var config: Options!
    private var context: Event? = nil

    private var isDisabled: Bool { config?.disabled ?? true }

    @objc public func load(_ context: Properties?, options: Options?) {
        let config = options ?? Options()

        guard self.config == nil else {
            self.config.logger?.error("Error: Itly is already loaded. [Itly.instance load] should only be called once.")
            return
        }

        guard !config.disabled else {
            config.logger?.info("Itly disabled = true")
            return
        }

        if (context != nil) {
            self.context = Event(name: "context", properties: context)
        }

        self.config = config
        self.config.logger?.debug("Itly load")
        self.config.logger?.debug("Itly \(config.plugins.count) plugins are enabled")

        runOnAllPlugins(op: "load") { (plugin) in
            try plugin.safeLoad(config);
        }
    }

    @objc public func alias(_ userId: String, previousId: String?) {
        guard !isDisabled else { return }

        runOnAllPlugins(op: "alias") { (plugin) in
            try plugin.safeAlias(userId, previousId: previousId);
        }
        runOnAllPlugins(op: "postAlias") { (plugin) in
            try plugin.safePostAlias(userId, previousId: previousId);
        }
    }

    @objc public func identify(_ userId: String?, properties: Properties?) {
        guard !isDisabled else { return }

        validateAndRunOnAllPlugins(
            op: "identify",
            event: Event(name: "identify", properties: properties),
            includeContext: false,
            method: { (p, e) in
                try p.safeIdentify(userId, properties: e)
            },
            postMethod: { (p, e, validation) in
                try p.safePostIdentify(userId, properties: e, validationResults: validation)
            })
    }

    @objc public func group(_ groupId: String, properties: Properties?) {
        guard !isDisabled else { return }

        validateAndRunOnAllPlugins(
            op: "group",
            event: Event(name: "group", properties: properties),
            includeContext: false,
            method: { (p, e) in
                try p.safeGroup(nil, groupId: groupId, properties: e)
            },
            postMethod: { (p, e, validation) in
                try p.safePostGroup(nil, groupId: groupId, properties: e, validationResults: validation)
            })
    }

    @objc public func track(_ event: Event) {
        guard !isDisabled else { return }

        validateAndRunOnAllPlugins(
            op: "track",
            event: event,
            includeContext: true,
            method: { (p, e) in
                try p.safeTrack(nil, event: e)
            },
            postMethod: { (p, e, validation) in
                try p.safePostTrack(nil, event: e, validationResults: validation)
            })
    }

    @objc public func reset() {
        guard !isDisabled else { return }

        runOnAllPlugins(op: "reset") { (plugin) in
            try plugin.safeReset();
        }
    }

    @objc public func flush() {
        guard !isDisabled else { return }

        runOnAllPlugins(op: "flush") { (plugin) in
            try plugin.safeFlush();
        }
    }

    @objc public func shutdown() {
        guard !isDisabled else { return }

        runOnAllPlugins(op: "shutdown") { (plugin) in
            try plugin.safeShutdown();
        }
    }

    private func validate(_ event: Event) -> [ValidationResponse] {
        guard !config.validation.disabled else {
            return []
        }

        var validation: [ValidationResponse] = []
        runOnAllPlugins(op: "validate") { (plugin) in
            validation.append(try plugin.safeValidate(event));
        }

        return validation
    }

    private func validateAndRunOnAllPlugins(
        op: String,
        event: Event,
        includeContext: Bool,
        method: (Plugin, Event) throws -> Void,
        postMethod: (Plugin, Event, [ValidationResponse]) throws -> Void
    ) {
        let contextValidation = (includeContext && self.context != nil) ? validate(self.context!) : []
        let isContextValid = contextValidation.valid

        let eventValidation = validate(event)
        let isEventValid = eventValidation.valid

        let isValid = isContextValid && isEventValid;

        let combinedEvent = (includeContext && self.context != nil)
            ? event.mergeProperties(self.context!)
            : event

        if (isValid || config.validation.trackInvalid) {
            runOnAllPlugins(op: op, method: { plugin in
                try method(plugin, combinedEvent)
            })
        }

        let validation = contextValidation + eventValidation

        // Log any errors
        validation.filter{ !$0.valid }.forEach{ invalidResult in
            config.logger?.error("Validation error for \(combinedEvent.name): \(invalidResult.message ?? "")")
        }

        // Run post method
        runOnAllPlugins(op: op, method: { plugin in
            try postMethod(plugin, combinedEvent, validation)
        })

        // Throw error is requested
        if (!isValid && config.validation.errorOnInvalid) {
            fatalError(validation.first{ !$0.valid }?.message ?? "Unknown error validating \(event.name)")
        }
    }

    private func runOnAllPlugins(op: String, method: (Plugin) throws -> Void) {
        config.plugins.forEach { plugin in
            do {
                try method(plugin)
            } catch {
                config.logger?.error("Itly Error in \(plugin.id).\(op): \(error.localizedDescription).")
            }
        }
    }
}
