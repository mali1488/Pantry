//
//  Details.swift
//  Pantry
//
//  Created by Mattias on 2015-10-19.
//  Copyright © 2015 Mattias. All rights reserved.
//

import Foundation
import UIKit

class Details: UIViewController {
    var article : Article!
    var articles = []
    
    /* Label outlets */
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBarcode: UILabel!
    @IBOutlet weak var labelExpired: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        if(self.article.name.characters.count > 20) {
            let str0 : String = self.article.name
            let index1 = str0.startIndex.advancedBy(str0.characters.count/2)
            let index2 = str0.endIndex.advancedBy(-str0.characters.count/2)
            let str1 = str0.substringToIndex(index1)
            let str2 = str0.substringFromIndex(index2)
            self.labelName.text = "\(str1) \n \(str2)"
        } else {
            self.labelName.text = "\(self.article.name) \n hello"
        }
        self.labelBarcode.text = "\(self.labelBarcode.text!) \(self.article.ean)"
        self.labelExpired.text = "\(self.labelExpired.text!) \(String(self.article.expired))"
        self.labelType.text = "\(self.labelType.text!) \(self.article.type)"
        self.labelWeight.text = "\(self.labelWeight.text!) \(String(self.article.weight))"
    }
    
    @IBAction func back(sender: AnyObject) {
        self.performSegueWithIdentifier("detailsBack", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueId = segue.identifier!
        switch(segueId) {
        case "detailsBack":
            let destController : TabBarController =  segue.destinationViewController as! TabBarController
            destController.articles = self.articles as! [Article]
            destController.selectedIndex = 1
            break;
        default:
            break;
        }
    }
}
