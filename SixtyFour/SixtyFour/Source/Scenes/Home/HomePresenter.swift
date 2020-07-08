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
    var currentCount: Int { get }

    func getNewData(completion: @escaping () -> Void)
    func fetchOcrs(completion: @escaping () -> Void)
    func dataSource(atIndex index: Int) -> OCRModel?
}

final class HomePresenter: HomeInterface {
    typealias Dependencies = HasLocalStorageService

    var currentCount: Int {
        list.count
    }

    private var dependencies: Dependencies?
    private let provider: MoyaProvider<MarloveService>
    private var list: [OCRModel] = [] {
        didSet {
            cacheData()
        }
    }

    private var isFetchInProgress = false
    private var isEndOfData = false

    init(provider: MoyaProvider<MarloveService> = MoyaProvider<MarloveService>(session: MarloveService.getSession()),
         _ dependencies: Dependencies? = nil) {
        self.provider = provider
        self.dependencies = dependencies
    }

    func getNewData(completion: @escaping () -> Void) {
        guard !isFetchInProgress else {
            return
        }

        guard let firstElement = list.first else {
            completion()
            return
        }

        isFetchInProgress = true

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.provider.request(.items(sinceId: firstElement.ocrId, maxId: nil)) { result in
                if let newList = self?.decodeResult(result) {
                    self?.list.insert(contentsOf: newList, at: 0)
                }

                self?.isFetchInProgress = false
                completion()
            }
        }
    }

    func fetchOcrs(completion: @escaping () -> Void) {
        guard !isFetchInProgress || !isEndOfData else {
            return
        }

        if let chachedData: [OCRModel] = dependencies?.localStorage.read(), list.isEmpty {
            list = Array(chachedData.prefix(10))
            completion()
        } else {
            isFetchInProgress = true

            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }

                self.provider.request(.items(sinceId: nil, maxId: self.list.last?.ocrId)) { result in
                    if let newData = self.decodeResult(result) {
                        self.list.append(contentsOf: newData)
                    } else {
                        self.isEndOfData = true
                    }
                    self.isFetchInProgress = false
                    completion()
                }
            }
        }
    }

    func dataSource(atIndex index: Int) -> OCRModel? {
        list[index]
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

    private func cacheData() {
        dependencies?.localStorage.write(data: list)
    }
}
