//
//  OCRModel.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

struct OCRModel: Codable {
    var ocrId: String
    var text: String
    var confidence: Double
    var imageString: String

    private enum CodingKeys: String, CodingKey {
        case ocrId = "_id"
        case text
        case confidence
        case imageString = "img"
    }
}

extension OCRModel: Equatable {
    static func == (lhs: OCRModel, rhs: OCRModel) -> Bool {
        lhs.ocrId == rhs.ocrId &&
            lhs.text == rhs.text &&
            lhs.confidence == rhs.confidence &&
            lhs.imageString == rhs.imageString
    }
}
