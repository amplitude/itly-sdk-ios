//
//  ItlyJsonSchemaValiadtorPlugin.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import ItlyCore
import DSJSONSchemaValidation

class ItlyJsonSchemaValiadtorPlugin: NSObject, ItlyPlugin, ItlySchemaValidator {
    private let validatorsMap: [String: DSJSONSchema]
    private var logger: ItlyLogger?
    
    func didPlugIntoInstance(_ instance: ItlyCoreApi) throws {
        logger = instance.logger
        logger?.debug("ItlyJsonSchemaValiadtorPlugin load")
    }
    
    func reset() throws {
        // do nothing
    }
    
    func flush() throws {
        // do nothing
    }
    
    func shutdown() throws {
        // do nothing
    }
    
    func validateEvent(_ event: ItlyEvent) throws {
        logger?.debug("ItlyJsonSchemaValiadtorPlugin validate(event=\(event.name))")
        guard let validator = validatorsMap[event.name] else {
            // no validator found
            return
        }
        
        logger?.debug("ItlyJsonSchemaValiadtorPlugin validator=\(validator)")
        try validator.validate(event.properties)
    }
    
    public init(schemasMap: [String: Data]) throws {
        self.validatorsMap = try schemasMap.mapValues{ data -> DSJSONSchema in
            return try DSJSONSchema(data: data, baseURI: nil, referenceStorage: nil, specification: .draft7(), options: DSJSONSchemaValidationOptions())
        }
        super.init()
    }
}
