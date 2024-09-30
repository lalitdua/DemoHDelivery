//
//  ApiManager.swift
//  HaatDemo
//
//  Created by Dhairya on 29/09/24.
//

import UIKit
import Foundation


class ApiManager<T: Codable>: BaseApiManager {

    class func makeApiCallForGetPage(_ url: String, headers: [String: String], completion: @escaping ([String: Any]?, T?) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            completion(nil, nil) // or return an error if preferred
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers if they exist
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error while decoding response: \(error)")
                    return
                }
                
                // Check for a valid HTTP response
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        // Try to decode the response JSON
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        print("Success")
                        print("\(json ?? [:])")
                        // Decode the data into the generic model T
                        let decodedModel = try JSONDecoder().decode(T.self, from: data!)
                        completion(json, decodedModel)
                    } catch {
                        print(error)
                        completion(self.getUnknownError(error.localizedDescription), nil)
                    }
                    
                    
                } else {
                    print("Received invalid HTTP response")
                    completion(nil, nil) // or return an appropriate error
                }
            }
        }
        
        task.resume()
    }
    
    
    class func makeApiCall(_ url: String,
                           params: [String: Any] = [:],
                           headers: [String: String]? = nil,
                           method: HTTPMethod = .get,
                           requiresPinning: Bool = true,
                           completion: @escaping ([String: Any]?, T?) -> Void) {
        
        print("Params ----->", params)
        print("Full Url ----->", url)
        print("Header ----->", headers ?? [:])
        
        // Create the URLRequest
        let dataRequest = self.getDataRequest(url,
                                              params: params,
                                              method: method,
                                              headers: headers)
        
        // Execute the request
        self.executeDataRequest(dataRequest, with: completion)
    }
    
    static func executeDataRequest(_ request: URLRequest,
                                   with completion: @escaping (_ result: [String: Any]?, _ model: T?) -> Void) {
        
        if !ApiManager.isNetworkReachable {
            completion(getNoInternetError(), nil)
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // Handle response and errors
                if let error = error {
                    print(self.getUnknownError(error.localizedDescription))
                    completion(self.getUnknownError(error.localizedDescription), nil)
                    return
                }
                
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(self.getUnknownError(), nil)
                    return
                }
                
                do {
                    // Try to decode the response JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print("Success")
                    print("\(json ?? [:])")
                    // Decode the data into the generic model T
                    let decodedModel = try JSONDecoder().decode(T.self, from: data)
                    completion(json, decodedModel)
                } catch {
                    print(error)
                    completion(self.getUnknownError(error.localizedDescription), nil)
                }
            }
        }
        
        task.resume()
    }
}

class BaseApiManager: NSObject {
    
    class var isNetworkReachable: Bool {
        // Add your own reachability check
        return true // Assuming network is reachable for now
    }
    
    class func getDataRequest(_ url: String,
                              params: [String: Any] = [:],
                              method: HTTPMethod = .post,
                              headers: [String: String]? = nil) -> URLRequest {
        
        guard let url = URL(string: url) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers to the request
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add parameters based on the method type
        if method == .get {
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            request.url = urlComponents?.url
            request.setValue("en-US", forHTTPHeaderField: "Accept-language")
        } else {
            // For non-GET methods (POST, PUT, etc.), encode parameters as JSON in the body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }
        
        return request
    }
}

extension BaseApiManager {
    static func getNoInternetError() -> [String: Any] {
        return ["message": "No internet connection",
                "statusCode": 503]
    }
    
    static func getUnknownError(_ message: String? = nil) -> [String: Any] {
        return ["message": message ?? "Internal server error",
                "statusCode": 503]
    }
}


enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}
