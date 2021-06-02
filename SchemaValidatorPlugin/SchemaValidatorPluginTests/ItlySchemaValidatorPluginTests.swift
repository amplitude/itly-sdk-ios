//
//  ItlySchemaValidatorPluginTests.swift
//  ItlySchemaValidatorPluginTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlySdk
@testable import ItlySchemaValidatorPlugin

class ItlySchemaValidatorPluginTests: XCTestCase {
    let schemas: [String: Data] = [
        "context" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/context\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Context\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredString\":{\"description\":\"description for context requiredString\",\"type\":\"string\"},\"optionalEnum\":{\"description\":\"description for context optionalEnum\",\"enum\":[\"Value 1\",\"Value 2\"]}},\"additionalProperties\":false,\"required\":[\"requiredString\"]}",
        "group" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/group\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Group\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredBoolean\":{\"description\":\"Description for group requiredBoolean\",\"type\":\"boolean\"},\"optionalString\":{\"description\":\"Description for group optionalString\",\"type\":\"string\"}},\"additionalProperties\":false,\"required\":[\"requiredBoolean\"]}",
        "identify" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/identify\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Identify\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"optionalArray\":{\"description\":\"Description for identify optionalArray\",\"type\":\"array\",\"uniqueItems\":false,\"items\":{\"type\":\"string\"}},\"requiredNumber\":{\"description\":\"Description for identify requiredNumber\",\"type\":\"number\"}},\"additionalProperties\":false,\"required\":[\"requiredNumber\"]}",
        "Test Event" : "{\"type\":\"object\",\"properties\":{\"requiredString\":{\"type\":\"string\"},\"optionalEnum\":{\"enum\":[\"Value 1\",\"Value 2\"]}},\"additionalProperties\":false,\"required\":[\"requiredString\"]}",
    ].compactMapValues{ $0.data(using: .utf8) }

    class Context: Properties {
        static let VALID_ONLY_REQUIRED_PROPS = Context(requiredString: "Required context string")
        static let VALID_ALL_PROPS = Context(requiredString: "Required context string", optionalEnum: .value1)
        static let INVALID_NO_PROPS = Properties()

        enum OptionalEnum: String {
            case value1 = "Value 1"
            case value2 = "Value 2"
        }

        init(requiredString: String, optionalEnum: OptionalEnum? = nil) {
            super.init(Properties.compact([
                "requiredString": requiredString,
                "optionalEnum": optionalEnum?.rawValue ?? nil
            ]))
        }
    }

    class TestEvent: Event {
        static let VALID_ONLY_REQUIRED_PROPS = TestEvent(requiredString: "Required context string")
        static let VALID_ALL_PROPS = TestEvent(requiredString: "Required context string", optionalEnum: .value1)
        static let INVALID_NO_PROPS = Event(name: "Test Event")

        enum OptionalEnum: String {
            case value1 = "Value 1"
            case value2 = "Value 2"
        }

        init(requiredString: String, optionalEnum: OptionalEnum? = nil) {
            super.init(
                name: "Test Event",
                propertiesDict: Properties.compact([
                    "requiredString": requiredString,
                    "optionalEnum": optionalEnum?.rawValue
                ]),
                id: "1234-567-890123",
                version: "1.0.0",
                metadata: nil
            )
        }
    }

    var validator: ItlySchemaValidatorPlugin!

    override func setUpWithError() throws {
        self.validator = try ItlySchemaValidatorPlugin(schemasMap: schemas)
        validator.load(Options(logger: nil))
    }

    override func tearDownWithError() throws {
        self.validator = nil
    }

    func testLoadValidator() throws {
        XCTAssertTrue(true)
    }

    func testContextWithValidProperties() throws {
        XCTAssertTrue(validator.validate(ItlySchemaValidatorPluginTests.TestEvent.VALID_ALL_PROPS).valid)
    }

    func testContextWithInvalidProperties() throws {
        let res = validator.validate(ItlySchemaValidatorPluginTests.TestEvent.INVALID_NO_PROPS)
        XCTAssertFalse(res.valid)
    }

}
