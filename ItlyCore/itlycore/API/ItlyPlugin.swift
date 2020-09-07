//
//  IterativelyPlugin.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 24.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public protocol ItlyPlugin {
    func didPlugIntoInstance(_ instance: ItlyCoreApi) throws
    func reset() throws
    func flush() throws
    func shutdown() throws
}
