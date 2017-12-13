//
//  Modules.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

public protocol RoutableModule {
    var path: String { get set }
    var route: Route? { get set }
}
