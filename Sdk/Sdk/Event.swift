//
//  Event.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 27.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc (ITLEvent) open class Event: NSObject, Properties {
    public let name: String
    public let properties: [String : Any]
    public let metadata: EventMetadata
    public let id: String?
    public let version: String?

    public init(name: String, properties: [String : Any]? = nil, id: String? = nil, version: String? = nil, metadata: EventMetadata? = nil) {
        self.name = name
        self.id = id
        self.version = version
        self.properties = properties ?? [:]
        self.metadata = metadata ?? [:]
    }
}

public extension Event {
    func mergeProperties(_ properties: Properties) -> Event {
        return Event(
            name: self.name,
            properties: self.properties.merging(properties.properties, uniquingKeysWith: { left, right in right }),
            id: self.id,
            version: self.version,
            metadata: self.metadata
        )
    }
}
