//
//  Router.swift
//  TMROCoordinator
//
//  Created by Benji Dodgson on 11/4/19.
//  Copyright © 2019 Tomorrow Ideas. All rights reserved.
//

import Foundation
import UIKit

// An object that can present Presentable objects via a navigation controller push, or modally.
// Optionally, a cancel handler can be provided to execute code when the Presentable is dismissed
// prematurely by something other than the router.
open class Router: NSObject, UINavigationControllerDelegate {

    unowned let navController: UINavigationController

    // True if the router is currently in the process of dismissing a module.
    private var isDismissing = false

    public init(navController: UINavigationController) {
        self.navController = navController

        super.init()

        self.navController.delegate = self
    }

    // MARK: Modal Presentation

    // The cancel handler is called when the presented module is dimissed
    // by something other than this router.
    open func present(_ module: Presentable,
                        source: UIViewController,
                        cancelHandler: (() -> Void)? = nil,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {

        let viewController = module.toPresentable()

        // IMPORTANT: The module will have a strong reference to its viewController. To avoid a retain
        // cycle, pass in a weak reference to the module in the capture list.
        viewController.dismissHandlers.append { [unowned self, weak module = module] in
            module?.removeFromParent()

            // If this router didn't trigger the dismiss, then the module was cancelled.
            if !self.isDismissing {
                cancelHandler?()
            }
        }

        source.present(viewController,
                       animated: animated,
                       completion: completion)
    }

    open func dismiss(source: UIViewController,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {

        self.isDismissing = true
        source.dismiss(animated: animated) {
            self.isDismissing = false
            completion?()
        }
    }

    // MARK: Navigation Controller Presentation

    // The cancel handler is called when the presented module is popped off the nav stack
    // by something other than this router.
    open func push(_ module: Presentable,
                     cancelHandler: (() -> Void)? = nil,
                     animated: Bool = true) {

        let viewController = module.toPresentable()

        // IMPORTANT: The module will have a strong reference to its viewController. To avoid a retain
        // cycle, pass in a weak reference to the module in the capture list.
        viewController.dismissHandlers.append { [unowned self, unowned module = module] in
            module.removeFromParent()

            if !self.isDismissing {
                cancelHandler?()
            }
        }

        self.navController.pushViewController(viewController, animated: animated)
    }

    open func popModule(animated: Bool) {
        self.isDismissing = true
        self.navController.popViewController(animated: animated)
    }

    open func setRootModule(_ module: Presentable, animated: Bool = true) {
        self.isDismissing = true
        self.navController.setViewControllers([module.toPresentable()], animated: animated)
    }

    // MARK: UINavigationControllerDelegate

    open func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        self.isDismissing = false
    }

    open func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
