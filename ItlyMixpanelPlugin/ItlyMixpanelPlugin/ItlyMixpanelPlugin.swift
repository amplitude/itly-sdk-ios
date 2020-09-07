//
//  ItlyMixpanelPlugin.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import Mixpanel
import ItlyCore

public class ItlyMixpanelPlugin: NSObject, ItlyPlugin, ItlyDestination {
    private var mixpanelClient: MixpanelInstance!
    private var logger: ItlyLogger?
    private var token: String
    
    public func didPlugIntoInstance(_ instance: ItlyCoreApi) throws {
        self.logger = instance.logger
        logger?.debug("ItlyMixpanelPlugin load")
        self.mixpanelClient = Mixpanel.initialize(token: token)
    }
    
    public func reset() throws {
        logger?.debug("ItlyMixpanelPlugin reset")
        mixpanelClient?.reset()
    }
    
    public func flush() throws {
        // do nothing
    }
    
    public func shutdown() throws {
        // do nothing
    }
    
    public func alias(_ userId: String, previousId: String?) throws {
        logger?.debug("ItlyMixpanelPlugin alias(userId=\(userId) previousId=\(previousId))")
        mixpanelClient?.createAlias(userId, distinctId: previousId ?? mixpanelClient.distinctId)
    }
    
    public func identify(_ userId: String?, properties: ItlyProperties?) throws {
        logger?.debug("ItlyMixpanelPlugin identify(userId=\(userId), properties=\(properties?.properties))")
        guard let userId = userId else {
            return
        }
        
        mixpanelClient?.identify(distinctId: userId)
        mixpanelClient?.identify(distinctId: userId, usePeople: true)
        if let properties = properties?.properties {
            mixpanelClient?.people.set(properties: properties.compactMapValues{ $0 as? MixpanelType })
        }
    }
    
    public func group(_ userId: String?, groupId: String, properties: ItlyProperties?) throws {
        // do nothing
    }
    
    public func track(_ userId: String?, event: ItlyEvent) throws {
        logger?.debug("ItlyMixpanelPlugin track(userId = \(userId), event=\(event.name) properties=\(event.properties))")
        
        mixpanelClient?.track(event: event.name, properties: event.properties.compactMapValues{ $0 as? MixpanelType })
    }
    
    public init(token: String) {
        self.token = token
        super.init()
    }
}
