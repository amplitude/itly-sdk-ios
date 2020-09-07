//
//  ItlySegmentPlugin.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import Analytics
import ItlyCore


public class ItlySegmentPlugin: NSObject, ItlyPlugin, ItlyDestination {
    private var segmentClient: Analytics?
    private var logger: ItlyLogger?
    private var writeKey: String
    
    public func didPlugIntoInstance(_ instance: ItlyCoreApi) throws {
        self.logger = instance.logger
        logger?.debug("ItlySegmentPlugin load")
        
        Analytics.setup(with: AnalyticsConfiguration(writeKey: writeKey))
        self.segmentClient = Analytics.shared()
    }
    
    public func reset() throws {
        logger?.debug("ItlySegmentPlugin reset")
        segmentClient?.reset()
    }
    
    public func flush() throws {
        logger?.debug("ItlySegmentPlugin flush")
        segmentClient?.flush()
    }
    
    public func shutdown() throws {
        logger?.debug("ItlySegmentPlugin shutdown")
    }
    
    public func alias(_ userId: String, previousId: String?) throws {
        logger?.debug("ItlySegmentPlugin alias(userId=\(userId) previousId=\(previousId))")
        segmentClient?.alias(userId)
    }
    
    public func identify(_ userId: String?, properties: ItlyProperties?) throws {
        logger?.debug("ItlySegmentPlugin identify(userId=\(userId), properties=\(properties?.properties))")
        guard let userId = userId else {
            return
        }

        segmentClient?.identify(userId, traits: properties?.properties)
    }
    
    public func group(_ userId: String?, groupId: String, properties: ItlyProperties?) throws {
        logger?.debug("ItlySegmentPlugin group(userId = \(userId), groupdId=\(groupId) properties=\(properties?.properties))")
        segmentClient?.group(groupId, traits: properties?.properties)
    }
    
    public func track(_ userId: String?, event: ItlyEvent) throws {
        logger?.debug("ItlySegmentPlugin track(userId = \(userId), event=\(event.name) properties=\(event.properties))")
        segmentClient?.track(event.name, properties: event.properties)
    }
    
    public init(writeKey: String) {
        self.writeKey = writeKey
        super.init()
    }
}
