//
//  Modules.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

open class RoutableModule {
    internal var route: Route?
    let path: String

    public init(path: String) {
        self.path = path
    }
}
