//
//  UserActivityTimeout.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import Foundation

class UserActivityTimeout {
    
    static var shared = UserActivityTimeout()
    
    private var timer: Timer!
    private var lastActivity = Date()
    private let heartbeatInterval: TimeInterval = Measurement(value: 1, unit: UnitDuration.seconds).value
    private let timeoutInterval: TimeInterval = Measurement(value: 20, unit: UnitDuration.minutes).converted(to: UnitDuration.seconds).value
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: heartbeatInterval, target: self, selector: #selector(heartbeat), userInfo: nil, repeats: true)
    }
    
    public func registerActivity() {
        lastActivity = Date()
    }
    
    @objc func heartbeat() {
        if lastActivity.addingTimeInterval(timeoutInterval) < Date() {
            NotificationCenter.default.post(name: .onShouldLogOut, object: self, userInfo: ["UserInactivityTimeout": true])
        }
    }
}
