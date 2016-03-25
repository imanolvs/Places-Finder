//
//  RootPageViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 15/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class RootPageViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var photoReferences : [String]!
    var pageViewController : UIPageViewController!
    var firstIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    private func reset() {
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        
        let pageContentViewController = viewControllerAtIndex(firstIndex)
        pageViewController.setViewControllers([pageContentViewController!], direction: .Forward, animated: true, completion: nil)
        
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if photoReferences.count == 0 { return nil }
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
    
        pageContentViewController.image = retrievePhotoImage(photoReferences[index])
        pageContentViewController.pageIndex = index

        return pageContentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        if index == 0 { return nil }
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        index += 1
        if index == photoReferences.count { return nil }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return photoReferences.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return firstIndex
    }
}

extension RootPageViewController {
    
    private func retrievePhotoImage(photoReference: String) -> UIImage? {
        
        return ImageCache.sharedInstance().imageWithIdentifier(photoReference)
    }
}
