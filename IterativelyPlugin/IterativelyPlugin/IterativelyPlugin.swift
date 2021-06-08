//
//  IterativelyPlugin.swift
//  IterativelyPlugin
//
//

import Foundation
import ItlySdk

@objc(ITLIterativelyPlugin) public class IterativelyPlugin: Plugin {
    private var config: IterativelyOptions;
    private var isDisabled: Bool = false;
    private var trackModelBuilder: TrackModelBuilder!
    private var queue: ProcessingQueue?
    private let createFactory: ((Logger?) -> MainFactory)

    @objc public init(_ apiKey: String, options: IterativelyOptions = IterativelyOptions()) throws {
        self.config = options
        self.createFactory = { logger in
            return MainFactory(config: options, apiKey: apiKey, url: options.url, logger: logger)
        }
        super.init(id: "IterativelyPlugin")
    }

    // NOTICE: For backwards compatibility with v1.0.0-v1.0.1 codegen.
    // TODO: Remove this sometime when we are confident people are no longer using v1.0.1
    @objc public convenience init(
        _ apiKey: String, url: String?, options: IterativelyOptions = IterativelyOptions()
    ) throws {
        try self.init(apiKey, options: options.withOverrides({ (o) in o.url = url ?? options.url }))
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

    public func url() -> String {
        return self.config.url
    }
}
