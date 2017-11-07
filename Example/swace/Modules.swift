//
//  Modules.swift
//  Swace_Example
//
//  Created by Andreas Östman on 2017-11-07.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import swace

struct Modules: RoutableModule {
    var path: String

    init(path: String) {
        self.path = path
    }

    static let profile = Modules(path: "profile")
}
