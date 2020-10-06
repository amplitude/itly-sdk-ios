//
//  ProcessingQueueTests.swift
//  ItlyIterativelyPluginTests
//
//  Created by Konstantin Dorogan on 24.09.2020.
//

import XCTest
@testable import ItlyIterativelyPlugin
@testable import ItlySdk

class ProcessingQueueTests: XCTestCase {
    enum SomeError: Error {
        case some
    }
    let retrySettings = QueueRetrySettings(maxRetries: 5,
                                           delayInitialMs: 100,
                                           delayMaximumMs: 500)
    let testModel = TrackModel(type: .group,
               dateSent: "date",
               eventId: "test_id",
               eventSchemaVersion: "1.0",
               eventName: "test",
               properties: ["property1": "value1", "property2": 2],
               valid: true,
               validation: Validation(details: ""))


    
    func testQueueSize() throws {
        class SuccessClientApi: ClientApi {
            var expectation = XCTestExpectation()
            var uploadTrackModelsCount = 0
            
            func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void, ClientApiError>) -> Void)) {
                XCTAssertEqual(batch.count, 2)
                completion(.success(()))
                uploadTrackModelsCount += 1
                expectation.fulfill()
            }
        }

        let client = SuccessClientApi()
        let queue = DefaultProcessingQueue(client: client,
                                           flushQueueSize: 2,
                                           flushIntervalMs: 100_000,
                                           retries: retrySettings)
        
        XCTAssertEqual(client.uploadTrackModelsCount, 0)
        
        client.expectation = XCTestExpectation()
        queue.pushTrackModel(testModel)
        queue.pushTrackModel(testModel)
        wait(for: [client.expectation], timeout: 1)
        XCTAssertEqual(client.uploadTrackModelsCount, 1)

        client.expectation = XCTestExpectation()
        queue.pushTrackModel(testModel)
        queue.pushTrackModel(testModel)
        wait(for: [client.expectation], timeout: 1)
        XCTAssertEqual(client.uploadTrackModelsCount, 2)
    }

    func testQueueFlushInterval() throws {
        class SuccessClientApi: ClientApi {
            var expectation = XCTestExpectation()
            var uploadTrackModelsCount = 0
            
            func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void, ClientApiError>) -> Void)) {
                XCTAssertEqual(batch.count, 1)
                completion(.success(()))
                uploadTrackModelsCount += 1
                expectation.fulfill()
            }
        }

        let client = SuccessClientApi()
        let queue = DefaultProcessingQueue(client: client,
                                           flushQueueSize: 2,
                                           flushIntervalMs: 100,
                                           retries: retrySettings)
        
        XCTAssertEqual(client.uploadTrackModelsCount, 0)
        
        client.expectation = XCTestExpectation()
        queue.pushTrackModel(testModel)
        wait(for: [client.expectation], timeout: 1)
        XCTAssertEqual(client.uploadTrackModelsCount, 1)

        client.expectation = XCTestExpectation()
        queue.pushTrackModel(testModel)
        wait(for: [client.expectation], timeout: 1)
        XCTAssertEqual(client.uploadTrackModelsCount, 2)
    }
    
    func testQueueRetriesWithServerError() throws {
        class ServerErrorClientApi: ClientApi {
            var expectation = XCTestExpectation()
            var uploadTrackModelsCount = 0
            
            func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void, ClientApiError>) -> Void)) {
                completion(.failure(.serverError(500)))
                uploadTrackModelsCount += 1
                if uploadTrackModelsCount >= 5 {
                    expectation.fulfill()
                }
            }
        }

        let client = ServerErrorClientApi()
        let queue = DefaultProcessingQueue(client: client,
                                           flushQueueSize: 2,
                                           flushIntervalMs: 100_000,
                                           retries: retrySettings)

        XCTAssertEqual(client.uploadTrackModelsCount, 0)
        queue.pushTrackModel(testModel)
        queue.pushTrackModel(testModel)
        wait(for: [client.expectation], timeout: Double(retrySettings.maxRetries * retrySettings.delayMaximumMs) / 1000.0)
        XCTAssertEqual(client.uploadTrackModelsCount, 5)
    }
    
    func testQueueRetriesWithNetworkError() throws {
        class NetworkErrorClientApi: ClientApi {
            var expectation = XCTestExpectation()
            var uploadTrackModelsCount = 0
            
            func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void, ClientApiError>) -> Void)) {
                completion(.failure(.networkError(SomeError.some)))
                uploadTrackModelsCount += 1
                if uploadTrackModelsCount >= 5 {
                    expectation.fulfill()
                }
            }
        }

        let client = NetworkErrorClientApi()
        let queue = DefaultProcessingQueue(client: client,
                                           flushQueueSize: 2,
                                           flushIntervalMs: 100_000,
                                           retries: retrySettings)

        XCTAssertEqual(client.uploadTrackModelsCount, 0)
        queue.pushTrackModel(testModel)
        queue.pushTrackModel(testModel)
        wait(for: [client.expectation], timeout: Double(retrySettings.maxRetries * retrySettings.delayMaximumMs) / 1000.0)
        XCTAssertEqual(client.uploadTrackModelsCount, 5)
    }
    
    func testQueueRetriesWithInternalError() throws {
        class InternalErrorClientApi: ClientApi {
            var expectation = XCTestExpectation()
            var uploadTrackModelsCount = 0
            
            func uploadTrackModels(_ batch: [TrackModel], completion: @escaping ((Result<Void, ClientApiError>) -> Void)) {
                completion(.failure(.internalError(SomeError.some)))
                uploadTrackModelsCount += 1
                if uploadTrackModelsCount >= 5 {
                    expectation.fulfill()
                }
            }
        }

        let client = InternalErrorClientApi()
        let queue = DefaultProcessingQueue(client: client,
                                           flushQueueSize: 2,
                                           flushIntervalMs: 100_000,
                                           retries: retrySettings)

        XCTAssertEqual(client.uploadTrackModelsCount, 0)
        queue.pushTrackModel(testModel)
        queue.pushTrackModel(testModel)
        let result = XCTWaiter().wait(for: [client.expectation], timeout: Double(retrySettings.maxRetries * retrySettings.delayMaximumMs) / 1000.0)
        XCTAssertEqual(result, .timedOut)
        XCTAssertEqual(client.uploadTrackModelsCount, 1)

    }
    
}
