//
//  AmplitudeOptions.swift
//  AmplitudePlugin
//
//  Created by Qingzhuo Zhen on 9/30/21.
//  Copyright © 2021 Iteratively. All rights reserved.
//

import Foundation

@objc(ITLAmplitudeOptions) public class AmplitudeOptions: NSObject {
    @objc public let planBranch: String?
    @objc public let planVersion: String?
    @objc public let planSource: String?
    
    @objc public init(
        planBranch: String? = nil,
        planSource: String? = nil,
        planVersion: String? = nil
    ) {
        self.planBranch = planBranch
        self.planSource = planSource
        self.planVersion = planVersion
        super.init()
    }
    
    @objc public func withOverrides(
        planBranch: String? = nil,
        planSource: String? = nil,
        planVersion: String? = nil
    ) -> AmplitudeOptions {
        let branch = planBranch ? planBranch : self.planBranch
        let source = planSource ? planSource : self.planSource
        let version = planVersion ? planVersion : self.planVersion
        return AmplitudeOptions(planBranch: branch, planSource: source, planVersion: version)
    }
}
