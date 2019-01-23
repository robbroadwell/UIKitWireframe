//
//  SearchViewController.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/23/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cacheImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var predictions: [Place]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserActivityTimeout.shared.registerActivity()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        cacheImageView.isHidden = true
        predictions = nil
        
        guard let text = textField.text, text != "" else {
            activityIndicator.stopAnimating()
            return
        }
        
        activityIndicator.startAnimating()
        
        GoogleAPI.placeAutocomplete(text) { (response) in
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.predictions = response.predictions
                self.cacheImageView.isHidden = (response.cached ?? false) ? false : true
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = predictions?[indexPath.row].description
        
        return cell
    }
}
