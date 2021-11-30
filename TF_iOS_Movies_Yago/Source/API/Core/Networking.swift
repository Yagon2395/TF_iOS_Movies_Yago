//
//  Networking.swift
//  TF_iOS_Movies_Yago
//
//  Created by Desenvolvimento on 18/11/21.
//

import Foundation

protocol Networking {
    func perform(with request: URLRequest,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Networking {
    func perform(with request: URLRequest,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}
