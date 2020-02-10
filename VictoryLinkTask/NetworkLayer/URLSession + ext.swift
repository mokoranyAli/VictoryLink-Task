//
//  URLSession + ext.swift
//  Get Photos By Location
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import Foundation

extension URLSession {
    
    fileprivate func codableTask<T: Codable>(with url: URL, decodingType: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func photosTask<T: Codable>(with url: URL, decodingType: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, decodingType: decodingType, completionHandler: completionHandler)
    }
    
}
