//
//  ItlyAmplitudePlugin.swift
//  ItlyAmplitudePlugin
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import Amplitude
import ItlySdk

public class ItlyAmplitudePlugin: Plugin {
    private var amplitudeClient: Amplitude?
    private weak var logger: Logger?
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        super.init(id: "ItlyAmplitudePlugin")
    }

    public override func load(_ options: Options) {
        super.load(options)

        self.logger = options.logger
        logger?.debug("\(self.id) load")
        
        self.amplitudeClient = Amplitude.instance()
        amplitudeClient?.initializeApiKey(apiKey)
    }
    
    public override func reset() {
        super.reset()
        
        logger?.debug("\(self.id) reset")
        amplitudeClient?.setUserId(nil, startNewSession: true)
    }

    public override func identify(_ userId: String?, properties: Properties?) {
        super.identify(userId, properties: properties)

        logger?.debug("\(self.id) identify(userId=\(userId ?? ""), properties=\(properties?.properties ?? [:])")
        if userId != nil {
            amplitudeClient?.setUserId(userId, startNewSession: true)
        }
        
        let identifyArgs = AMPIdentify()
        properties?.properties.compactMap { key, value -> (key: String, value: NSObject)? in
            let nsValue = value as? NSObject
            return nsValue == nil ? nil : (key, nsValue!)
        }.forEach{ key, value in
            identifyArgs.set(key, value: value)
        }
        
        amplitudeClient?.identify(identifyArgs)
    }

    public override func track(_ userId: String?, event: Event) {
        super.track(userId, event: event)
        
        logger?.debug("\(self.id) track(userId = \(userId ?? "") event=\(event.name) properties=\(event.properties)")
        amplitudeClient?.logEvent(event.name, withEventProperties: event.properties)
    }
}
