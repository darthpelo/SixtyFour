//
//  LocalStorageService.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 06/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import CryptoKit
import Foundation

protocol LocalStorageService {
    func write<T: Equatable>(data: T) -> Bool
    func read() -> OCRModel?
    func read() -> [OCRModel]?
}

struct LocalStorage: LocalStorageService {
    private var userDefaults: UserDefaults
    private static let suitName = "com.alessioroberto.SistyFour.suitName"
    private let key = SymmetricKey(size: .bits256)

    init(_ suiteName: String = suitName) {
        userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }

    func write<T>(data: T) -> Bool where T: Equatable {
        if let obj = data as? OCRModel,
            let convertedObj = ModelConverter.convertToData(obj) {
            userDefaults.ocrModel = encryptData(convertedObj)
            return true
        } else if let obj = data as? [OCRModel],
            let convertedObj = ModelConverter.convertToData(obj) {
            userDefaults.ocrModel = encryptData(convertedObj)
            return true
        }
        return false
    }

    func read() -> OCRModel? {
        guard let data = decryptData() else { return nil }
        return ModelConverter.convertToModel(from: data)
    }

    func read() -> [OCRModel]? {
        guard let data = decryptData() else { return nil }
        return ModelConverter.convertToModels(from: data)
    }

    // MARK: - Private

    private func encryptData(_ data: Data) -> Data? {
        try? ChaChaPoly.seal(data as NSData, using: key).combined
    }

    private func decryptData() -> Data? {
        guard let encryptedContent = userDefaults.ocrModel,
            let sealedBox = try? ChaChaPoly.SealedBox(combined: encryptedContent),
            let decryptedData = try? ChaChaPoly.open(sealedBox, using: key) else {
            return nil
        }
        return decryptedData
    }
}
