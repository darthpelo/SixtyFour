//
//  RootCoordinator.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import UIKit

final class RootCoordinator {
    private(set) var homeCoordinator: HomeCoordinator?

    func startup(_ window: UIWindow?) {
        let navigationController = UINavigationController()
        homeCoordinator = HomeCoordinator(withViewController: navigationController,
                                          dependencies: DependencyContainer().makeContainer())
        homeCoordinator?.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
