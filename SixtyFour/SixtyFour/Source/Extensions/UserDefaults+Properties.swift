//
//  UserDefaults+Properties.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 02/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

extension UserDefaults {
    var ocrModel: Data? {
        get { data(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
