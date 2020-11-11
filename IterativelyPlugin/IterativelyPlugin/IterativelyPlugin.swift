//
//  IterativelyPlugin.swift
//  IterativelyPlugin
//
//  Created by Konstantin Dorogan on 18.09.2020.
//

import Foundation
import ItlySdk

@objc(ITLIterativelyPlugin) public class IterativelyPlugin: Plugin {
    private var config: IterativelyOptions;
    private var isDisabled: Bool = false;
    private var trackModelBuilder: TrackModelBuilder!
    private var queue: ProcessingQueue?
    private let createFactory: ((Logger?) -> MainFactory)
    
    @objc public init(_ apiKey: String, url: String, options: IterativelyOptions) throws {
        self.config = options
        self.createFactory = { logger in
            return MainFactory(config: options, apiKey: apiKey, url: url, logger: logger)
        }
        super.init(id: "IterativelyPlugin")
    }

    public override func load(_ options: Options) {
        super.load(options)
        self.isDisabled = (options.environment == .production) || self.config.disabled;
        
        do {
            let mainFactory = createFactory(options.logger)
            self.trackModelBuilder = try mainFactory.createTrackModelBuilder()
            self.queue = try mainFactory.createProcessingQueue()
        } catch {
            options.logger?.error("Error on createProcessingQueue(): \(error.localizedDescription)")
        }
    }
    
    public override func postGroup(_ userId: String?, groupId: String, properties: Properties?, validationResults: [ValidationResponse]) {
        guard !isDisabled else { return }
        
        let model = trackModelBuilder.buildTrackModelForType(.group,
                                                             properties: properties,
                                                             validation: validationResults.first{ !$0.valid })
        queue?.pushTrackModel(model)
    }
    
    public override func postIdentify(_ userId: String?, properties: Properties?, validationResults: [ValidationResponse]) {
        guard !isDisabled else { return }

        let model = trackModelBuilder.buildTrackModelForType(.identify,
                                                             properties: properties,
                                                             validation: validationResults.first{ !$0.valid })
        queue?.pushTrackModel(model)
    }
    
    public override func postTrack(_ userId: String?, event: Event, validationResults: [ValidationResponse]) {
        guard !isDisabled else { return }
        
        let model = trackModelBuilder.buildTrackModelForType(.track,
                                                             event: event,
                                                             properties: event,
                                                             validation: validationResults.first{ !$0.valid })
        queue?.pushTrackModel(model)
    }
    
    public override func flush() {
        guard !isDisabled else { return }
        queue?.flush()
    }
    
    public override func shutdown() {
        guard !isDisabled else { return }
        queue = nil
    }
}
