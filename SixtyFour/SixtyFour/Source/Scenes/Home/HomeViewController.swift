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

        presenter?.fetchOcrs { [weak self] in
            self?.ocrList.isHidden = false
            self?.ocrList.reloadData()
            self?.emptyContentSpinner.stopAnimating()
        }
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
            presenter?.fetchOcrs {
                tableView.reloadData()
            }
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
