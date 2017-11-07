//
//  Route.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

public protocol Routable {
    func take(_ arguments: [String: Any], from: Route?)
}

public class Route: Routable {
    
    public let path: String
    public let wireframe: BaseWireframe!

    public init(module: RoutableModule, wireframe: BaseWireframe) {
        self.path = module.path
        self.wireframe = wireframe
        self.wireframe.route = self
    }
    
    public init(path: String, wireframe: BaseWireframe) {
        self.path = path
        self.wireframe = wireframe
        self.wireframe.route = self
    }
    
    public func take(_ arguments: [String : Any], from: Route?) {
        print("Navigating from: \(from?.path ?? "nothing") to: \(path)")
        wireframe.present(arguments, from: from?.wireframe)
    }
    
}
