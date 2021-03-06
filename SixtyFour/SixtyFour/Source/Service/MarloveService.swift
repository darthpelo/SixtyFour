//
//  MarloveService.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Alamofire
import Foundation
import Moya

enum MarloveService {
    case items(sinceId: String?, maxId: String?)
}

extension MarloveService: TargetType {
    var baseURL: URL { URL(string: "https://marlove.net/e/mock/v1")! }
    var path: String {
        switch self {
        case .items:
            return "/items"
        }
    }

    var method: Moya.Method {
        switch self {
        case .items:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .items(sinceId, maxId):
            if let sinceId = sinceId {
                return .requestParameters(parameters: ["since_id": sinceId], encoding: URLEncoding.queryString)
            } else if let maxId = maxId {
                return .requestParameters(parameters: ["max_id": maxId], encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        }
    }

    var sampleData: Data {
        switch self {
        case .items:
            // From stub file stubResponse.json.
            guard let url = Bundle.main.url(forResource: "stubResponse", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                return Data()
            }
            return data
        }
    }

    var headers: [String: String]? {
        do {
            let token = try Preferences.getToken()
            return ["Authorization": token]
        } catch {
            return nil
        }
    }
}

extension MarloveService {
    static func getSession() -> Session {
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
            // By default, certificates included in the app bundle are pinned automatically.
            "marlove.net": PinnedCertificatesTrustEvaluator(),
        ]

        let manager = ServerTrustManager(evaluators: serverTrustPolicies)
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }
}
