//
//  ClientApiTests.swift
//  ItlyIterativelyPluginTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlyIterativelyPlugin
@testable import ItlySdk

class ClientApiTests: XCTestCase {

    class MockedURLSession: URLSession {
        class Task: URLSessionDataTask {
            let closure: () -> Void

            init(closure: @escaping () -> Void) {
                self.closure = closure
            }

            override func resume() {
                self.closure()
            }
        }

        var data: Data?
        var error: Error?
        var statusCode: Int = 200
        var request: URLRequest?

        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.request = request
            let (data, error) = (self.data, self.error)
            let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            return Task() {
                completionHandler(data, response, error)
            }
        }
    }

    //class FF: URLSession
    let sessionUrl = MockedURLSession()
    let trackerUrl = "https://base.url"
    let apiKey = "api_key"
    var clientApi: ClientApi!
    let testModel = TrackModel(
        type: .group,
        messageId: "message-id",
        dateSent: "date",
        eventId: "test_id",
        eventSchemaVersion: "1.0",
        eventName: "test",
        properties: ["property1": "value1", "property2": 2],
        valid: true,
        validation: Validation(details: "")
    )

    override func setUp() {
        super.setUp()
        self.clientApi = DefaultClientApi(
            apiKey: self.apiKey,
            options: IterativelyOptions(url: trackerUrl),
            urlSession: self.sessionUrl
        )
    }

    func testStatus200() throws {
        sessionUrl.statusCode = 200
        var callbackCalled = false
        clientApi!.uploadTrackModels([testModel]) { result in
            callbackCalled = true
            switch result {
            case .failure:
                XCTAssertTrue(false)
                break
            case .success:
                XCTAssertTrue(true)
                break
            }
        }
        XCTAssert(callbackCalled)
    }

    func testStatus500() throws {
        sessionUrl.statusCode = 500
        var callbackCalled = false
        clientApi!.uploadTrackModels([testModel]) { result in
            callbackCalled = true
            switch result {
            case .failure:
                XCTAssertTrue(true)
                break
            case .success:
                XCTAssertTrue(false)
                break
            }
        }
        XCTAssert(callbackCalled)
    }

    func testRequest() throws {
        sessionUrl.statusCode = 200
        var callbackCalled = false
        clientApi!.uploadTrackModels([testModel]) { result in
            callbackCalled = true
            switch result {
            case .failure:
                XCTAssertTrue(false)
                break
            case .success:
                XCTAssertTrue(true)
                break
            }
        }
        XCTAssert(callbackCalled)

        XCTAssertNotNil(sessionUrl.request)
        XCTAssertEqual(sessionUrl.request!.url?.absoluteURL.absoluteString, trackerUrl)
        XCTAssertEqual(sessionUrl.request!.httpMethod?.lowercased(), "post")

        let headers = sessionUrl.request!.allHTTPHeaderFields!
        XCTAssertEqual(headers["Authorization"], "Bearer \(self.apiKey)")
        XCTAssertEqual(headers["Content-Type"], "application/json")

//        struct Body: Encodable {
//            var objects: [TrackModel]
//        }
//        let extectedHttpBody = String(data: try! JSONEncoder().encode(Body(objects: [testModel])), encoding: .utf8)

        XCTAssertNotNil(sessionUrl.request!.httpBody)
        let data = sessionUrl.request!.httpBody!
        let actualHttpBody = String(data: data, encoding: .utf8)

        XCTAssertGreaterThan(actualHttpBody!.count, 0)
    }

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
