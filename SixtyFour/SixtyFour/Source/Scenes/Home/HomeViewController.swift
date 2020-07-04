//
//  HomeViewController.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    private var viewModel: HomeInterface?
}

// MARK: - Static factory

extension HomeViewController {
    static func createWith(_ viewModel: HomeInterface) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: classIdentifier)
            as? HomeViewController
        viewController?.viewModel = viewModel

        return viewController
    }
}
