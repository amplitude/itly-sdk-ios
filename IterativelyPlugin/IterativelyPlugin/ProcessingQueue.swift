//
//  ItlyQueue.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 18.09.2020.
//

import Foundation
import ItlySdk

protocol ProcessingQueue {
    func pushTrackModel(_ model: TrackModel)
    func flush()
}

class DefaultProcessingQueue {
    private let flushQueueSize: Int
    private let retries: QueueRetrySettings
    private let queue: DispatchQueue
    private let client: ClientApi
    private var pendingItems: [TrackModel] = []
    private let logger: Logger?
    
    private func _pushTrackModel(_ model: TrackModel) {
        pendingItems.append(model)

        if pendingItems.count >= flushQueueSize {
            // send the client
            _flush()
        }
    }
    
    private func _flush() {
        logger?.debug("ItlyIterativelyPlugin: Flush")
        let itemsToUpload = pendingItems
        pendingItems = []
        _uploadItems(itemsToUpload, maxAttempts: retries.maxRetries)
    }
    
    private func _uploadItems(_ items: [TrackModel], maxAttempts: Int) {
        guard items.count > 0 else {
            // nothing to send
            logger?.debug("ItlyIterativelyPlugin: Requested sending an empty list.")
            return
        }
        
        guard maxAttempts > 0 else {
            // failed to send
            logger?.debug("ItlyIterativelyPlugin: Failed to upload \(items.count) events. Maximum attempts exceeded.")
            return
        }
        
        let retries = self.retries
        let logger = self.logger
        client.uploadTrackModels(items) { [weak self] result in
            self?.queue.async {
                switch(result) {
                case .failure(let error):
                    logger?.debug("ItlyIterativelyPlugin: Failed to upload (\(error.localizedDescription))")
                    if error.shouldRetry {
                        let delay = retries.calculateDelayMs(maxAttempts)
                        logger?.debug("ItlyIterativelyPlugin: Retry upload (delay=\(delay) ms).")
                        self?.queue.asyncAfter(deadline: .now() + .milliseconds(delay)) {
                            self?._uploadItems(items, maxAttempts: maxAttempts - 1)
                        }
                    }
                case .success:
                    logger?.debug("ItlyIterativelyPlugin: Upload complete")
                }
            }
        }
    }

    private func scheduleFlushInterval(_ flushIntervalMs: Int) {
        logger?.debug("ItlyIterativelyPlugin: Scheduled autoflush (delay=\(flushIntervalMs) ms).")
        queue.asyncAfter(deadline: .now() + .milliseconds(flushIntervalMs)) { [weak self] in
            self?._flush()
            self?.scheduleFlushInterval(flushIntervalMs)
        }
    }
    
    init(client: ClientApi,
         flushQueueSize: Int,
         flushIntervalMs: Int,
         retries: QueueRetrySettings,
         logger: Logger? = nil,
         queue: DispatchQueue = DispatchQueue(label: "DefaultProcessingQueue", qos: .background)) {
        self.queue = queue
        self.client = client
        self.flushQueueSize = flushQueueSize
        self.retries = retries
        self.logger = logger
        
        scheduleFlushInterval(flushIntervalMs)
    }
}


extension DefaultProcessingQueue: ProcessingQueue {
    func pushTrackModel(_ model: TrackModel) {
        queue.async {
            self._pushTrackModel(model)
        }
    }
    
    func flush() {
        queue.async {
            self._flush()
        }
    }
}

fileprivate extension ClientApiError {
    var shouldRetry: Bool {
        switch self {
        case .networkError:
            return true
        case .serverError:
            return true
        case .internalError:
            return false
        }
    }
}
