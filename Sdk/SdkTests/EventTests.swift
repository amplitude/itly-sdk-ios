//
//  EventTests.swift
//  ItlyCoreTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlySdk

class EventTests: XCTestCase {

    func testEmptyEvent() throws {
        let event = Event(name: "test")
        XCTAssertTrue(event.properties.isEmpty)
    }

    func testSimplyEvent() throws {
        let event = Event(name: "test", id: "test_id", version: "test_version")
        XCTAssertEqual(event.properties.count, 0)
        XCTAssertEqual(event.properties.keys.sorted(), [].sorted())
        XCTAssertEqual(event.id, "test_id")
        XCTAssertEqual(event.version, "test_version")
    }

    func testCustomEvent() throws {
        class CustomEvent: Event {
            var customProperty: String? { properties["customProperty"] as? String }

            convenience init(customProperty: String) {
                self.init(name: "customEvent",
                          properties: Properties( ["customProperty": customProperty]))
            }
        }

        let event = CustomEvent(customProperty: "test_value")
        XCTAssertEqual(event.name, "customEvent")
        XCTAssertEqual(event.properties.count, 1)
        XCTAssertEqual(event.properties["customProperty"] as! String, "test_value")
        XCTAssertEqual(event.customProperty, "test_value")
    }

}
