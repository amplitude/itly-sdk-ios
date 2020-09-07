//
//  ItlyAmplitudePlugin.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 03.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation
import Amplitude
import ItlyCore

public class ItlyAmplitudePlugin: NSObject, ItlyPlugin, ItlyDestination {
    private var amplitudeClient: Amplitude?
    private var logger: ItlyLogger?
    private let apiKey: String
    
    public func didPlugIntoInstance(_ instance: ItlyCoreApi) throws {
        self.logger = instance.logger
        logger?.debug("ItlyAmplitudePlugin load")
        
        self.amplitudeClient = Amplitude.instance()
        amplitudeClient?.initializeApiKey(apiKey)
    }
    
    public func reset() throws {
        logger?.debug("ItlyAmplitudePlugin reset")
        amplitudeClient?.setUserId(nil, startNewSession: true)
    }
    
    public func flush() throws {
        // do nothing
    }
    
    public func shutdown() throws {
        // do nothing
    }
    
    public func alias(_ userId: String, previousId: String?) throws {
        // do nothing
    }
    
    public func group(_ userId: String?, groupId: String, properties: ItlyProperties?) throws {
        // do nothing
    }

    
    public func identify(_ userId: String?, properties: ItlyProperties?) throws {
        logger?.debug("ItlyAmplitudePlugin identify(userId=\(userId), properties=\(properties?.properties)")
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
        
    public func track(_ userId: String?, event: ItlyEvent) throws {
        logger?.debug("ItlyAmplitudePlugin track(userId = \(userId) event=\(event.name) properties=\(event.properties)")
        amplitudeClient?.logEvent(event.name, withEventProperties: event.properties)
    }
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        super.init()
    }
}
