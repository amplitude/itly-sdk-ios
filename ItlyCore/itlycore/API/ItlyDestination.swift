//
//  ItlyDestination.swift
//  Iteratively_example
//
//  Created by Konstantin Dorogan on 24.08.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

import Foundation

@objc public protocol ItlyDestination {
    func alias(_ userId: String, previousId: String?) throws
    func identify(_ userId: String?, properties: ItlyProperties?) throws
    func group(_ userId: String?, groupId: String, properties: ItlyProperties?) throws
    func track(_ userId: String?, event: ItlyEvent) throws
}
