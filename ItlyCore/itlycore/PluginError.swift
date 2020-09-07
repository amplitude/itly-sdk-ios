//
//  PluginError.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 31.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

enum PluginError: Error {
    case validationError(error: Error, pluginId: String)
}
