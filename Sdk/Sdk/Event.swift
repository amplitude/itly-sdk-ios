//
//  Event.swift
//  ItlyCore
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

import Foundation

@objc public extension Event {
    convenience init(name: String) {
        self.init(name: name, propertiesDict: nil, id: nil, version: nil, metadata: nil)
    }

    convenience init(name: String, id: String? = nil, version: String? = nil) {
        self.init(name: name, propertiesDict: nil, id: id, version: version, metadata: nil)
    }

    convenience init(name: String, properties: Properties?, id: String? = nil, version: String? = nil) {
        self.init(name: name, propertiesDict: properties?.properties, id: id, version: version, metadata: nil)
    }

    @objc func mergeProperties(_ properties: Properties) -> Event {
        return Event(
            name: self.name,
            propertiesDict: self.properties.merging(properties.properties, uniquingKeysWith: { left, right in right }),
            id: self.id,
            version: self.version,
            metadata: self.metadata
        )
    }
}

public extension Event {
    convenience init(name: String, optionalDict: [String: Any?]?, id: String? = nil, version: String? = nil, metadata: EventMetadata? = nil) {
        self.init(name: name,
                  propertiesDict: Properties.compact(optionalDict),
                  id: id,
                  version: version,
                  metadata: metadata)
    }
}
