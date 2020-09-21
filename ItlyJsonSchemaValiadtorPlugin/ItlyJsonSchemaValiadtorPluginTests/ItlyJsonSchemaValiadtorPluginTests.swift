//
//  ItlyJsonSchemaValiadtorPluginTests.swift
//  ItlyJsonSchemaValiadtorPluginTests
//
//  Created by Konstantin Dorogan on 21.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import XCTest
@testable import ItlyCore
@testable import ItlyJsonSchemaValiadtorPlugin

class ItlyJsonSchemaValiadtorPluginTests: XCTestCase {
    let schemas: [String: Data] = [
        "context" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/context\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Context\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredString\":{\"description\":\"description for context requiredString\",\"type\":\"string\"},\"optionalEnum\":{\"description\":\"description for context optionalEnum\",\"enum\":[\"Value 1\",\"Value 2\"]}},\"additionalProperties\":false,\"required\":[\"requiredString\"]}",
        "group" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/group\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Group\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredBoolean\":{\"description\":\"Description for group requiredBoolean\",\"type\":\"boolean\"},\"optionalString\":{\"description\":\"Description for group optionalString\",\"type\":\"string\"}},\"additionalProperties\":false,\"required\":[\"requiredBoolean\"]}",
        "identify" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/identify\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Identify\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"optionalArray\":{\"description\":\"Description for identify optionalArray\",\"type\":\"array\",\"uniqueItems\":false,\"items\":{\"type\":\"string\"}},\"requiredNumber\":{\"description\":\"Description for identify requiredNumber\",\"type\":\"number\"}},\"additionalProperties\":false,\"required\":[\"requiredNumber\"]}"
    ].compactMapValues{ $0.data(using: .utf8) }

    class ContextEvent: Event {
        static let VALID_ONLY_REQUIRED_PROPS = ContextEvent(requiredString: "Required context string")
        static let VALID_ALL_PROPS = ContextEvent(requiredString: "Required context string", optionalEnum: .value1)
        static let INVALID_NO_PROPS = Event(name: "context")
        
        enum OptionalEnum: String {
            case value1 = "Value 1"
            case value2 = "Value 2"
        }
        
        var requiredString: String { properties["requiredString"] as! String }
        var optionalEnum: OptionalEnum? { OptionalEnum(rawValue: properties["optionalEnum"] as! String) }
        
        init(requiredString: String, optionalEnum: OptionalEnum? = nil) {
            super.init(name: "context", properties: ["requiredString": requiredString, "optionalEnum": optionalEnum?.rawValue].compactMapValues{ $0 })
        }
    }
    
    var validator: ItlyJsonSchemaValiadtorPlugin!
    
    override func setUpWithError() throws {
        self.validator = try ItlyJsonSchemaValiadtorPlugin(schemasMap: schemas)
        validator.load(Options(logger: nil))
    }
    
    override func tearDownWithError() throws {
        self.validator = nil
    }
    
    func testLoadValidator() throws {
        XCTAssertTrue(true)
    }

    func testContextWithValidProperties() throws {
        XCTAssertTrue(validator.validate(ContextEvent.VALID_ALL_PROPS).valid)
    }

    func testContextWithInvalidProperties() throws {
        let res = validator.validate(ContextEvent.INVALID_NO_PROPS)
        XCTAssertFalse(res.valid)
        
    }

}
