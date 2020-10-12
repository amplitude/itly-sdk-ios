//
//  PluginTests.swift
//  ItlyCoreTests
//
//  Created by Konstantin Dorogan on 21.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
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
