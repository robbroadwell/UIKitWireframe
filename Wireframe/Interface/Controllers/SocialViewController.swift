//
//  SocialViewController.swift
//  Wireframe
//
//  Created by Rob Broadwell on 1/4/19.
//  Copyright © 2019 Rob Broadwell. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    
    let transition = SlideOverAnimator()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBAction func menu(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let menuController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {
            return
        }
        
        menuController.transitioningDelegate = self
        present(menuController, animated: true, completion: nil)
        
    }
    
    // MARK: - UIViewControllerTransitioningDelegate Functions
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell", for: indexPath) as? PlaceholderCell else {
            return UITableViewCell()
        }

        return cell
    }
    
    // MARK: - Pull to Refresh
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            
            // 0.0 - 1.0: larger numbers delay how far down the pull needs to be before the spinner appears.
            let loadingAppearanceOffset: CGFloat = 0.2
            
            // 1 - 5: larger numbers slow down the rotation speed of the spinner.
            let loadingAppearanceSpeed: CGFloat = 3
            
            // Set with the number of images in assets.xcassets. More images will make for a smoother animation.
            let loadingNumberOfImages: Int = 20
            
            let alpha: CGFloat = (abs(scrollView.contentOffset.y) / 100) - loadingAppearanceOffset
            let imageNumber = Int(abs(scrollView.contentOffset.y) / loadingAppearanceSpeed) % loadingNumberOfImages
            let imageName = "loading" + String(imageNumber)
            let image = UIImage(named: imageName)
            
            loadingImageView.alpha = min(alpha, 1.0)
            loadingImageView.image = image
            loadingImageView.tintColor = UIColor.init(hexString: "C9CBDE")
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -20 {
            // A pull to refresh occured. Make your network calls.
        }
    }
}

