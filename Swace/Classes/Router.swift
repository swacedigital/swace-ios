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
    case urlHostMissing
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
    public let strict: Bool
    
    var isHttp: Bool { return name == "http" || name == "https" }

    public init(name: String, strict: Bool = true) {
        self.name = name
        self.strict = strict
    }
    public var hashValue: Int { return name.hashValue }
    public static func ==(lhs: Scheme, rhs: Scheme) -> Bool { return lhs.name == rhs.name }
}

public class Router {

    public static let shared = Router()
    public var routes: [Route] {
        return Router.internalRoutes.reduce([], { $0 + $1.value })
    }
    fileprivate static var internalRoutes = [Scheme: [Route]]()
    
    public func set(routes: [Route], for scheme: Scheme) {
        routes.forEach{ $0.scheme = scheme }
        Router.internalRoutes[scheme] = routes
    }
    
    // Navigating from outside app
    public class func resolve(_ url: URL?, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) throws {
        
        guard let url = url else { throw RoutingError.invalidURL }
        guard let schemeName = url.scheme else { throw RoutingError.urlSchemeMissing }
        guard let host = url.host else { throw RoutingError.urlHostMissing }
        
        let scheme = Scheme(name: schemeName)
        
        var parsedOptions = parseURL(url)
        options.forEach { (k,v) in parsedOptions[k.rawValue] = v }
        
        guard !scheme.isHttp else {
            let externalRoute = ExternalRoute()
            try externalRoute.take(url: url, arguments: parsedOptions)
            return
        }

        try Router.route(for: url, using: scheme)
        try Router.navigate(to: host, scheme: scheme, options: parsedOptions)
    }
    
    fileprivate class func parseURL(_ url: URL) -> [String : Any] {
        let components = URLComponents(string: url.absoluteString)
        var options = [String: Any]()
        components?.queryItems?.forEach { options[$0.name] = $0.value }
        return options
    }
    
    // Navigating from in-app
    public class func navigate(to module: RoutableModule, options: [String: Any] = [:], from: Route? = nil) throws {
        guard let route = module.route else { throw RoutingError.missingModuleRoute }
        try navigate(to: module.path, scheme: route.scheme, from: from, options: options)
    }
    
    private class func createURL(urn: String, scheme: String) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = urn
        return components.url
    }
    
    private class func navigate(to urn: String, scheme: Scheme, from : Route? = nil, options: [String: Any]? = nil) throws {
        guard let url = createURL(urn: scheme.strict ? urn : "", scheme: scheme.name) else { throw RoutingError.invalidURL }
        
        let matchingRoute = try route(for: url, using: scheme, host: scheme.strict ? nil : urn)
        try matchingRoute.take(url: url, arguments: options ?? [:], from: from)
    }
    
    @discardableResult fileprivate class func route(for url: URL, using scheme: Scheme, host: String? = nil) throws -> Route {
        guard let _ = url.scheme else { throw RoutingError.urlSchemeMissing }
        guard let hostName = url.host ?? host else { throw RoutingError.urlHostMissing }
        guard let match = Router.internalRoutes[scheme]?.filter({
            return $0.path == hostName
        }).first else { throw RoutingError.doesNotExist }
        return match
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

