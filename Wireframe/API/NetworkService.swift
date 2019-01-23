//
//  NetworkService.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import Foundation

struct NetworkService {
    
    static var tasks: [URLResource: [URLSessionDataTask]] = [:]
    static var cache: [URLResource: NetworkResponse] = [:]
    
    /**
     
     The standard network request.
     
     Parameter resource - A URL Resource including url, method, parameters, and headers.
     Parameter cache - Causes Prado to cache the result and to return cached results.
     Parameter completion - The result of the network call, a response object.
     
     */
    static func request(_ resource: URLResource, enableCache: Bool, completion: @escaping (NetworkResponse) -> ()) {
        
        if enableCache, var response = cache[resource] {
            response.cache = true
            completion(response)
            return
        }
        
        cache[resource] = nil
        
        guard let request = buildRequestFor(resource) else {
            let error = NetworkError(message: "Unable to build URL.")
            let response = NetworkResponse(error: error)
            completion(response)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    let response = NetworkResponse(error: error!)
                    completion(response)
                    return
            }
            
            guard let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                let error = NetworkError(message: "Unable to serialize response into JSON.")
                completion(NetworkResponse(error: error))
                return
            }
            
            let networkResponse: NetworkResponse
            
            if enableCache {
                networkResponse = NetworkResponse(json: responseObject, cacheTime: Date())
                cache[resource] = networkResponse
            } else {
                networkResponse = NetworkResponse(json: responseObject)
            }
            
            completion(networkResponse)
            return
        }
        
        task.resume()
        
        if tasks[resource] == nil {
            tasks[resource] = []
        }
        
        tasks[resource]?.append(task)
    }
    
    private static func buildRequestFor(_ resource: URLResource) -> URLRequest? {
        guard resource.url != nil, var components = URLComponents(string: resource.url!) else {
            return nil
        }
        
        if resource.method == .GET {
            if let parameters = resource.parameters {
                components.queryItems = parameters.map { (key, value) in
                    URLQueryItem(name: key, value: value)
                }
                components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = resource.method.rawValue
        
        if resource.method == .POST || resource.method == .DELETE {
            if let parameters = resource.parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
        }
        
        if let headers = resource.headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        return request
    }
    
    static func cancelActiveTasksFor(_ resource: URLResource) {
        for activeResource in NetworkService.tasks {
            
            // Cancels all tasks against an endpoint regardless of the parameters/arguments used.
            if activeResource.key.url == resource.url {
                
                for task in activeResource.value {
                    task.cancel()
                }
                
                NetworkService.tasks[activeResource.key] = []
            }
        }
    }
    
    static func flushCache() {
        cache = [:]
    }
}

/**
 
 The standard response object from a network request.
 includes .json, .error for easy access to both.
 
 */
struct NetworkResponse {
    var json: JSON?
    var error: NetworkError?
    var cache = false
    var cacheTime: Date?
    
    init(error: NetworkError) {
        self.error = error
    }
    
    init(error: Error) {
        print("handle standard Error")
    }
    
    init(json: JSON) {
        self.json = json
    }
    
    init(json: JSON, cacheTime: Date) {
        self.json = json
        self.cacheTime = cacheTime
    }
}

struct NetworkError: Error {
    var message: String?
}

struct URLResource: Hashable {
    var url: String?
    var method: URLMethod
    var headers: [String: String]?
    var parameters: [String: String]?
    
    static func ==(lhs: URLResource, rhs: URLResource) -> Bool {
        return (lhs.url == rhs.url) &&
            (lhs.method == rhs.method) &&
            (lhs.headers == rhs.headers) &&
            (lhs.parameters == rhs.parameters)
    }
}

enum URLMethod: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

typealias JSON = [String: Any]
