//
//  Presentable.swift
//  TMROCoordinator
//
//  Created by Benji Dodgson on 11/4/19.
//  Copyright © 2019 Tomorrow Ideas. All rights reserved.
//

import Foundation
import UIKit

public protocol Presentable: class {

    typealias DismissableVC = UIViewController & Dismissable

    func toPresentable() -> DismissableVC
    func removeFromParent()
}
