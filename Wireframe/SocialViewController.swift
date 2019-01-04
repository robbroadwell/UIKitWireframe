//
//  SocialViewController.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/4/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell", for: indexPath) as? PlaceholderCell else {
            return UITableViewCell()
        }

        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
}

