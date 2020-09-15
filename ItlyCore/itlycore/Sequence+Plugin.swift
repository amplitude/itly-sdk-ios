//
//  Sequence+Plugin.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 15.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

extension Sequence where Element == Plugin {
    func alias(_ userId: String, previousId: String?) {
        self.forEach { plugin in
            plugin.alias(userId, previousId: previousId)
        }
        
        self.forEach { plugin in
            plugin.postAlias(userId, previousId: previousId)
        }
    }
        
    func identify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse], trackInvalid: Bool) {
        if validationResults.valid || trackInvalid {
            self.forEach { plugin in
                plugin.identify(userId, properties: properties)
            }
        }

        self.forEach { plugin in
            plugin.postIdentify(userId, properties: properties, validationResults: validationResults)
        }
    }
        
    func group(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse], trackInvalid: Bool) {
        if validationResults.valid || trackInvalid {
            self.forEach { plugin in
                plugin.group(userId, groupId: groupId, properties: properties)
            }
        }

        self.forEach { plugin in
            plugin.postGroup(userId, groupId: groupId, properties: properties, validationResults: validationResults)
        }
    }
    
    func track(_ userId: String?, event: Event, validationResults: [ValidationResponse], trackInvalid: Bool) {
        if validationResults.valid || trackInvalid {
            self.forEach { plugin in
                plugin.track(userId, event: event)
            }
        }
        
        self.forEach { plugin in
            plugin.postTrack(userId, event: event, validationResults: validationResults)
        }
    }

    func reset() {
        self.forEach { plugin in
            plugin.reset()
        }
    }

    func shutdown() {
        self.forEach { plugin in
            plugin.shutdown()
        }
    }
    
    func flush() {
        self.forEach { plugin in
            plugin.flush()
        }
    }
    
    func validate(_ event: Event) -> [ValidationResponse] {
        return self.map{ plugin in
            plugin.validate(event)
        }
    }
    
    func load(_ options: Options) {
        self.forEach{ plugin in
            plugin.load(options)
        }
    }
}
