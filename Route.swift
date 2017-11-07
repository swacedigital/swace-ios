//
//  Route.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation

protocol Routable {
    func take(_ arguments: [String: Any], from: Route?)
}

class Route: NSObject, Routable {
    
    var path: String!
    var wireframe: BaseWireframe!
    
    override init(){ }
    
    init(module: Module, wireframe: BaseWireframe) {
        super.init()
        self.path = module.path
        self.wireframe = wireframe
        self.wireframe.route = self
    }
    
    init(path: String, wireframe: BaseWireframe) {
        super.init()
        self.path = path
        self.wireframe = wireframe
        self.wireframe.route = self
    }
    
    func take(_ arguments: [String : Any], from: Route?) {
        print("Navigating from: \(from?.path ?? "nothing") to: \(path!)")
        wireframe.present(arguments, from: from?.wireframe)
    }
    
}
