//
//  Coordinator.swift
//  TMROCoordinator
//
//  Created by Benji Dodgson on 11/4/19.
//  Copyright © 2019 Tomorrow Ideas. All rights reserved.
//

import Foundation

public class Coordinator<Result>: CoordinatorType {

    let router: Router
    
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

    public func start() { }

    public func addChildAndStart<ChildResult>(_ coordinator: Coordinator<ChildResult>,
                                       finishedHandler: @escaping (ChildResult) -> Void) {
        guard self.childCoordinator == nil else {
            print("WARNING!!!!! ATTEMPTING TO ADD CHILD COORDINATOR \(coordinator)"
                + " TO COORDINATOR \(self) THAT ALREADY HAS ONE \(self.childCoordinator!)")
            return
        }

        coordinator.parentCoordinator = self
        self.childCoordinator = coordinator

        // Assign the finish handler before calling start in case the coordinator finishes immediately
        coordinator.onFinishedFlow = finishedHandler
        coordinator.start()
    }

    public func removeChild() {
        self.childCoordinator = nil
    }

    public func removeFromParent() {
        self.parentCoordinator?.removeChild()
    }

    public func finishFlow(with result: Result) {
        self.removeFromParent()
        self.onFinishedFlow?(result)
    }
}
