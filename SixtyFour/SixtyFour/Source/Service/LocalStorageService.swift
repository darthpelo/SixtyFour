//
//  LocalStorageService.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 06/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

protocol LocalStorageService {
    func write<T: Equatable>(data: T) -> Bool
    func read() -> OCRModel?
    func read() -> [OCRModel]?
}

struct LocalStorage: LocalStorageService {
    private var userDefaults: UserDefaults
    private static let suitName = "com.alessioroberto.SistyFour.suitName"

    init(_ suiteName: String = suitName) {
        userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }

    func write<T>(data: T) -> Bool where T: Equatable {
        if let data = data as? OCRModel {
            userDefaults.ocrModel = ModelConverter.convertToData(data)
            return true
        } else if let data = data as? [OCRModel] {
            userDefaults.ocrModel = ModelConverter.convertToData(data)
            return true
        }
        return false
    }

    func read() -> OCRModel? {
        guard let data = userDefaults.ocrModel else { return nil }

        return ModelConverter.convertToModel(from: data)
    }

    func read() -> [OCRModel]? {
        guard let data = userDefaults.ocrModel else { return nil }

        return ModelConverter.convertToModels(from: data)
    }
}
