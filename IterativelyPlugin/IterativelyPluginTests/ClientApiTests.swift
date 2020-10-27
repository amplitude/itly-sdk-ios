//
//  ClientApiTests.swift
//  ItlyIterativelyPluginTests
//
//  Created by Konstantin Dorogan on 24.09.2020.
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
    let baseUrl = URL(string: "https://base.url")!
    let apiKey = "api_key"
    var clientApi: ClientApi!
    let testModel = TrackModel(type: .group,
               dateSent: "date",
               eventId: "test_id",
               eventSchemaVersion: "1.0",
               eventName: "test",
               properties: ["property1": "value1", "property2": 2],
               valid: true,
               validation: Validation(details: ""))

    override func setUp() {
        super.setUp()
        
        self.clientApi = DefaultClientApi(baseUrl: self.baseUrl,
                                          apiKey: self.apiKey,
                                          urlSession: self.sessionUrl)
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
        XCTAssertEqual(sessionUrl.request!.url?.absoluteURL, self.baseUrl)
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
}
