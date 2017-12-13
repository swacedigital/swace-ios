//
//  Route.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

public protocol Routable {
    func take(_ arguments: [String: Any], from: Route?) throws
}

public class Route: Routable {
    
    open var path: String
    public let wireframe: BaseWireframe!

    public init(module: RoutableModule, wireframe: BaseWireframe?) {
        self.path = module.path
        self.wireframe = wireframe
        self.wireframe.route = self
    }
    
    public init(path: String, wireframe: BaseWireframe?) {
        self.path = path
        self.wireframe = wireframe
        self.wireframe.route = self
    }
    
    public func take(_ arguments: [String : Any], from: Route?) throws {
        print("Navigating from: \(from?.path ?? "nothing") to: \(path)")
        try wireframe.present(arguments, from: from?.wireframe)
    }
    
}

public class ExternalRoute: Route {
    
    public init(module: RoutableModule) {
        super.init(module: module, wireframe: nil)
    }
    
}
