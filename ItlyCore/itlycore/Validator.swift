//
//  ItlyInternalSchemaValidator.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 31.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

protocol Validator {
    func validateEvent(_ event: ItlyEvent) throws
}

class DefaultValidator {
    private let logger: ItlyLogger?
    private let errorOnInvalid: Bool
    private let plugins: [String: ItlyPlugin]
    
    private var pluginValidators: [String: ItlySchemaValidator] { [:] }
    private var pluginValidationHandlers: [String: ItlySchemaValidationHandler] { [:] }

    
    private func reportValidationError(_ error: Error, withEvent event: ItlyEvent, andPluginId pluginId: String) {
        pluginValidationHandlers.forEach { id, errorHandler in
            do {
                try errorHandler.onValidationError(error, withEvent: event, andPluginId: pluginId)
            } catch(let error) {
                logger?.error("$LOG_TAG Error in \(id).validationError(): \(error.localizedDescription).")
            }
        }
    }
    
    func validateEvent(_ event: ItlyEvent) throws {
        do {
            try pluginValidators.forEach{ id, validator in
                do {
                    try validator.validateEvent(event)
                } catch(let error) {
                    throw PluginError.validationError(error: error, pluginId: id)
                }
            }
        } catch PluginError.validationError(let error, let pluginId) {
            reportValidationError(error, withEvent: event, andPluginId: pluginId)
            
            if errorOnInvalid {
                // Throw original error
                throw error
            }
            
            // Throw just validation error
            throw PluginError.validationError(error: error, pluginId: pluginId)
        }
    }
    
    init(plugins: [String: ItlyPlugin],
         errorOnInvalid: Bool = false,
         logger: ItlyLogger? = nil
    ) {
        self.plugins = plugins
        self.logger = logger
        self.errorOnInvalid = errorOnInvalid
    }
}

extension DefaultValidator: Validator {}
