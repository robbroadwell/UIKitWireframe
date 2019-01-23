//
//  Place.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import Foundation

struct Place {
    var description: String?
    
    init(json: [String: Any]) {
        description = json["description"] as? String
    }
}
