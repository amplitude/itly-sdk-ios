//
//  PluginManager.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 01.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

protocol PluginManager {
    var plugins: [String: ItlyPlugin] { get }
    
    func didPlugIntoInstance(_ instance: ItlyCoreApi) throws
    
    func reset() throws
    func flush() throws
    func shutdown() throws
}

class DefaultPluginManager  {
    private let logger: ItlyLogger?
    let plugins: [String: ItlyPlugin]
    
    func reset() throws {
        plugins.forEach { pluginId, plugin in
            do {
                try plugin.reset()
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(pluginId).reset(): \(error.localizedDescription)")
            }
        }
    }
    
    func flush() throws {
        plugins.forEach { pluginId, plugin in
            do {
                try plugin.reset()
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(pluginId).flush(): \(error.localizedDescription)")
            }
        }
    }
    
    func shutdown() throws {
        plugins.forEach { pluginId, plugin in
            do {
                try plugin.reset()
            } catch (let error) {
                logger?.error("$LOG_TAG Error in \(pluginId).shutdown(): \(error.localizedDescription)")
            }
        }
    }

    func didPlugIntoInstance(_ instance: ItlyCoreApi) throws {
        logger?.debug("$LOG_TAG load")
        logger?.debug("$LOG_TAG \(plugins.count) plugins are enabled")
        
        plugins.forEach { pluginId, plugin in
            do {
                try plugin.didPlugIntoInstance(instance)
            } catch (let error) {
                self.logger?.error("$LOG_TAG Error in \(pluginId).didPlugIntoInstance(): \(error.localizedDescription)")
            }
        }
        
        // TODO: if we have an error on plugin loading we can't use that plugin
    }

    
    init(plugins: [String: ItlyPlugin],
         logger: ItlyLogger?
    ) {
        self.logger = logger
        self.plugins = plugins
    }
}

extension DefaultPluginManager: PluginManager {
    
}
