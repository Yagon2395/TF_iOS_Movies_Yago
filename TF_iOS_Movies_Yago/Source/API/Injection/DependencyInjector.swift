//
//  DependencyInjector.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 18/11/21.
//

import Foundation

class DependencyInjector {
    static func load() {
        DependencyManager.register(MovieService.self) {
            LiveMovieService()
        }
    }
}

