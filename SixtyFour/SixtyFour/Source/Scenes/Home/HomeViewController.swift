//
//  HomeViewController.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet var emptyContentSpinner: UIActivityIndicatorView!
    @IBOutlet var ocrList: UITableView!

    private var presenter: HomeInterface?

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        ocrList.backgroundView = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ocrList.isHidden = true

        emptyContentSpinner.isHidden = false
        emptyContentSpinner.hidesWhenStopped = true
        emptyContentSpinner.startAnimating()

        presenter?.getOldData(completion: { newIndexPathsToReload in
            guard let newIndexPathsToReload = newIndexPathsToReload else {
                self.ocrList.isHidden = false
                self.ocrList.reloadData()
                self.emptyContentSpinner.stopAnimating()
                return
            }
        })
    }

    @objc
    func refresh(_ refreshControl: UIRefreshControl) {
        presenter?.getNewData {
            DispatchQueue.main.async {
                self.ocrList.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }
}

private extension HomeViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        guard let count = presenter?.currentCount else {
            return false
        }
        return indexPath.row >= count - 1
    }
}

// MARK: - Static factory

extension HomeViewController {
    static func createWith(_ viewModel: HomeInterface) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: classIdentifier)
            as? HomeViewController
        viewController?.presenter = viewModel

        return viewController
    }
}

// MARK: - UITableView Delegates

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            // For a generic implementation in case you want to load new data without pull-to-refresh logic
            // you would like to reload only a specific section, not all the list. I kept the generic approach, but
            // without use it.
            // In a generic approach, if newIndexPathsToReload is not nil, we will use tableView.reloadRows
            presenter?.getOldData(completion: { newIndexPathsToReload in
                guard newIndexPathsToReload != nil else {
                    tableView.reloadData()
                    return
                }
                tableView.reloadData()
            })
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter?.currentCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                       for: indexPath) as? OCRTableViewCell,
            let element = presenter?.dataSource(atIndex: indexPath.row) else {
            return UITableViewCell()
        }

        cell.titleLabel.text = element.text
        cell.confidenceLabel.text = "\(element.confidence * 100)%"
        cell.ocrId.text = element.ocrId
        cell.orcImage.image = UIImage(base64String: element.imageString)

        return cell
    }
}
