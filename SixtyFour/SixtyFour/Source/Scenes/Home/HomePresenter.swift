//
//  HomePresenter.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation
import Moya

struct HomePresenter {
    private let provider: MoyaProvider<MarloveService>

    init(provider: MoyaProvider<MarloveService> = MoyaProvider<MarloveService>()) {
        self.provider = provider
    }

    func firstLoad(completion: @escaping ([OCRModel]?) -> Void) {
        provider.request(.items(sinceId: nil, maxId: nil)) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200,
                    let list: [OCRModel] = ModelConverter.convertToModels(from: response.data) {
                    completion(list)
                } else {
                    completion(nil)
                }
            case let .failure(error):
                print(error)
                completion(nil)
            }
        }
    }
}
