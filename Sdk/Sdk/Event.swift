//
//  Event.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 27.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation


@objc public extension Event {
    convenience init(name: String, properties: [String : Any]? = nil, id: String? = nil, version: String? = nil) {
        self.init(name: name, properties: properties, id: id, version: version, metadata: nil)
    }


    @objc func mergeProperties(_ properties: Properties) -> Event {        
        return Event(
            name: self.name,
            properties: self.properties.merging(properties.properties, uniquingKeysWith: { left, right in right }),
            id: self.id,
            version: self.version,
            metadata: self.metadata
        )
    }
}
