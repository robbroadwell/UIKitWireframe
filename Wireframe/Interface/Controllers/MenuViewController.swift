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
}
