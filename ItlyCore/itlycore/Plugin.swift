//
//  Plugin.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 24.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc open class Plugin: NSObject {
    private let pluginId: String
    
    open var id: String { self.pluginId }
    
    open func load(_ options: Options) {}

    open func validate(_ event: Event) -> ValidationResponse {
        return ValidationResponse(valid: true)
    }

    open func alias(_ userId: String, previousId: String?) {}
    open func postAlias(_ userId: String, previousId: String?) {}
    
    open func identify(_ userId: String?, properties: Properties?) {}
    open func postIdentify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse]) {}

    open func group(_ userId: String?, groupId: String, properties: Properties?) {}
    open func postGroup(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse]) {}
    
    open func track(_ userId: String?, event: Event) {}
    open func postTrack(_ userId: String?, event: Event, validationResults: [ValidationResponse]) {}
    
    open func reset() {}
    open func flush() {}
    open func shutdown() {}

    public init(id: String) {
        self.pluginId = id
        super.init()
    }
}
