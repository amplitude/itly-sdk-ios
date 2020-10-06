//
//  ItlyMixpanelPlugin.swift
//  ItlyMixpanelPlugin
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import Mixpanel
import ItlySdk

public class ItlyMixpanelPlugin: Plugin {
    private var mixpanelClient: MixpanelInstance!
    private weak var logger: Logger?
    private var token: String
    
    public init(token: String) {
        self.token = token
        super.init(id: "ItlyMixpanelPlugin")
    }

    public override func load(_ options: Options)  {
        super.load(options)
        
        self.logger = options.logger
        logger?.debug("\(self.id) load")
        self.mixpanelClient = Mixpanel.initialize(token: token)
    }
    
    public override func reset() {
        super.reset()
        
        logger?.debug("\(self.id) reset")
        mixpanelClient?.reset()
    }
        
    public override func alias(_ userId: String, previousId: String?) {
        super.alias(userId, previousId: previousId)
        
        logger?.debug("\(self.id) alias(userId=\(userId) previousId=\(previousId ?? ""))")
        mixpanelClient?.createAlias(userId, distinctId: previousId ?? mixpanelClient.distinctId)
    }
    
    public override func identify(_ userId: String?, properties: ItlyCore.Properties?) {
        super.identify(userId, properties: properties)
        
        logger?.debug("\(self.id) identify(userId=\(userId ?? ""), properties=\(properties?.properties ?? [:]))")
        guard let userId = userId else {
            return
        }
        
        mixpanelClient?.identify(distinctId: userId)
        mixpanelClient?.identify(distinctId: userId, usePeople: true)
        if let properties = properties?.properties {
            mixpanelClient?.people.set(properties: properties.compactMapValues{ $0 as? MixpanelType })
        }
    }
    
    public override func track(_ userId: String?, event: Event) {
        super.track(userId, event: event)
        
        logger?.debug("\(self.id) track(userId = \(userId ?? ""), event=\(event.name) properties=\(event.properties))")
        
        mixpanelClient?.track(event: event.name, properties: event.properties.compactMapValues{ $0 as? MixpanelType })
    }
}
