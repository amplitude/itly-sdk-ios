//
//  Logger.swift
//  ItlyCore
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

@objc (ITLLogger) public protocol Logger {
    func debug(_ message: String)
    func info(_ message: String)
    func warn(_ message: String)
    func error(_ message: String)
}
