//
//  LoginViewController.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/4/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: BoxView!
    
    override func viewDidLoad() {
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissTap)
        
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(login))
        loginButton.addGestureRecognizer(loginTap)
    }
    
    @objc private func login() {
        performSegue(withIdentifier: "ShowSocialView", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        var info = notification.userInfo
        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        view.frame.origin.y = -(keyBoardSize.height - (tabBarController?.tabBar.frame.height ?? 0.0))
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
}
