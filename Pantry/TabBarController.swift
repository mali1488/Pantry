//
//  TabBarController.swift
//  Pantry
//
//  Created by Mattias on 2015-10-18.
//  Copyright © 2015 Mattias. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var items = ["apple", "pineapple"]
    var articles = []

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
    }
        
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        switch(viewController.title!) {
            case "Pentry":
                print("add item")
                let destViewController : Pentry = self.viewControllers?[1] as! Pentry
                destViewController.items = self.items
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    destViewController.tableViewReference.reloadData()
                })
                break;
            case "BarCodeScanner":
                break;
        default:
            print("bad viewcontroller check")
        }
        return true;
    }
}