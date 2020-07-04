//
//  DependencyContainer.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

struct AppDependency {}

class DependencyContainer {
    func makeContainer() -> AppDependency {
        AppDependency()
    }
}
