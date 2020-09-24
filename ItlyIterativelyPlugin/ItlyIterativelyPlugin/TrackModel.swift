//
//  TrackModel.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 18.09.2020.
//

import Foundation
import ItlyCore

enum TrackType: String {
    case group, identify, track
}

struct Validation {
    var details: String
}

extension TrackType: Encodable {}
extension Validation: Encodable {}

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
