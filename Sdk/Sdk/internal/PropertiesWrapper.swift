//
//  PropertiesWrapper.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 21.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

class PropertiesWrapper: Properties {
    var properties: [String : Any]
    
    init(properties: [String : Any]) {
        self.properties = properties
    }
}
