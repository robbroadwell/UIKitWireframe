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
            let loadingAppearanceOffset: CGFloat = 0.2
            let numberOfImages = 20
            
            let alpha: CGFloat = (abs(scrollView.contentOffset.y) / 100) - loadingAppearanceOffset
            loadingImageView.alpha = min(alpha, 1.0)
            
            let imageNumber = Int(abs(scrollView.contentOffset.y)) % numberOfImages
            let imageName = "loading" + String(imageNumber)
            let image = UIImage(named: imageName)
            loadingImageView.image = image
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= 0 {
            // pull to refresh occured
        }
    }
}

