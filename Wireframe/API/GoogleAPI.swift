//
//  GoogleAPI.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import Foundation

struct GoogleAPI {
    
    static func placeAutocomplete(_ query: String, completion: @escaping (PlaceAutocompleteResponse) -> ()) {
        
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        
        let parameters = ["input": query,
                          "key": Secret.APIKey]
        
        let resource = URLResource(url: url, method: .GET, headers: nil, parameters: parameters)
        
        // Cancel any network requests for the PlaceAPI currently in-flight.
        NetworkService.cancelActiveTasksFor(resource)
        
        // `withCache` will cache the response from the first request
        // and all subsequent requests will return that cached result.
        NetworkService.request(resource, enableCache: true) { (response) in
            guard response.error == nil, response.json != nil else {
                completion((nil, nil))
                return
            }
            
            var places = [Place]()
            
            if let predictions = response.json?["predictions"] as? [Any] {
                for place in predictions {
                    if let dictionary = place as? [String:Any] {
                        places.append(Place(json: dictionary))
                    }
                }
            }
            
            completion((places, response.cache))
        }
    }
}

/// Wrapper for the response model to include if it came from the cache.
typealias PlaceAutocompleteResponse = (predictions: [Place]?, cached: Bool?)

