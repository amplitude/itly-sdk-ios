//
//  QueueRetrySettings.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 21.09.2020.
//

import Foundation

struct QueueRetrySettings {
    let maxRetries: Int
    let delayInitialMs: Int
    let delayMaximumMs: Int
}

extension QueueRetrySettings {
    func calculateDelayMs(_ retry: Int) -> Int {
        let retry = max(1, min(retry,maxRetries))
        let delay = (delayMaximumMs - delayInitialMs) / retry
        return min(delayMaximumMs, max(delayInitialMs, delay))
    }
}
