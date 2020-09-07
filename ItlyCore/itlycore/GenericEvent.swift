//
//  GenericEvent.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 27.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

class GenericEvent: NSObject, ItlyEvent {
    let name: String
    let properties: [String : Any]
    var id: String? { properties["id"] as? String }
    var version: String? { properties["version"] as? String }
    
    init(name: String, id: String? = nil, version: String? = nil, properties: [String : Any]? = nil) {
        self.name = name
        
        var props = properties ?? [:]
        if let id = id {
            props["id"] = id
        }
        if let version = version {
            props["version"] = version
        }
        
        self.properties = props
    }
}
