//
//  ItlyIterativelyPluginTests.swift
//  ItlyIterativelyPluginTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlyIterativelyPlugin
@testable import ItlySdk

class TrackModelBuilderTests: XCTestCase {
    class MockedTrackModelDateFormatter: TrackModelDateFormatter {
        func string(from date: Date) -> String {
            return "mocked_date"
        }
    }

    let formatter = MockedTrackModelDateFormatter()
    let testEvent = Event(name: "test", properties: Properties( ["property1": "value1", "property2": "value2"]), id: "test_id", version: "mocked_version")

    func testTrackModelTypes() throws {
        let builder = DefaultTrackModelBuilder(dateFormatter: formatter, omitValues: false)

        XCTAssertEqual(builder.buildTrackModelForType(.group).type, .group)
        XCTAssertEqual(builder.buildTrackModelForType(.identify).type, .identify)
        XCTAssertEqual(builder.buildTrackModelForType(.track).type, .track)
    }

    func testTrackModelValidation() throws {
        let builder = DefaultTrackModelBuilder(dateFormatter: formatter, omitValues: false)
        let model = builder.buildTrackModelForType(
            .group, validation: ValidationResponse(valid: false, message: "Validation Message")
        )

        XCTAssertEqual(model.validation.details, "Validation Message")
    }

    func testNoOmitValues() throws {
        let builder = DefaultTrackModelBuilder(dateFormatter: formatter, omitValues: false)

        let model = builder.buildTrackModelForType(.group, event: testEvent, properties: testEvent, validation: nil)
        XCTAssertEqual(model.type, .group)
        XCTAssertEqual(model.dateSent, "mocked_date")
        XCTAssertEqual(model.eventId, testEvent.id)
        XCTAssertEqual(model.eventSchemaVersion, testEvent.version)
        XCTAssertEqual(model.eventName, testEvent.name)
        XCTAssertEqual(model.properties!.count, testEvent.properties.count)
        XCTAssertEqual(model.properties!["property1"] as! String, "value1")
        XCTAssertEqual(model.properties!["property2"] as! String, "value2")
        XCTAssertTrue(model.valid)
        XCTAssertEqual(model.validation.details, "")
    }

    func testOmitValues() throws {
        let builder = DefaultTrackModelBuilder(dateFormatter: formatter, omitValues: true)

        let model = builder.buildTrackModelForType(.group, event: testEvent, properties: testEvent, validation: nil)
        XCTAssertEqual(model.type, .group)
        XCTAssertEqual(model.dateSent, "mocked_date")
        XCTAssertEqual(model.eventId, testEvent.id)
        XCTAssertEqual(model.eventSchemaVersion, testEvent.version)
        XCTAssertEqual(model.eventName, testEvent.name)
        XCTAssertEqual(model.properties!.count, testEvent.properties.count)
        XCTAssertTrue(model.properties!["property1"] as? NSNull != nil)
        XCTAssertTrue(model.properties!["property2"] as? NSNull != nil)
        XCTAssertTrue(model.valid)
        XCTAssertEqual(model.validation.details, "")
    }

}
