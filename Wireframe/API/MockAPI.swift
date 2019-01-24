//
//  MockAPI.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import Foundation

struct MockAPI {
    static func networkRequestWithDelay(seconds: Double, completion: @escaping (JSON) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion(["foo": "bar"])
        }
    }
}
