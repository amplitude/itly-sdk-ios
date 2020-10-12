//
//  ItlyFixtures.swift
//  SampleApp_Carthage
//
//  Created by Konstantin Dorogan on 28.09.2020.
//

import Foundation
import ItlySdk
import ItlySchemaValidatorPlugin

@objc extension Itly {
    @objc static let shared = Itly()
}

@objc public class ConsoleLogger: NSObject, Logger {
    public func debug(_ message: String) {
        print("ITLY [debug]: \(message)")
    }
    
    public func info(_ message: String) {
        print("ITLY [info]: \(message)")
    }
    
    public func warn(_ message: String) {
        print("ITLY [warn]: \(message)")
    }
    
    public func error(_ message: String) {
        print("ITLY [error]: \(message)")
    }
}



@objc extension ItlySchemaValidatorPlugin {
    @objc convenience init() throws {
        let schemas: [String: Data] = [
            "context" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/context\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Context\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredString\":{\"description\":\"description for context requiredString\",\"type\":\"string\"},\"optionalEnum\":{\"description\":\"description for context optionalEnum\",\"enum\":[\"Value 1\",\"Value 2\"]}},\"additionalProperties\":false,\"required\":[\"requiredString\"]}",
            "group" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/group\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Group\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredBoolean\":{\"description\":\"Description for group requiredBoolean\",\"type\":\"boolean\"},\"optionalString\":{\"description\":\"Description for group optionalString\",\"type\":\"string\"}},\"additionalProperties\":false,\"required\":[\"requiredBoolean\"]}",
            "identify" : "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/identify\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Identify\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"optionalArray\":{\"description\":\"Description for identify optionalArray\",\"type\":\"array\",\"uniqueItems\":false,\"items\":{\"type\":\"string\"}},\"requiredNumber\":{\"description\":\"Description for identify requiredNumber\",\"type\":\"number\"}},\"additionalProperties\":false,\"required\":[\"requiredNumber\"]}"
        ].compactMapValues{ $0.data(using: .utf8) }
        try self.init(schemasMap: schemas)
    }
}

@objc class Context: Event {
    @objc static let VALID_ONLY_REQUIRED_PROPS = Context(requiredString: "Required context string")
    @objc static let VALID_ALL_PROPS = Context(requiredString: "Required context string", optionalEnum: .value1)
    @objc static let INVALID_NO_PROPS = Event(name: "context")
    
    enum OptionalEnum: String {
        case value1 = "Value 1"
        case value2 = "Value 2"
    }
    
    init(requiredString: String, optionalEnum: OptionalEnum? = nil) {
        super.init(name: "context", properties: ["requiredString": requiredString, "optionalEnum": optionalEnum?.rawValue].compactMapValues{ $0 })
    }
}

@objc class Identify: Event {
    @objc static let VALID_ALL_PROPS = Identify(requiredNumber: 2.0, optionalArray: ["optional"])
    
    @objc init(requiredNumber: Double, optionalArray: [String]? = nil) {
        var dict:[String:Any] = ["requiredNumber": requiredNumber]
        if let optionalArray = optionalArray {
            dict["optionalArray"] = optionalArray
        }
        super.init(name: "identify", properties: dict)
    }
}

@objc class Group: Event {
    @objc static let VALID_ALL_PROPS = Group(requiredBoolean: false, optionalString: "I'm optional!")
    
    
    @objc init(requiredBoolean: Bool, optionalString: String? = nil) {
        var dict:[String:Any] = ["requiredBoolean": requiredBoolean]
        if let optionalString = optionalString {
            dict["optionalString"] = optionalString
        }
        super.init(name: "group", properties: dict)
    }
}

@objc class EventNoProperties: Event {
    @objc init() {
        super.init(name: "Event No Properties")
    }
}
