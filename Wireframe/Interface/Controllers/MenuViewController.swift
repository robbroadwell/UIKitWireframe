//
//  MenuViewController.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/4/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var fadeOutView: UIView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.25) {
            self.fadeOutView.alpha = 0.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserActivityTimeout.shared.registerActivity()
        UIView.animate(withDuration: 0.25) {
            self.fadeOutView.alpha = 0.75
        }
    }
    
    override func viewDidLoad() {
        let group = DispatchGroup()
        
        group.enter()
        MockAPI.networkRequestWithDelay(seconds: 1) { (json) in
            group.leave()
        }
        
        group.enter()
        MockAPI.networkRequestWithDelay(seconds: 2) { (json) in
            group.leave()
        }
        
        group.enter()
        MockAPI.networkRequestWithDelay(seconds: 5) { (json) in
            group.leave()
        }
        
        group.notify(queue: .global(qos: .default)) {
            self.updateDisplay()
        }
    }
    
    private func updateDisplay() {
        // bounce back to the main thread
        DispatchQueue.main.async {
            // set labels, images, etc.
        }
    }
}
