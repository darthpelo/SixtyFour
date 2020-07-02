//
//  UIImage+Base64.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import UIKit

public extension UIImage {
    convenience init?(base64String: String) {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }

        self.init(data: imageData)
    }
}
