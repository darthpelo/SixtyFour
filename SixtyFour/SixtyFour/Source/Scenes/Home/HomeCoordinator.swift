//
//  HomeCoordinator.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import UIKit

final class HomeCoordinator: BaseCoordinator {
    private var homePresenter: HomeInterface?

    override func start() {
        guard let navigationController = rootViewController as? UINavigationController else {
            return
        }

        homePresenter = HomePresenter()

        guard let presenter = homePresenter,
            let viewController = HomeViewController.createWith(presenter) as? HomeViewController else {
            return
        }

        navigationController.pushViewController(viewController, animated: true)
    }
}
