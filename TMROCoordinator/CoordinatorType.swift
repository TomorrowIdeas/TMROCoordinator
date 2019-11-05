//
//  CoordinatorType.swift
//  TMROCoordinator
//
//  Created by Benji Dodgson on 11/4/19.
//  Copyright © 2019 Tomorrow Ideas. All rights reserved.
//

import Foundation

public protocol CoordinatorType: class {

    var parentCoordinator: CoordinatorType? { set get }
    var furthestChild: CoordinatorType { get }

    func removeChild()
}
