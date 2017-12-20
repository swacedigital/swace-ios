//
//  Route.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import UIKit

public protocol Routable {
    func take(url: URL?, arguments: [String: Any], from: Route?) throws
}

public class Route: Routable {
    
    open var path: String
    public var scheme = Scheme(name: "")
    public var url: URL? { return URL(string: scheme.name + path) }
    public let wireframe: BaseWireframe!
    public let module: RoutableModule!

    public init(module: RoutableModule, wireframe: BaseWireframe = BaseWireframe()) {
        self.path = module.path
        self.wireframe = wireframe
        self.module = module
        self.wireframe.route = self
        self.module.route = self
    }
    
    public init(path: String, wireframe: BaseWireframe?) {
        self.path = path
        self.wireframe = wireframe
        self.module = nil
        self.wireframe.route = self
    }
    
    public func take(url: URL? = nil, arguments: [String : Any], from: Route?) throws {
        print("Navigating from: \(from?.path ?? "nothing") to: \(path)")
        try wireframe.present(arguments, from: from?.wireframe)
    }
    
}

public class ExternalRoute: Route {
    
    public init(module: RoutableModule) {
        super.init(module: module)
    }
    
    public override func take(url: URL? = nil, arguments: [String : Any], from: Route?) throws {
        guard let url = url else { throw RoutingError.invalidURL }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = []
        arguments.forEach { (key, value) in
            let item = URLQueryItem(name: key, value: value as? String)
            components?.queryItems?.append(item)
        }
        
        guard let trueUrl = components?.url else { throw RoutingError.invalidURL }
        
        guard UIApplication.shared.canOpenURL(trueUrl) else { throw RoutingError.invalidURL }
        UIApplication.shared.openURL(trueUrl)
    }
}
