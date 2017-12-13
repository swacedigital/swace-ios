//
//  Modules.swift
//  Swace_Example
//
//  Created by Andreas Östman on 2017-11-07.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Swace

struct Modules: RoutableModule {
    var path: String
    var route: Route?

    init(path: String) {
        self.path = path
    }

    static let profile = Modules(path: "profile")
}
