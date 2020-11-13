//
//  TrackModel+JSONSerialization.swift
//  ItlyIterativelyPlugin
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

extension Validation {
    var asDict: [String: Any] {
        return [
            "details": details
        ]
    }
}

extension TrackModel {
    var asDict: [String: Any] {
        return [
            "type": type.rawValue,
            "dateSent": dateSent,
            "eventId": eventId ?? NSNull(),
            "eventSchemaVersion": eventSchemaVersion ?? NSNull(),
            "eventName": eventName ?? NSNull(),
            "properties": properties ?? NSNull(),
            "valid": valid,
            "validation": validation.asDict
        ].compactMapValues{ (($0 as? NSNull) != nil) ? nil : $0 }
    }
}
