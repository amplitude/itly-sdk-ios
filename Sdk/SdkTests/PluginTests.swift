//
//  PluginTests.swift
//  ItlyCoreTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlySdk

class PluginTests: XCTestCase {

    func testExample() throws {
        class CustomPlugin: Plugin {
            override init() {
                super.init(id: "CustomPluginId")
            }
        }

        let plugin = CustomPlugin()
        XCTAssertEqual(plugin.id, "CustomPluginId")
    }

}
