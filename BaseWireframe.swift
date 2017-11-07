//
//  BaseWireframe.swift
//  Epic Eats
//
//  Created by Andreas Östman on 2017-10-20.
//  Copyright © 2017 Plick. All rights reserved.
//

import Foundation
import UIKit

class BaseWireframe: WireframeInput {

    var window: UIWindow? { get { return UIApplication.shared.keyWindow } }
    fileprivate var wireframeRoute: Route?
    fileprivate weak var navController: UINavigationController?
    fileprivate weak var tabController: UITabBarController?
    var route: Route? {
        get { return wireframeRoute }
        set { wireframeRoute = newValue }
    }
    weak var view: UIViewController?
    weak var currentView: UIViewController? { return self.view }
    weak var source: BaseWireframe?

    static var didPrepare: Bool?

    func topViewControllerInSelectedTab() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow else { return nil }

        let tabbarController = tabbarControllerFromWindow(window)
        let selectedRootViewController = tabbarController?.selectedViewController as? UINavigationController
        return selectedRootViewController?.viewControllers.last
    }

    func navigationControllerForViewControllerInSelectedTab() -> UINavigationController? {
        return topViewControllerInSelectedTab()?.navigationController
    }

    func showRootViewControllerInsideNavigationController(_ viewController: UIViewController, inWindow: UIWindow) {
        let navigationController = navigationControllerFromWindow(inWindow)
        navigationController?.viewControllers = [viewController]
    }

    func navigationControllerFromWindow(_ window: UIWindow) -> UINavigationController? {
        let navigationController = window.rootViewController as? UINavigationController
        return navigationController
    }

    func tabbarControllerFromWindow(_ window: UIWindow) -> UITabBarController? {
        let tabbarController = window.rootViewController as? UITabBarController
        return tabbarController
    }

    var currentNavigationController: UINavigationController? {
        get { return (navController ?? navigationControllerForViewControllerInSelectedTab()) }
        set { navController = newValue }
    }
    var currentTabbarController: UITabBarController? {
        get { return tabController ?? tabbarControllerFromWindow(window!) }
        set { tabController = newValue}
    }

    func present(_ data: [String : Any]?, from source: BaseWireframe?) {

    }

    func prepare(_ data: [String : Any]?) -> UIViewController? {
        return nil
    }

    func dismiss(_ view: Any?){
        guard let view = view as? UIViewController else { return }
        view.dismiss(animated: true, completion: nil)
    }

}

protocol WireframeInput {
    static var identifier: String { get }
}

extension WireframeInput {
    static var identifier: String { return "" }
}

