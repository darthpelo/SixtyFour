//
//  NSObject+ClassIdentifier.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

extension NSObject {
    class var classIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
