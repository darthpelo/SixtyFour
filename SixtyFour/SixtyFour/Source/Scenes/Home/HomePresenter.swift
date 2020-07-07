//
//  HomePresenter.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation
import Moya

protocol HomeInterface {
    func firstLoad(_: HomeViewInterface, completion: @escaping () -> Void)
    func getNewData(completion: @escaping () -> Void)
    func getOldData(completion: @escaping () -> Void)
    func dataSource(atIndex index: Int) -> OCRModel?
    func dataSourceElements() -> Int
}

protocol HomeViewInterface {
    func updateUI()
}

final class HomePresenter: HomeInterface {
    typealias Dependencies = HasLocalStorageService

    private var dependencies: Dependencies?
    private let provider: MoyaProvider<MarloveService>
    private var list: [OCRModel] = [] {
        didSet {
            cacheData()
        }
    }

    private var lastObjId: String?
    private var view: HomeViewInterface?

    init(provider: MoyaProvider<MarloveService> = MoyaProvider<MarloveService>(session: MarloveService.getSession()),
         _ dependencies: Dependencies? = nil) {
        self.provider = provider
        self.dependencies = dependencies
    }

    func firstLoad(_ view: HomeViewInterface, completion: @escaping () -> Void) {
        self.view = view

        if let chachedData: [OCRModel] = dependencies?.localStorage.read() {
            list = Array(chachedData.prefix(10))
            lastObjId = list.last?.ocrId
            completion()
        } else {
            provider.request(.items(sinceId: nil, maxId: "5e4eb3c57258d")) { [weak self] result in
                guard let self = self else {
                    completion()
                    return
                }
                self.list.append(contentsOf: self.decodeResult(result) ?? [])
                completion()
            }
        }
    }

    func getNewData(completion: @escaping () -> Void) {
        guard let firstElement = list.first else {
            completion()
            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.provider.request(.items(sinceId: firstElement.ocrId, maxId: nil)) { result in
                guard let self = self else {
                    completion()
                    return
                }

                var newList = self.decodeResult(result) ?? []
                newList.append(contentsOf: self.list)
                self.list = newList
                completion()
            }
        }
    }

    func getOldData(completion: @escaping () -> Void) {
        guard let lastElement = lastObjId else {
            completion()
            return
        }

        provider.request(.items(sinceId: nil, maxId: lastElement)) { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            let oldData = self.decodeResult(result) ?? []
            if oldData.isEmpty == false, oldData.last?.ocrId != self.lastObjId {
                self.list.append(contentsOf: oldData)
                self.lastObjId = self.list.last?.ocrId
            }
            completion()
        }
    }

    func dataSource(atIndex index: Int) -> OCRModel? {
        guard index >= 0, index < list.count else {
            return nil
        }

        fetchOldData(index)
        return list[index]
    }

    func dataSourceElements() -> Int {
        list.count
    }

    // MARK: - Private

    private func decodeResult(_ result: Result<Response, MoyaError>) -> [OCRModel]? {
        switch result {
        case let .success(response):
            if response.statusCode == 200,
                let list: [OCRModel] = ModelConverter.convertToModels(from: response.data) {
                return list
            } else {
                return nil
            }
        case .failure:
            return nil
        }
    }

    private func fetchOldData(_ index: Int) {
        if index == list.count - 1 {
            getOldData {
                self.view?.updateUI()
            }
        }
    }

    private func cacheData() {
        dependencies?.localStorage.write(data: list)
    }
}
