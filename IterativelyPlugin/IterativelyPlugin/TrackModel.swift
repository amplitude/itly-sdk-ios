//
//  TrackModel.swift
//  ItlyIterativelyPlugin
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation
import ItlySdk

enum TrackType: String {
    case group, identify, track
}

struct Validation {
    var details: String
}

struct TrackModel {
    var type: TrackType
    var dateSent: String
    var eventId: String?
    var eventSchemaVersion: String?
    var eventName: String?
    // FIXME: properties aren't optional in JS/TS
    var properties: [String: Any]?
    var valid: Bool
    var validation: Validation
}
