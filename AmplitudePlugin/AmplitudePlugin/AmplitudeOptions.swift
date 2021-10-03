//
//  AmplitudeOptions.swift
//  AmplitudePlugin
//
//  Created by Qingzhuo Zhen on 9/30/21.
//  Copyright © 2021 Iteratively. All rights reserved.
//

import Foundation

@objc(ITLAmplitudeOptions) public class AmplitudeOptions: NSObject {
    @objc public let branch: String?
    @objc public let version: String?
    @objc public let source: String?
    
    @objc public init(
        branch: String? = nil,
        source: String? = nil,
        version: String? = nil
    ) {
        self.branch = branch
        self.source = source
        self.version = version
        super.init()
    }
}
