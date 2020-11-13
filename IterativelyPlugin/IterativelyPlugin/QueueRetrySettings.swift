//
//  QueueRetrySettings.swift
//  ItlyIterativelyPlugin
//
//  Copyright © 2020 Iteratively. All rights reserved.
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
