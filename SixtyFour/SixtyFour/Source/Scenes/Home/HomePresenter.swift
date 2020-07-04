//
//  HomePresenter.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation
import Moya

final class HomePresenter {
    private let provider: MoyaProvider<MarloveService>
    private var list: [OCRModel] = []

    init(provider: MoyaProvider<MarloveService> = MoyaProvider<MarloveService>()) {
        self.provider = provider
    }

    func firstLoad(completion: @escaping ([OCRModel]?) -> Void) {
        provider.request(.items(sinceId: nil, maxId: nil)) { [weak self] result in
            guard let self = self else {
                completion(nil)
                return
            }

            self.list = self.decodeResult(result) ?? []
            completion(self.list)
        }
    }

    func getNewData(completion: @escaping ([OCRModel]?) -> Void) {
        provider.request(.items(sinceId: "", maxId: nil)) { [weak self] result in
            guard let self = self else {
                completion(nil)
                return
            }
            var newList = self.decodeResult(result) ?? []
            newList.append(contentsOf: self.list)
            self.list = newList
            completion(self.list)
        }
    }

    func getOldData(completion: @escaping ([OCRModel]?) -> Void) {
        provider.request(.items(sinceId: nil, maxId: "")) { [weak self] result in
            guard let self = self else {
                completion(nil)
                return
            }
            self.list.append(contentsOf: self.decodeResult(result) ?? [])
            completion(self.list)
        }
    }

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
}
