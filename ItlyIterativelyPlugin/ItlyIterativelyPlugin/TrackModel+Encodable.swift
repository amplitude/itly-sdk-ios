//
//  TrackModel+Encodable.swift
//  ItlyIterativelyPlugin
//
//  Created by Konstantin Dorogan on 21.09.2020.
//

import Foundation

fileprivate enum CodingKeys: String, CodingKey {
    case type, dateSent, eventId, eventSchemaVersion, eventName, properties, valid, validation
}

fileprivate struct EncodableWrapper: Encodable {
    let wrapped: Encodable

    func encode(to encoder: Encoder) throws {
        try self.wrapped.encode(to: encoder)
    }
}

extension TrackModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(type, forKey: .type)
        try c.encodeIfPresent(dateSent, forKey: .dateSent)
        try c.encodeIfPresent(eventId, forKey: .eventId)
        try c.encodeIfPresent(eventSchemaVersion, forKey: .eventSchemaVersion)
        try c.encodeIfPresent(eventName, forKey: .eventName)
        try c.encodeIfPresent(properties?.compactMapValues{ ($0 as? Encodable).map{ EncodableWrapper(wrapped: $0) } }, forKey: .properties)
        try c.encodeIfPresent(valid, forKey: .valid)
        try c.encodeIfPresent(validation, forKey: .validation)
    }
}
