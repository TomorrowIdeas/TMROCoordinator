//
//  Dismissable.swift
//  TMROCoordinator
//
//  Created by Benji Dodgson on 11/4/19.
//  Copyright © 2019 Tomorrow Ideas. All rights reserved.
//

import Foundation

public protocol Dismissable: class {
    var dismissHandlers: [() -> Void] { get set }
}
