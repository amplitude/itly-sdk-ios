//
//  ItlySchemaValidatorPlugin.swift
//  ItlySchemaValidatorPlugin
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation
import ItlySdk
import DSJSONSchemaValidation

@objc(ITLSchemaValidatorPlugin) public class ItlySchemaValidatorPlugin: Plugin {
    private let validatorsMap: [String: DSJSONSchema]
    private weak var logger: Logger?

    @objc public init(schemasMap: [String: Data]) throws {
        self.validatorsMap = try schemasMap.mapValues{ data -> DSJSONSchema in
            return try DSJSONSchema(data: data, baseURI: nil, referenceStorage: nil, specification: .draft7(), options: DSJSONSchemaValidationOptions())
        }
        super.init(id: "ItlySchemaValidatorPlugin")
    }

    public override func load(_ options: Options) {
        super.load(options)

        logger = options.logger
        logger?.debug("\(self.id) load")
    }

    public override func validate(_ event: Event) -> ValidationResponse {
        logger?.debug("\(self.id) validate(event=\(event.name))")
        guard let validator = validatorsMap[event.name] else {
            // no validator found
            return ValidationResponse(valid: false, message: "No schema found for \(event.name).")
        }

        logger?.debug("\(self.id) validator=\(validator)")
        do {
            try validator.validate(event.properties)
        } catch let error {
            // This is really a com.argentumko.JSONSchemaValidationError but unable to import type
            let errorObj = (error as NSObject)
            let failureReason = errorObj.value(forKey: "localizedFailureReason") ?? "Unknown validation error.";

            var propertyInfo = "";
            var validatorInfo = "";
            do {
                let userInfo: NSDictionary = (errorObj.value(forKey: "userInfo") ?? "") as! NSDictionary;
                let propertyPath = userInfo["path"] ?? "unknown"
                let propertyValue = userInfo["object"] ?? "undefined"
                propertyInfo = " Error with property \(propertyPath) = \(propertyValue)."

                let validator = userInfo["validator"]
                validatorInfo = validator.debugDescription
                let startIndex = validatorInfo.firstIndex(of: "{") ?? validatorInfo.startIndex
                let endIndex = validatorInfo.firstIndex(of: "}") ?? validatorInfo.endIndex
                validatorInfo = " Rules " + String(validatorInfo[startIndex..<endIndex]) + "}"

                // NOTE: The following call to fakeThrowableForSwift() is purely to make `pod lint` happy
                //   It is possible to throw an error in ObjC above, however, this is
                //   not visible to Swift which produces the following warning
                //   "warning: 'catch' block is unreachable because no errors are thrown in 'do' block"
                //   This dummy function informs Swift an error may occur in this try block
                try fakeThrowableForSwift()
            } catch {

            }

            return ValidationResponse(
                valid: false,
                message: "\(error.localizedDescription)\(propertyInfo) \(failureReason)\(validatorInfo)",
                pluginId: self.id
            )
        }

        return ValidationResponse(valid: true, pluginId: self.id)
    }

    /**
    A do nothing function that pretends it can throw
    */
    private func fakeThrowableForSwift() throws {}
}
