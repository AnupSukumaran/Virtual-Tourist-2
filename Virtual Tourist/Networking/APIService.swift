//
//  APIService.swift
//  Virtual Tourist
//
//  Created by Sukumar Anup Sukumaran on 10/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation

//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=c7b7ac12ffa1920aec40310e139b0dda&lat=9.931233&lon=76.267303&extras=url_m&format=json&nojsoncallback=1&auth_token=72157697969001282-13a6307aa2140013&api_sig=776519a69ce4af6379ff4de388c4f2b0

class APIService: NSObject {
    
    static let shared = APIService()
    var session = URLSession.shared
    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
//    func changeDataType<T>(Data: T) -> T?{
//        if let data = Data as? URLRequest {
//            return data as? T
//        }
//
//        if let url = Data as? URL {
//            return url as? T
//        }
//
//        return nil
//
//    }
//
    
    
    func getMethod (request: URLRequest, completionBlk: @escaping(Result<AnyObject>) -> ()) -> URLSessionDataTask {

        
        let task = session.dataTask(with: request ) { (data, response, error) in
            guard error == nil else {print("Error 😩");return}
            guard let data = data else {print("data😩");return}
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionBlk(.Error("Error :( status code -> \((response as! HTTPURLResponse).statusCode)"))
                return
            }
            
            self.convertDataToObject(data, completionBlk: completionBlk)
            
        }
        
        task.resume()
        
        return task
    }
    
    func getMethodForURL (urlType: URL, completionBlk: @escaping(Result<Data>) -> ()) -> URLSessionDataTask {
        
        
        let task = session.dataTask(with: urlType ) { (data, response, error) in
            guard error == nil else {completionBlk(.Error(error!.localizedDescription));return}
            guard let data = data else {completionBlk(.Error(error!.localizedDescription));return}
            completionBlk(.Success(data))
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                completionBlk(.Error("Error :( status code -> \((response as! HTTPURLResponse).statusCode)"))
//                return
//            }
//
//            self.convertDataToObject(data, completionBlk: completionBlk)
            
        }
        
        task.resume()
        
        return task
    }
    
    //MARK: func To make JSONSerialization objects
    private func convertDataToObject(_ data: Data, completionBlk: @escaping(Result<AnyObject>) -> ()) {
        
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            completionBlk(.Success(parsedResult))
        } catch let error  {
            completionBlk(.Error(error.localizedDescription))
        }
        
        
    }
    
    func bbox(lat: Double, long: Double) -> String {
        
            let miniLon = max(long - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
            let miniLat = max(lat - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            let maxLon = max(long + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            let maxLat = max(lat - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
            
            return "\(miniLon),\(miniLat),\(maxLon),\(maxLat)"
     
    }
    
    func getAllImages(lat: Double, long: Double, completion: @escaping(Result<ModelClassResponse>) -> ()) {
       
        let bBox = bbox(lat: lat, long: long)
        let randomPage = Int(arc4random_uniform(100))
        
        let methodParameters = [Constants.keys.SafeSearch: Constants.values.UseSafeSearch,
                                Constants.keys.Extras: Constants.values.MediumURL,
                                Constants.keys.BoundingBox: bBox,
                                Constants.keys.APIKey: Constants.values.APIKey,
                                Constants.keys.Method: Constants.values.SearchMethod,
                                Constants.keys.Format: Constants.values.ResponseFormat,
                                Constants.keys.NoJSONCallback: Constants.values.DisableJSONCallback,
                                Constants.keys.Page: randomPage,
                                Constants.keys.Per_page: Constants.values.perPage] as [String : AnyObject]
        
        let request = URLRequest(url: flickrURLFromParameters(methodParameters))
        
        let _ = getMethod(request: request) { (response) in
            switch response {
            case .Success(let data):
                guard let jsonData = data as? JSON else {return}
                
                let galleryData = ModelClassResponse(json: jsonData)
                
                DispatchQueue.main.async {
                    completion(.Success(galleryData))
                }
                
                
            case .Error(let error):
                
                DispatchQueue.main.async {
                     completion(.Error(error))
                }
               
                break
            }
        }
    }
    
    func getSingleImage(url: URL, completion: @escaping(Result<Data>) -> ()) {
        
        let _ = getMethodForURL (urlType: url) { (response) in
            switch response {
            case .Success(let data):
                //guard let imageData = data  else {return}
              
                DispatchQueue.main.async {
                    completion(.Success(data))
                }
                
                
            case .Error(let error):
                
                DispatchQueue.main.async {
                    completion(.Error(error))
                }
                
                break
            }
        }
        
    }
    
}
