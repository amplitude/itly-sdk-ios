//
//  Sequence+PluginProtocol.swift
//  ItlyCore
//
//  Created by Konstantin Dorogan on 15.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

extension Sequence where Element == Plugin {
    func alias(_ userId: String, previousId: String?, options: Options) {
        self.forEach { plugin in
            do {
                try plugin.safeAlias(userId, previousId: previousId)
            } catch {
                // handle error
                options.logger?.error("Itly Error in \(plugin.id).alias(): \(error.localizedDescription).")
            }
        }
        
        self.forEach { plugin in
            do {
                try plugin.safePostAlias(userId, previousId: previousId)
            } catch {
                // handle error
                options.logger?.error("Itly Error in \(plugin.id).postAlias(): \(error.localizedDescription).")
            }
        }
    }
        
    func identify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse], options: Options) {
        if validationResults.valid || options.validation.trackInvalid {
            self.forEach { plugin in
                do {
                    try plugin.safeIdentify(userId, properties: properties)
                } catch {
                    options.logger?.error("Itly Error in \(plugin.id).identify(): \(error.localizedDescription).")
                }
            }
        }

        self.forEach { plugin in
            do {
                try plugin.safePostIdentify(userId, properties: properties, validationResults: validationResults)
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).postIdentify(): \(error.localizedDescription).")
            }
        }
    }
        
    func group(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse], options: Options) {
        if validationResults.valid || options.validation.trackInvalid {
            self.forEach { plugin in
                do {
                    try plugin.safeGroup(userId, groupId: groupId, properties: properties)
                } catch {
                    options.logger?.error("Itly Error in \(plugin.id).group(): \(error.localizedDescription).")
                }
            }
        }

        self.forEach { plugin in
            do {
                try plugin.safePostGroup(userId, groupId: groupId, properties: properties, validationResults: validationResults)
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).postGroup(): \(error.localizedDescription).")
            }
        }
    }
    
    func track(_ userId: String?, event: Event, validationResults: [ValidationResponse], options: Options) {
        if validationResults.valid || options.validation.trackInvalid {
            self.forEach { plugin in
                do {
                    try plugin.safeTrack(userId, event: event)
                } catch {
                    options.logger?.error("Itly Error in \(plugin.id).track(): \(error.localizedDescription).")
                }
            }
        }
        
        self.forEach { plugin in
            do {
                try plugin.safePostTrack(userId, event: event, validationResults: validationResults)
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).postTrack(): \(error.localizedDescription).")
            }
        }
    }

    func reset(options: Options) {
        self.forEach { plugin in
            do {
                try plugin.safeReset()
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).reset(): \(error.localizedDescription).")
            }
        }
    }

    func shutdown(options: Options) {
        self.forEach { plugin in
            do {
                try plugin.safeShutdown()
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).shutdown(): \(error.localizedDescription).")
            }
        }
    }
    
    func flush(options: Options) {
        self.forEach { plugin in
            do {
                try plugin.safeFlush()
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).flush(): \(error.localizedDescription).")
            }
        }
    }
    
    func validate(_ event: Event, options: Options) -> [ValidationResponse] {
        return self.compactMap{ plugin -> ValidationResponse? in
            var result: ValidationResponse?
            do {
                result = try plugin.safeValidate(event)
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).validate(): \(error.localizedDescription).")
            }
            return result
        }
    }
    
    func load(_ options: Options) {
        self.forEach{ plugin in
            do {
                try plugin.safeLoad(options)
            } catch {
                options.logger?.error("Itly Error in \(plugin.id).load(): \(error.localizedDescription).")
            }
        }
    }
}
