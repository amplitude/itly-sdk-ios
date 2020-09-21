//
//  ItlyJsonSchemaValiadtorPlugin.swift
//  ItlyJsonSchemaValiadtorPlugin
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import ItlyCore
import DSJSONSchemaValidation

public class ItlyJsonSchemaValiadtorPlugin: Plugin {
    private let validatorsMap: [String: DSJSONSchema]
    private weak var logger: Logger?
    
    public override func load(_ options: Options) {
        super.load(options)
        
        logger = options.logger
        logger?.debug("\(self.id) load")
    }

    public override func validate(_ event: Event) -> ValidationResponse {
        logger?.debug("\(self.id) validate(event=\(event.name))")
        guard let validator = validatorsMap[event.name] else {
            // no validator found
            return ValidationResponse(valid: true)
        }
        
        logger?.debug("\(self.id) validator=\(validator)")
        do {
            try validator.validate(event.properties)
        } catch let error {
            return ValidationResponse(valid: false, message: error.localizedDescription, pluginId: self.id)
        }

        return ValidationResponse(valid: true, pluginId: self.id)
    }
        
    public init(schemasMap: [String: Data]) throws {
        self.validatorsMap = try schemasMap.mapValues{ data -> DSJSONSchema in
            return try DSJSONSchema(data: data, baseURI: nil, referenceStorage: nil, specification: .draft7(), options: DSJSONSchemaValidationOptions())
        }
        super.init(id: "ItlyJsonSchemaValiadtorPlugin")
    }
}
