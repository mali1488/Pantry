//  Created by Mattias on 2015-10-10.
//  Copyright © 2015 Mattias. All rights reserved.

import Foundation
import UIKit

class Pentry : UIViewController, UITableViewDelegate,UITableViewDataSource {
    var articles = []
    var articleIndex : Int?
    
    @IBOutlet weak var tableViewReference: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viedDidLoad")
        let tabController = self.tabBarController! as! TabBarController
        print(tabController.articles)
        self.articles = tabController.articles
        
        self.tableViewReference.delegate = self
        self.tableViewReference.dataSource = self
        self.tableViewReference.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableViewReference.layer.masksToBounds = true
        self.tableViewReference.layer.borderColor = UIColor(red: 64/255, green: 152/255, blue:156/255, alpha: 0.0).CGColor
        self.tableViewReference.layer.borderWidth = 2.0
        self.tableViewReference.layer.cornerRadius = 5
        self.tableViewReference.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
        self.tableViewReference.separatorColor = UIColor(white: 1, alpha: 0)
        print("pentry loded itemscount\(self.articles.count)")
    }
    
    func details(sender:UIButton){
        print("pressed details")
        let cell = sender.superview as! UITableViewCell
        let index = self.tableViewReference.indexPathForCell(cell)
        print(index)
        self.articleIndex = index?.row
        print(self.articleIndex)
        self.performSegueWithIdentifier("details", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueId = segue.identifier!
        switch(segueId) {
        case "details":
            let destController : Details =  segue.destinationViewController as! Details
            destController.article = self.articles[self.articleIndex!] as! Article
            destController.articles = self.articles
            break;
        default:
            break;
        }
    }
    
    // -------- TableView functions --------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("You pressed detail #\(indexPath.row)!")
        //self.tempInst = indexPath.row
        self.performSegueWithIdentifier("details", sender: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableViewReference!.dequeueReusableCellWithIdentifier("cell")
        let article = self.articles[indexPath.row] as! Article
        let name = article.name
        let ean = article.ean!
        let white = UIColor(red: 244/255, green: 244/255, blue:244/255, alpha: 1.0) as UIColor
        cell!.textLabel?.text = "\(name), ean: \(ean)"
        //cell!.textLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0)
        cell!.textLabel?.textColor = white
        cell!.alpha = 0
        let bgColorView = UIView()
        cell!.backgroundColor = UIColor(red: 64/255, green: 152/255, blue:156/255, alpha: 0.0)
        bgColorView.backgroundColor = UIColor(white: 1, alpha: 0)
        cell!.selectedBackgroundView = bgColorView
        
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 50, 50)
        button.backgroundColor =  UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 0.0)
        //button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0), forState: UIControlState.Normal)
        button.setTitleColor(white, forState: UIControlState.Normal)
        button.setTitle("Details", forState: UIControlState.Normal)
        //button.titleLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0)
        button.addTarget(self, action: "details:", forControlEvents: UIControlEvents.TouchUpInside)
        //button.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        cell!.accessoryView = button
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
}