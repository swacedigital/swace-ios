//
//  Router.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation
import UIKit

enum RoutingError: Error {
    case doesNotExist
    case invalidNavigationData
}

class Router {
    
    static let shared = Router()
    fileprivate static var internalScheme = "plick://"
    fileprivate static var internalRoutes = [Route]()
    
    class var baseURL: URL {
        return URL(string: Router.scheme)!
    }
    
    class var scheme: String! {
        get { return "\(Router.internalScheme)" }
        set { Router.internalScheme = newValue }
    }
    var routes: [Route]! {
        get { return Router.internalRoutes }
        set { Router.internalRoutes = newValue }
    }
    
    func set(scheme: String = Router.internalScheme, routes: [Route]? = nil) {
        Router.scheme = scheme
        if let routes = routes { self.routes = routes }
    }
    
    func resolve(_ url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        guard Router.canNavigateToPath(url.path) else { return false }
        var parsedOptions = [String: Any]()
        options.forEach { (key,value) in
            parsedOptions[key.rawValue] = value
        }
        Router.navigateTo(url.path, options: parsedOptions)
        return true
    }
    
    class func navigate(to module: Module, options: [String: Any] = [:]) {
        navigateTo(internalScheme + module.path, options: options)
    }
    
    class func navigateToModule(_ urn: String) {
        guard let url = URL(string: urn) else { return }
        
        let (path, args) = parseURL(url)
        if let route = try? routeForPath(path) {
            route.take(args, from: nil)
        }
    }
    
    class func navigateTo(_ urn: String, from : Route? = nil, options: [String: Any]? = nil) {
        guard let url = URL(string: urn) else { return }
        
        let (path, _) = parseURL(url)
        if let route = try? routeForPath(path) {
            route.take(options ?? [:], from: from)
        }
    }
    
    class func canNavigateToPath(_ path: String) -> Bool {
        do {
            _ =  try routeForPath(path)
            return true
        }
        catch { return false }
    }
    
    fileprivate class func routeForPath(_ path: String) throws -> Route {
        if let route = internalRoutes.filter({$0.path == path}).first { return route }
        else { throw RoutingError.doesNotExist }
    }
    
    fileprivate class func parseURL(_ url: URL) -> (path: String, options: [String : Any]){
        let components = URLComponents(string: url.absoluteString)
        var options = [String: Any]()
        components?.queryItems?.forEach { options[$0.name] = $0.value }
        return (url.host ?? "", options)
    }
}

