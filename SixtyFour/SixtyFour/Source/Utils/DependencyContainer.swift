//
//  DependencyContainer.swift
//  SixtyFour
//
//  Created by Alessio Roberto on 03/07/2020.
//  Copyright © 2020 Alessio Roberto. All rights reserved.
//

import Foundation

protocol HasLocalStorageService {
    var localStorage: LocalStorageService { get }
}

struct AppDependency: HasLocalStorageService {
    var localStorage: LocalStorageService
}

class DependencyContainer {
    private lazy var localStorage: LocalStorageService = LocalStorage()

    func makeContainer() -> AppDependency {
        AppDependency(localStorage: localStorage)
    }
}
