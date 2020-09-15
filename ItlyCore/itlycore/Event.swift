//
//  Event.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 27.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public class Event: NSObject, Properties {
    public let name: String
    public let properties: [String : Any]
    public let metadata: EventMetadata
    public var id: String? { properties["id"] as? String }
    public var version: String? { properties["version"] as? String }

    init(name: String, id: String? = nil, version: String? = nil, properties: [String : Any]? = nil, metadata: EventMetadata? = nil) {
        self.name = name
        
        var props = properties ?? [:]
        if let id = id {
            props["id"] = id
        }
        if let version = version {
            props["version"] = version
        }
        
        self.properties = props
        self.metadata = metadata ?? [:]
    }
}

public extension Event {
    func mergeProperties(_ properties: Properties) -> Event {
        return Event(
            name: self.name,
            id: self.id,
            version: self.version,
            properties: self.properties.merging(properties.properties, uniquingKeysWith: { left, right in right }),
            metadata: self.metadata
        )
    }
}
