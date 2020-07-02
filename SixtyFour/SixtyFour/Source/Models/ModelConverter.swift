//
//  ModelConverter.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

struct ModelConverter {
    static func convertToModel<T: Equatable & Codable>(from data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }

    static func convertToData<T: Equatable & Codable>(_ model: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(model)
    }

    static func convertToModels<T: Equatable & Codable>(from data: Data) -> [T]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([T].self, from: data)
    }

    static func convertToData<T: Equatable & Codable>(_ list: [T]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
}
