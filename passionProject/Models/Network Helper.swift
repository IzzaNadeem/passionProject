//
//  Network Helper.swift
//  passionProject
//
//  Created by C4Q on 5/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

class NetworkHelper {
    private init () {}
    static let manager = NetworkHelper()
    private let session = URLSession(configuration: .default)
    
    func performDataTask(with url: URL, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async{
                if let error = error as? URLError {
                    print(error)
                    switch error {
                    case URLError.notConnectedToInternet:
                        errorHandler(AppError.noInternet)
                    default:
                        errorHandler(AppError.other(rawError: error))
                    }
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        print("Error: \(response.statusCode)")
                        errorHandler(AppError.badResponseCode(code: response.statusCode))
                    }
                }
                
                if let data = data {
                    completionHandler(data)
                }
            }
            }.resume()
    }
}
