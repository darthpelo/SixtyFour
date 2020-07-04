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
    private var list: [OCRModel] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ocrList.isHidden = true

        emptyContentSpinner.isHidden = false
        emptyContentSpinner.hidesWhenStopped = true
        emptyContentSpinner.startAnimating()

        presenter?.firstLoad(completion: { [weak self] result in
            if let list = result, list.isEmpty == false {
                self?.list = list
                DispatchQueue.main.async {
                    self?.ocrList.isHidden = false
                    self?.ocrList.reloadData()
                    self?.emptyContentSpinner.stopAnimating()
                }
            }
        })
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                       for: indexPath) as? OCRTableViewCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = list[indexPath.row].text
        cell.confidenceLabel.text = "\(list[indexPath.row].confidence * 100)%"
        cell.ocrId.text = list[indexPath.row].ocrId
        cell.orcImage.image = UIImage(base64String: list[indexPath.row].imageString)

        return cell
    }
}
