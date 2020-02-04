//
//  Coordinator.swift
//  TMROCoordinator
//
//  Created by Benji Dodgson on 11/4/19.
//  Copyright © 2019 Tomorrow Ideas. All rights reserved.
//

import Foundation

open class Coordinator<Result>: CoordinatorType {

    public let router: Router
    
    private var onFinishedFlow: ((Result) -> Void)?

    public weak var parentCoordinator: CoordinatorType?
    private(set) var childCoordinator: CoordinatorType?
    public var furthestChild: CoordinatorType {
        if let child = self.childCoordinator {
            return child.furthestChild
        }
        return self
    }

    public init(router: Router) {
        self.router = router
    }

    open func start() { }

    open func addChildAndStart<ChildResult>(_ coordinator: Coordinator<ChildResult>,
                                            finishedHandler: @escaping (ChildResult) -> Void) {
        // If we already have a child coordinator, log a warning. While this isn't ideal, it helps
        // prevent apps from getting locked up due to a coordinator not finishing or being presented
        // properly.
        if self.childCoordinator != nil {
            print("WARNING!!!!! ADDING CHILD COORDINATOR \(coordinator)"
                + " TO COORDINATOR \(self) THAT ALREADY HAS ONE \(self.childCoordinator!)")
        }

        coordinator.parentCoordinator = self
        self.childCoordinator = coordinator

        // Assign the finish handler before calling start in case the coordinator finishes immediately
        coordinator.onFinishedFlow = finishedHandler
        coordinator.start()
    }

    open func removeChild() {
        self.childCoordinator = nil
    }

    open func removeFromParent() {
        self.parentCoordinator?.removeChild()
    }

    open func finishFlow(with result: Result) {
        self.removeFromParent()
        self.onFinishedFlow?(result)
    }
}
