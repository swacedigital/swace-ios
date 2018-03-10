//
//  Modules.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

open class RoutableModule {

    internal var _route: Route?
    public var route: Route? { return _route }
    let path: String

    public init(path: String) {
        self.path = path
    }
}
