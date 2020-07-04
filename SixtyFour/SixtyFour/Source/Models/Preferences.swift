//
//  Preferences.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 04/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    var token: String
}

extension Preferences {
    static func getToken() throws -> String {
        if let path = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml) {
            return preferences.token
        } else {
            throw NSError(domain: "Failed to get the application preferences", code: 0, userInfo: nil)
        }
    }
}
