//
//  BaseWireframe.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Plick. All rights reserved.
//

import Foundation
import UIKit

open class BaseWireframe: WireframeInput {
    
    public enum WireframeError: Error {
        case missingOverride
    }
    
    public var window: UIWindow? { get { return UIApplication.shared.keyWindow } }
    fileprivate var wireframeRoute: Route?
    fileprivate weak var navController: UINavigationController?
    fileprivate weak var tabController: UITabBarController?
    public var route: Route? {
        get { return wireframeRoute }
        set { wireframeRoute = newValue }
    }
    open weak var view: UIViewController?
    public weak var currentView: UIViewController? { return self.view }
    public weak var source: BaseWireframe?

    open var didPrepare: Bool = false

    public init() {  }

    public func topViewControllerInSelectedTab() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow else { return nil }

        let tabbarController = tabbarControllerFromWindow(window)
        let selectedRootViewController = tabbarController?.selectedViewController as? UINavigationController
        return selectedRootViewController?.viewControllers.last
    }

    public func navigationControllerForViewControllerInSelectedTab() -> UINavigationController? {
        return topViewControllerInSelectedTab()?.navigationController
    }

    public func showRootViewControllerInsideNavigationController(_ viewController: UIViewController, inWindow: UIWindow) {
        let navigationController = navigationControllerFromWindow(inWindow)
        navigationController?.viewControllers = [viewController]
    }

    public func navigationControllerFromWindow(_ window: UIWindow) -> UINavigationController? {
        let navigationController = window.rootViewController as? UINavigationController
        return navigationController
    }

    public func tabbarControllerFromWindow(_ window: UIWindow) -> UITabBarController? {
        let tabbarController = window.rootViewController as? UITabBarController
        return tabbarController
    }

    public var currentNavigationController: UINavigationController? {
        get { return (navController ?? navigationControllerForViewControllerInSelectedTab()) }
        set { navController = newValue }
    }
    public var currentTabbarController: UITabBarController? {
        get { return tabController ?? tabbarControllerFromWindow(window!) }
        set { tabController = newValue}
    }

    open func present(_ data: [String : Any] = [:], from source: BaseWireframe?) throws {
        throw WireframeError.missingOverride
    }

    open func prepare(_ data: [String : Any] = [:]) throws -> UIViewController {
        throw WireframeError.missingOverride
    }

    open func dismiss(_ view: UIViewController?) {
        view?.dismiss(animated: true, completion: nil)
    }

}

public protocol WireframeInput {
    static var identifier: String { get }
}

public extension WireframeInput {
    static var identifier: String { return String(describing: self) }
}

