//
//  IterativelyPlugin.swift
//  IterativelyPlugin
//
//  Created by Konstantin Dorogan on 18.09.2020.
//

import Foundation
import ItlySdk


public class IterativelyPlugin: Plugin {
    private let factory: ProcessingQueueFactory
    private let trackModelBuilder: TrackModelBuilder
    private var queue: ProcessingQueue?
    
    public init(apiKey: String, config: IterativelyOptions) throws {
        let mainFactory = MainFactory(config: config, apiKey: apiKey)
        self.factory = mainFactory
        self.trackModelBuilder = try mainFactory.createTrackModelBuilder()
        super.init(id: "IterativelyPlugin")
    }

    public override func load(_ options: Options) {
        super.load(options)
        
        do {
            queue = try factory.createProcessingQueue()
        } catch {
            options.logger?.error("Error on createProcessingQueue(): \(error.localizedDescription)")
        }
    }
    
    public override func postGroup(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse]) {
        super.postGroup(userId, groupId: groupId, properties: properties, validationResults: validationResults)
        
        let model = trackModelBuilder.buildTrackModelForType(.group,
                                                             properties: properties,
                                                             validation: validationResults.first{ !$0.valid })
        queue?.pushTrackModel(model)
    }
    
    public override func postIdentify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse]) {
        super.postIdentify(userId, properties: properties, validationResults: validationResults)

        let model = trackModelBuilder.buildTrackModelForType(.identify,
                                                             properties: properties,
                                                             validation: validationResults.first{ !$0.valid })
        queue?.pushTrackModel(model)
    }
    
    public override func postTrack(_ userId: String?, event: Event, validationResults: [ValidationResponse]) {
        super.postTrack(userId, event: event, validationResults: validationResults)
        
        let model = trackModelBuilder.buildTrackModelForType(.track,
                                                             event: event,
                                                             properties: event,
                                                             validation: validationResults.first{ !$0.valid })
        queue?.pushTrackModel(model)
    }
    
    public override func flush() {
        super.flush()
        queue?.flush()
    }
    
    public override func shutdown() {
        super.shutdown()
        queue = nil
    }
}
