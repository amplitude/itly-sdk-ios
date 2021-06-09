//
//  IterativelyPluginTests.swift
//  ItlyIterativelyPluginTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlyIterativelyPlugin
@testable import ItlySdk

class IterativelyPluginTests: XCTestCase {
     func test_optionsUrl_noUrl_usesDefaultDataplaneUrl() throws {
        let options = IterativelyOptions()
        XCTAssertEqual(options.url, "https://data.us-east-2.iterative.ly/t")
    }

    func test_optionsUrl_setUrl_usesSetUrl() throws {
        let options = IterativelyOptions(url: "https://api.iterative.ly/t/12-34-56")
        XCTAssertEqual(options.url, "https://api.iterative.ly/t/12-34-56")
    }

    func test_constructor_withApiKey_usesDefaultDataplaneUrl() throws {
        let plugin = try IterativelyPlugin("api-key")

        XCTAssertEqual(plugin.url(), "https://data.us-east-2.iterative.ly/t")
    }

    func test_constructor_withApiKeyAndOptions_usesOptionsUrl() throws {
        let options = IterativelyOptions(url: "http://my.url")
        let plugin = try IterativelyPlugin("api-key", options: options)

        XCTAssertEqual(plugin.url(), options.url)
    }

    func test_constructor_withApiKeyUrlAndOptions_usesUrlFromArgs() throws {
        let url = "http://my.url"
        let options = IterativelyOptions(url: "http://options.url")
        let plugin = try IterativelyPlugin("api-key", url: url, options: options)

        XCTAssertEqual(plugin.url(), url)
        XCTAssertNotEqual(plugin.url(), options.url)
    }
}
