//
//  ItlySchemaValidator.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 24.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public protocol ItlySchemaValidator {
    func validateEvent(_ event: ItlyEvent) throws
}

@objc public protocol ItlySchemaValidationHandler {
    func onValidationError(_ error: Error, withEvent event: ItlyEvent, andPluginId pluginId: String) throws
}
