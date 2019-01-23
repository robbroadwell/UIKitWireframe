//
//  RootNavigationController.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserActivityTimeout.shared.registerActivity()
        NotificationCenter.default.addObserver(self, selector: #selector(logOut), name: .onShouldLogOut, object: nil)
    }
    
    @objc func logOut() {
        popToRootViewController(animated: false)
    }
}
