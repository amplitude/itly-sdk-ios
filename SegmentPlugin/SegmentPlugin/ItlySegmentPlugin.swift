//
//  ItlySegmentPlugin.swift
//  ItlySegmentPlugin
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import Analytics
import ItlySdk

public class ItlySegmentPlugin: Plugin {
    private var segmentClient: Analytics?
    private weak var logger: Logger?
    private var writeKey: String
    
    public init(writeKey: String) {
        self.writeKey = writeKey
        super.init(id: "ItlySegmentPlugin")
    }

    public override func load(_ options: Options) {
        super.load(options)
        
        self.logger = options.logger
        logger?.debug("\(self.id) load")
        
        Analytics.setup(with: AnalyticsConfiguration(writeKey: writeKey))
        self.segmentClient = Analytics.shared()
    }

    public override func reset() {
        super.reset()
        logger?.debug("\(self.id) reset")
        segmentClient?.reset()
    }

    public override func flush() {
        super.flush()
        
        logger?.debug("\(self.id) flush")
        segmentClient?.flush()
    }
    
    public override func shutdown() {
        logger?.debug("\(self.id) shutdown")
    }
    
    public override func alias(_ userId: String, previousId: String?) {
        super.alias(userId, previousId: previousId)
        
        logger?.debug("\(self.id) alias(userId=\(userId) previousId=\(previousId ?? ""))")
        segmentClient?.alias(userId)
    }
    
    public override func identify(_ userId: String?, properties: Properties?) {
        super.identify(userId, properties: properties)
        
        logger?.debug("\(self.id) identify(userId=\(userId ?? ""), properties=\(properties?.properties ?? [:]))")
        guard let userId = userId else {
            return
        }

        segmentClient?.identify(userId, traits: properties?.properties)
    }
    
    public override func group(_ userId: String?, groupId: String, properties: Properties?) {
        super.group(userId, groupId: groupId, properties: properties)
        
        logger?.debug("\(self.id) group(userId = \(userId ?? ""), groupdId=\(groupId) properties=\(properties?.properties ?? [:]))")
        segmentClient?.group(groupId, traits: properties?.properties)
    }
    
    public override func track(_ userId: String?, event: Event) {
        super.track(userId, event: event)
        
        logger?.debug("\(self.id) track(userId = \(userId ?? ""), event=\(event.name) properties=\(event.properties))")
        segmentClient?.track(event.name, properties: event.properties)
    }
}
