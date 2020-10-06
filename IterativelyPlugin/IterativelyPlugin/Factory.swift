//
//  Factory.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 21.09.2020.
//

import Foundation

protocol ProcessingQueueFactory {
    func createProcessingQueue() throws -> ProcessingQueue
}

protocol ClientApiFactory {
    func createClientApi() throws -> ClientApi
}

protocol TrackModelBuilderFactory {
    func createTrackModelBuilder() throws -> TrackModelBuilder
}


struct MainFactory {
    let config: IterativelyOptions
    let apiKey: String
}

extension MainFactory: TrackModelBuilderFactory {
    func createTrackModelBuilder() throws -> TrackModelBuilder {
        return DefaultTrackModelBuilder(dateFormatter: ISO8601DateFormatter(), omitValues: config.omitValues)
    }
}

extension MainFactory: ClientApiFactory {
    func createClientApi() throws -> ClientApi {
        return DefaultClientApi(baseUrl: URL(string: config.url)!,
                                apiKey: apiKey)
    }
}

extension MainFactory: ProcessingQueueFactory {
    func createProcessingQueue() throws -> ProcessingQueue {
        let clientApi = try createClientApi()
        
        return DefaultProcessingQueue(client: clientApi,
                                      flushQueueSize: config.flushQueueSize,
                                      flushIntervalMs: config.flushIntervalMs,
                                      retries: QueueRetrySettings(maxRetries: config.maxRetries,
                                                                  delayInitialMs: config.delayInitialMillis,
                                                                  delayMaximumMs: config.delayMaximumMillis))
    }
}
