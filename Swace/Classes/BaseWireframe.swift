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

    public var window: UIWindow? { get { return UIApplication.shared.keyWindow } }
    fileprivate var wireframeRoute: Route?
    fileprivate weak var navController: UINavigationController?
    fileprivate weak var tabController: UITabBarController?
    public var route: Route? {
        get { return wireframeRoute }
        set { wireframeRoute = newValue }
    }
    private weak var view: UIViewController?
    public weak var currentView: UIViewController? { return self.view }
    public weak var source: BaseWireframe?

    public static var didPrepare: Bool?

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

    open func present(_ data: [String : Any]?, from source: BaseWireframe?) {

    }

    open func prepare(_ data: [String : Any]?) -> UIViewController? {
        return nil
    }

    open func dismiss(_ view: Any?){
        guard let view = view as? UIViewController else { return }
        view.dismiss(animated: true, completion: nil)
    }

}

public protocol WireframeInput {
    static var identifier: String { get }
}

public extension WireframeInput {
    static var identifier: String { return String(describing: self) }
}

