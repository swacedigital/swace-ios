//
//  Router.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Epic Eats. All rights reserved.
//

import Foundation
import UIKit

public enum RoutingError: Error {
    case doesNotExist
    case urlSchemeMissing
    case invalidNavigationData
    case internalSchemeNotSet
    case invalidURL
    case missingModuleRoute
}

public protocol RouteDataKey {
    var rawValue: String { get }
}

public extension Dictionary {
    subscript(enumKey: RouteDataKey) -> Value? {
        get {
            if let key = enumKey.rawValue as? Key {
                return self[key]
            }
            return nil
        }
        set {
            if let key = enumKey.rawValue as? Key {
                self[key] = newValue
            }
        }
    }
}

public class Scheme: Hashable {
    public let name: String

    public init(name: String) {
        self.name = name
    }

    public var hashValue: Int { return name.hashValue }
    public static func ==(lhs: Scheme, rhs: Scheme) -> Bool { return lhs.name == rhs.name }
}

public class Router {

    public static let shared = Router()
    fileprivate static var internalRoutes = [Scheme: [Route]]()
    
    public func set(routes: [Route], for scheme: Scheme) {
        routes.forEach{ $0.scheme = scheme }
        Router.internalRoutes[scheme] = routes
    }
    
    // Navigating from outside app
    public func resolve(_ url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) throws {
        guard let scheme = url.scheme else { throw RoutingError.urlSchemeMissing }
        try Router.route(for: url)
        
        var parsedOptions = [String: Any]()
        options.forEach { (k,v) in parsedOptions[k.rawValue] = v }

        let routeScheme = scheme + "://"
        let path = url.absoluteString.replacingOccurrences(of: routeScheme , with: "")
        try Router.navigate(to: path, scheme: scheme, options: parsedOptions)
    }
    
    // Navigating from in-app
    public class func navigate(to module: RoutableModule, options: [String: Any] = [:], from: Route? = nil) throws {
        guard let route = module.route else { throw RoutingError.missingModuleRoute }
        try navigate(to: module.path, scheme: route.scheme.name, from: from, options: options)
    }
    
    public class func navigate(to urn: String) throws {
        try navigate(to: urn)
    }
    
    private class func navigate(to urn: String, scheme: String, from : Route? = nil, options: [String: Any]? = nil) throws {
        guard let url = URL(string: scheme + "://" + urn) else { throw RoutingError.invalidURL }
        
        var queryParams = parseURL(url)
        queryParams.merge(options ?? [:]) { (k1, k2) -> Any in return k1 }
        
        let matchingRoute = try route(for: url)
        try matchingRoute.take(url: url, arguments: queryParams, from: from)
    }
    
    @discardableResult fileprivate class func route(for url: URL) throws -> Route {
        guard let schemeName = url.scheme else { throw RoutingError.urlSchemeMissing }
        guard let match = Router.internalRoutes[Scheme(name: schemeName)]?.filter({
            print("Matching \(url.host) against \($0.path)")
            return $0.path == url.host
        }).first else { throw RoutingError.doesNotExist }
        return match
    }

    fileprivate class func parseURL(_ url: URL) -> [String : Any] {
        let components = URLComponents(string: url.absoluteString)
        var options = [String: Any]()
        components?.queryItems?.forEach { options[$0.name] = $0.value }
        return options
    }
    
    // Share route url
    public class func shareUrl(from module: RoutableModule, options: [String: Any?] = [:]) throws -> URL? {
        guard let route = module.route else { throw RoutingError.missingModuleRoute }
        var components = URLComponents()
        components.scheme = route.scheme.name
        components.host = route.path
        var query = [URLQueryItem]()
        options.forEach {
            let item = URLQueryItem(name: $0.key, value: $0.value as? String)
            query.append(item)
        }
        components.queryItems = query
        return components.url
    }
}

