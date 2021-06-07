//
//  TrackModelBuilder.swift
//  ItlyIterativelyPlugin
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation
import ItlySdk

protocol TrackModelBuilder {
    func buildTrackModelForType(
        _ type: TrackType, event: Event?, properties: Properties?, validation: ValidationResponse?
    ) -> TrackModel
}

extension TrackModelBuilder {
    func buildTrackModelForType(
        _ type: TrackType, event: Event? = nil, properties: Properties? = nil, validation: ValidationResponse? = nil
    ) -> TrackModel{
        return self.buildTrackModelForType(type, event: event, properties: properties, validation: validation)
    }

}

protocol TrackModelDateFormatter {
    func string(from date: Date) -> String
}

class DefaultTrackModelBuilder: TrackModelBuilder {
    private let dateFormatter: TrackModelDateFormatter
    private let omitValues: Bool

    func buildTrackModelForType(
        _ type: TrackType,
        event: Event?,
        properties: Properties?,
        validation: ValidationResponse?
    ) -> TrackModel {
        return TrackModel(
            type: type,
            messageId: UUID().uuidString,
            dateSent: dateFormatter.string(from: Date()),
            eventId: event?.id,
            eventSchemaVersion: event?.version,
            eventName: event?.name,
            properties: omitValues
                ? properties?.sanitizedProperties
                : properties?.properties,
            valid: validation?.valid ?? true,
            validation: Validation(details: omitValues
                ? ""
                : validation?.message ?? ""
            )
        )
    }

    init(dateFormatter: TrackModelDateFormatter, omitValues: Bool) {
        self.omitValues = omitValues
        self.dateFormatter = dateFormatter
    }
}


extension Properties {
    var sanitizedProperties: [String: Any] {
        return self.properties.mapValues{ _ in NSNull() }
    }
}
