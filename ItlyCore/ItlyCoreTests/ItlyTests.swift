//
//  ItlyTests.swift
//  ItlyCoreTests
//
//  Created by Konstantin Dorogan on 21.09.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import XCTest
@testable import ItlyCore

class ItlyTests: XCTestCase {

    class CustomPlugin: Plugin {
        var alwaysInvalid = false
        var loadCount = 0
        var aliasCount = 0
        var postAliasCount = 0
        var identityCount = 0
        var postIdentityCount = 0
        var groupCount = 0
        var postGroupCount = 0
        var trackCount = 0
        var postTrackCount = 0
        var resetCount = 0
        var flushCount = 0
        var shutdownCount = 0

        override func load(_ options: Options) {
            super.load(options)
            self.loadCount += 1
        }
        
        override func validate(_ event: Event) -> ValidationResponse {
            return ValidationResponse(valid: !alwaysInvalid)
        }
        
        override func alias(_ userId: String, previousId: String?) {
            self.aliasCount += 1
        }
        override func postAlias(_ userId: String, previousId: String?) {
            self.postAliasCount += 1
        }
        
        override func identify(_ userId: String?, properties: Properties?) {
            self.identityCount += 1
        }
        override func postIdentify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse]) {
            self.postIdentityCount += 1
        }

        override func group(_ userId: String?, groupId: String, properties: Properties?) {
            self.groupCount += 1
        }
        override func postGroup(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse]) {
            self.postGroupCount += 1
        }
        
        override func track(_ userId: String?, event: Event) {
            self.trackCount += 1
        }
        override func postTrack(_ userId: String?, event: Event, validationResults: [ValidationResponse]) {
            self.postTrackCount += 1
        }
        
        override func reset() {
            self.resetCount += 1
        }
        override func flush() {
            self.flushCount += 1
            
        }
        override func shutdown() {
            self.shutdownCount += 1
        }
        
        init() {
            super.init(id: "CustomPluginId")
        }
    }
    
    func testPluginIntegration() throws {
        let plugin = CustomPlugin()
        
        let itlyCore = Itly()
        
        let options = Options(context: nil,
                              environment: .development,
                              disabled: false,
                              plugins: [plugin],
                              validation: nil,
                              logger: nil)
        
        XCTAssertEqual(plugin.id, "CustomPluginId")
        XCTAssertEqual(plugin.loadCount, 0)
        XCTAssertEqual(plugin.aliasCount, 0)
        XCTAssertEqual(plugin.postAliasCount, 0)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 0)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 0)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 0)
        XCTAssertEqual(plugin.resetCount, 0)
        XCTAssertEqual(plugin.flushCount, 0)
        XCTAssertEqual(plugin.shutdownCount, 0)

        itlyCore.load(options)
        itlyCore.alias("", previousId: "")
        itlyCore.identify("", properties: nil)
        itlyCore.group("", groupId: "", properties: nil)
        itlyCore.track("", event: Event(name: ""))
        itlyCore.flush()
        itlyCore.reset()
        itlyCore.shutdown()

        XCTAssertEqual(plugin.loadCount, 1)
        XCTAssertEqual(plugin.aliasCount, 1)
        XCTAssertEqual(plugin.postAliasCount, 1)
        XCTAssertEqual(plugin.identityCount, 1)
        XCTAssertEqual(plugin.postIdentityCount, 1)
        XCTAssertEqual(plugin.groupCount, 1)
        XCTAssertEqual(plugin.postGroupCount, 1)
        XCTAssertEqual(plugin.trackCount, 1)
        XCTAssertEqual(plugin.postTrackCount, 1)
        XCTAssertEqual(plugin.resetCount, 1)
        XCTAssertEqual(plugin.flushCount, 1)
        XCTAssertEqual(plugin.shutdownCount, 1)
    }

    func testDisabledPluginIntegration() throws {
        let plugin = CustomPlugin()
        
        let itlyCore = Itly()
        
        let options = Options(context: nil,
                              environment: .development,
                              disabled: true,
                              plugins: [plugin],
                              validation: nil,
                              logger: nil)
        
        XCTAssertEqual(plugin.id, "CustomPluginId")
        XCTAssertEqual(plugin.loadCount, 0)
        XCTAssertEqual(plugin.aliasCount, 0)
        XCTAssertEqual(plugin.postAliasCount, 0)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 0)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 0)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 0)
        XCTAssertEqual(plugin.resetCount, 0)
        XCTAssertEqual(plugin.flushCount, 0)
        XCTAssertEqual(plugin.shutdownCount, 0)

        itlyCore.load(options)
        itlyCore.alias("", previousId: "")
        itlyCore.identify("", properties: nil)
        itlyCore.group("", groupId: "", properties: nil)
        itlyCore.track("", event: Event(name: ""))
        itlyCore.flush()
        itlyCore.reset()
        itlyCore.shutdown()

        XCTAssertEqual(plugin.loadCount, 0)
        XCTAssertEqual(plugin.aliasCount, 0)
        XCTAssertEqual(plugin.postAliasCount, 0)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 0)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 0)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 0)
        XCTAssertEqual(plugin.resetCount, 0)
        XCTAssertEqual(plugin.flushCount, 0)
        XCTAssertEqual(plugin.shutdownCount, 0)
    }
    
    func testTrackInvalidEnabled() throws {
        let plugin = CustomPlugin()
        
        let validationPlugin = CustomPlugin()
        validationPlugin.alwaysInvalid = true
        
        let itlyCore = Itly()
        let options = Options(context: nil,
                              environment: .development,
                              disabled: false,
                              plugins: [plugin, validationPlugin],
                              validation: ValidationOptions(disabled: false, trackInvalid: true, errorOnInvalid: false),
                              logger: nil)
        
        XCTAssertEqual(plugin.id, "CustomPluginId")
        XCTAssertEqual(plugin.loadCount, 0)
        XCTAssertEqual(plugin.aliasCount, 0)
        XCTAssertEqual(plugin.postAliasCount, 0)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 0)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 0)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 0)
        XCTAssertEqual(plugin.resetCount, 0)
        XCTAssertEqual(plugin.flushCount, 0)
        XCTAssertEqual(plugin.shutdownCount, 0)

        itlyCore.load(options)
        itlyCore.alias("", previousId: "")
        itlyCore.identify("", properties: nil)
        itlyCore.group("", groupId: "", properties: nil)
        itlyCore.track("", event: Event(name: ""))
        itlyCore.flush()
        itlyCore.reset()
        itlyCore.shutdown()

        XCTAssertEqual(plugin.loadCount, 1)
        XCTAssertEqual(plugin.aliasCount, 1)
        XCTAssertEqual(plugin.postAliasCount, 1)
        XCTAssertEqual(plugin.identityCount, 1)
        XCTAssertEqual(plugin.postIdentityCount, 1)
        XCTAssertEqual(plugin.groupCount, 1)
        XCTAssertEqual(plugin.postGroupCount, 1)
        XCTAssertEqual(plugin.trackCount, 1)
        XCTAssertEqual(plugin.postTrackCount, 1)
        XCTAssertEqual(plugin.resetCount, 1)
        XCTAssertEqual(plugin.flushCount, 1)
        XCTAssertEqual(plugin.shutdownCount, 1)
    }
    
    
    func testTrackInvalidDisabled() throws {
        let plugin = CustomPlugin()
        
        let validationPlugin = CustomPlugin()
        validationPlugin.alwaysInvalid = true
        
        let itlyCore = Itly()
        let options = Options(context: nil,
                              environment: .development,
                              disabled: false,
                              plugins: [plugin, validationPlugin],
                              validation: ValidationOptions(disabled: false, trackInvalid: false, errorOnInvalid: false),
                              logger: nil)
        
        XCTAssertEqual(plugin.id, "CustomPluginId")
        XCTAssertEqual(plugin.loadCount, 0)
        XCTAssertEqual(plugin.aliasCount, 0)
        XCTAssertEqual(plugin.postAliasCount, 0)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 0)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 0)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 0)
        XCTAssertEqual(plugin.resetCount, 0)
        XCTAssertEqual(plugin.flushCount, 0)
        XCTAssertEqual(plugin.shutdownCount, 0)

        itlyCore.load(options)
        itlyCore.alias("", previousId: "")
        itlyCore.identify("", properties: nil)
        itlyCore.group("", groupId: "", properties: nil)
        itlyCore.track("", event: Event(name: ""))
        itlyCore.flush()
        itlyCore.reset()
        itlyCore.shutdown()

        XCTAssertEqual(plugin.loadCount, 1)
        XCTAssertEqual(plugin.aliasCount, 1)
        XCTAssertEqual(plugin.postAliasCount, 1)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 1)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 1)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 1)
        XCTAssertEqual(plugin.resetCount, 1)
        XCTAssertEqual(plugin.flushCount, 1)
        XCTAssertEqual(plugin.shutdownCount, 1)
    }
    
    
    func testDisabledValidation() throws {
        let plugin = CustomPlugin()
        
        let validationPlugin = CustomPlugin()
        validationPlugin.alwaysInvalid = true
        
        let itlyCore = Itly()
        let options = Options(context: nil,
                              environment: .development,
                              disabled: false,
                              plugins: [plugin, validationPlugin],
                              validation: ValidationOptions(disabled: true, trackInvalid: false, errorOnInvalid: false),
                              logger: nil)
        
        XCTAssertEqual(plugin.id, "CustomPluginId")
        XCTAssertEqual(plugin.loadCount, 0)
        XCTAssertEqual(plugin.aliasCount, 0)
        XCTAssertEqual(plugin.postAliasCount, 0)
        XCTAssertEqual(plugin.identityCount, 0)
        XCTAssertEqual(plugin.postIdentityCount, 0)
        XCTAssertEqual(plugin.groupCount, 0)
        XCTAssertEqual(plugin.postGroupCount, 0)
        XCTAssertEqual(plugin.trackCount, 0)
        XCTAssertEqual(plugin.postTrackCount, 0)
        XCTAssertEqual(plugin.resetCount, 0)
        XCTAssertEqual(plugin.flushCount, 0)
        XCTAssertEqual(plugin.shutdownCount, 0)

        itlyCore.load(options)
        itlyCore.alias("", previousId: "")
        itlyCore.identify("", properties: nil)
        itlyCore.group("", groupId: "", properties: nil)
        itlyCore.track("", event: Event(name: ""))
        itlyCore.flush()
        itlyCore.reset()
        itlyCore.shutdown()

        XCTAssertEqual(plugin.loadCount, 1)
        XCTAssertEqual(plugin.aliasCount, 1)
        XCTAssertEqual(plugin.postAliasCount, 1)
        XCTAssertEqual(plugin.identityCount, 1)
        XCTAssertEqual(plugin.postIdentityCount, 1)
        XCTAssertEqual(plugin.groupCount, 1)
        XCTAssertEqual(plugin.postGroupCount, 1)
        XCTAssertEqual(plugin.trackCount, 1)
        XCTAssertEqual(plugin.postTrackCount, 1)
        XCTAssertEqual(plugin.resetCount, 1)
        XCTAssertEqual(plugin.flushCount, 1)
        XCTAssertEqual(plugin.shutdownCount, 1)
    }
    
    func testContext() throws {
        class TestContextPlugin: Plugin {
            var trackCounter = 0
            var postTrackCounter = 0
            
            override func track(_ userId: String?, event: Event) {
                trackCounter += 1
                XCTAssertEqual(event.name, "test")
                XCTAssertEqual(event.properties["eventProperty"] as! String, "eventPropertyVal")
                XCTAssertEqual(event.properties["contextProperty"] as! String, "contextPropertyVal")
            }
            
            override func postTrack(_ userId: String?, event: Event, validationResults: [ValidationResponse]) {
                postTrackCounter += 1
                XCTAssertEqual(event.name, "test")
                XCTAssertEqual(event.properties["eventProperty"] as! String, "eventPropertyVal")
                XCTAssertEqual(event.properties["contextProperty"] as! String, "contextPropertyVal")
            }
            
            init() {
                super.init(id: "TestContextPlugin")
            }
        }
        

        let plugin = TestContextPlugin()
        let itlyCore = Itly()
        let options = Options(context: ["contextProperty": "contextPropertyVal"],
                              environment: .development,
                              disabled: false,
                              plugins: [plugin],
                              validation: ValidationOptions(disabled: true, trackInvalid: false, errorOnInvalid: false),
                              logger: nil)
        
        XCTAssertEqual(plugin.id, "TestContextPlugin")
        XCTAssertEqual(plugin.trackCounter, 0)
        XCTAssertEqual(plugin.postTrackCounter, 0)

        itlyCore.load(options)
        itlyCore.track("", event: Event(name: "test", properties: ["eventProperty": "eventPropertyVal"]))

        XCTAssertEqual(plugin.trackCounter, 1)
        XCTAssertEqual(plugin.postTrackCounter, 1)
    }
    
}
