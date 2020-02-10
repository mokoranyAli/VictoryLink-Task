//
//  FlickerAPI.swift
//  Get Photos By Location
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import Foundation


enum SearchingType{
    case Text (search:String)
    case Coordinates(lat:Double , long:Double)
}

class FlickerAPI{
    
    
    fileprivate let flickrKey = "a0ec4ce570ff652cdf19e3ffc5519912"
    var requestCancelStatus = false
    
    enum Result<value>{
        case success(value)
        case failure(Error?)
    }
    
    fileprivate var task: URLSessionTask?
    
    //MARK: - Make URL here based on keyword & page counts
    fileprivate func getURL_Path(_ pageCount: Int, and type: SearchingType) -> URL?{
        
        let urlPath:URL?
        
        switch type {
        case .Text(let search):
            
            let keyword = search.removeSpace
            
            
             urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&format=json&nojsoncallback=1&safe_search=1&text=\(keyword)")
        case .Coordinates(lat: let latParam, long: let longParam) :
            
           urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&format=json&nojsoncallback=1&safe_search=\(pageCount)&lat=\(latParam)&lon=\(longParam)")
            break
            
            
        
        }
        
        
        return urlPath
    }
    
    //MARK: - Cancel all previous tasks
    func cancelTask(){
        requestCancelStatus = true
        task?.cancel()
    }
    
}

extension FlickerAPI{
    
    func requestFor<T: Codable>(searchType: SearchingType, with pageCount: Int, decode: @escaping (Codable) -> T?, completionHandler: @escaping(Result<T>) -> (Void)){
        

        
        let session = URLSession.shared
        guard let urlPath = getURL_Path(pageCount, and: searchType) else { return }
        
        //Set timeout for request
        requestTimeOut()
        
        task = session.photosTask(with: urlPath, decodingType: T.self, completionHandler: { [unowned self] photos, response, error in
            
            
            DispatchQueue.main.async {
                guard error == nil,
                    let result = photos else {
                        self.requestCancelStatus = false
                        completionHandler(.failure(error))
                        return
                }
                //print(result)
                completionHandler(.success(result))
            }
        })
        task?.resume()
    }
    
    /**
     Adding here timeout for cancel current task if any case request not getting success or taking too much time because of internet. Default time out is 15 seconds.
     */
    fileprivate func requestTimeOut(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute: {
            self.task?.resume()
        })
    }
}
