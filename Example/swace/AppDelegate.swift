//
//  AppDelegate.swift
//  swace
//
//  Created by a.oshtman@gmail.com on 11/07/2017.
//  Copyright (c) 2017 a.oshtman@gmail.com. All rights reserved.
//

import UIKit
import Swace

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Router.shared.set(routes: [
            Route(module: Modules.profile, wireframe: ExampleWireframe())
            ], for: Scheme(name: "epiceats://"))

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return try! Router.shared.resolve(url, options: options)
    }

}

