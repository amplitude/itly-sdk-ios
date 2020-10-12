//
//  PluginProtocol+Safe.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 06.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

extension Plugin {
    func safeLoad(_ options: Options) throws {
        try ObjC.catchException {
            self.load(options)
        }
    }
    
    func safeAlias(_ userId: String, previousId: String?) throws {
        try ObjC.catchException {
            self.alias(userId, previousId: previousId)
        }
    }
    
    func safePostAlias(_ userId: String, previousId: String?) throws {
        try ObjC.catchException {
            self.postAlias(userId, previousId: previousId)
        }
    }
    
    func safeIdentify(_ userId: String?, properties: Properties?) throws {
        try ObjC.catchException {
            self.identify(userId, properties: properties)
        }
    }
    func safePostIdentify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse]) throws {
        try ObjC.catchException {
            self.postIdentify(userId, properties: properties, validationResults: validationResults)
        }
    }

    func safeGroup(_ userId: String?, groupId: String, properties: Properties?) throws {
        try ObjC.catchException {
            self.group(userId, groupId: groupId, properties: properties)
        }
    }
    func safePostGroup(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse]) throws {
        try ObjC.catchException {
            self.postGroup(userId, groupId: groupId, properties: properties, validationResults: validationResults)
        }
    }
    
    func safeTrack(_ userId: String?, event: Event) throws {
        try ObjC.catchException {
            self.track(userId, event: event)
        }
    }
    func safePostTrack(_ userId: String?, event: Event, validationResults: [ValidationResponse]) throws {
        try ObjC.catchException {
            self.postTrack(userId, event: event, validationResults: validationResults)
        }
    }
    
    func safeReset() throws {
        try ObjC.catchException {
            self.reset()
        }
    }
    func safeFlush() throws {
        try ObjC.catchException {
            self.flush()
        }
    }
    func safeShutdown() throws {
        try ObjC.catchException {
            self.shutdown()
        }
    }
    
    func safeValidate(_ event: Event) throws -> ValidationResponse {
        var result: ValidationResponse!
        
        try ObjC.catchException {
            result = self.validate(event)
        }
        return result
    }
}
