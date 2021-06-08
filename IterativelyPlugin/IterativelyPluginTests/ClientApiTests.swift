//
//  ClientApiTests.swift
//  ItlyIterativelyPluginTests
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import XCTest
@testable import ItlyIterativelyPlugin
@testable import ItlySdk

func jsonDataToDictionary(_ data: Data?) -> [String: Any]? {
    if data != nil {
        do {
            return try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func jsonStringToDictionary(_ text: String) -> [String: Any]? {
    return jsonDataToDictionary(text.data(using: .utf8))
}

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
        uploadTrackModels(clientApi!, [testModel])
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

    func testRequest_withBranchAndVersion_hasBranchAndVersionInJson() throws {
        self.clientApi = DefaultClientApi(
            apiKey: self.apiKey,
            options: IterativelyOptions(
                url: trackerUrl,
                branch: "main",
                version: "1.2.3"
            ),
            urlSession: self.sessionUrl
        )

        uploadTrackModels(clientApi!, [testModel])

        let requestBody = sessionUrl.request!.httpBody
        XCTAssertNotNil(requestBody)
        let requestJson = jsonDataToDictionary(requestBody)

        XCTAssertEqual(requestJson!["trackingPlanVersion"] as! String, "1.2.3")
        XCTAssertEqual(requestJson!["branchName"] as! String, "main")
    }

    func testRequest_withoutBranchAndVersion_noBranchAndVersionInJson() throws {
        uploadTrackModels(clientApi!, [testModel])

        let requestBody = sessionUrl.request!.httpBody
        XCTAssertNotNil(requestBody)
        let requestJson = jsonDataToDictionary(requestBody)

        XCTAssertNil(requestJson!["trackingPlanVersion"])
        XCTAssertNil(requestJson!["branchName"])
    }

    /**
    * Mocks successful upload of given @batch via @client.uploadTrackModels
    * Waits for requests to complete before continuing
    */
    private func uploadTrackModels(_ client: ClientApi, _ batch: [TrackModel]) {
        sessionUrl.statusCode = 200
        var callbackCalled = false
        client.uploadTrackModels(batch) { result in
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
}
