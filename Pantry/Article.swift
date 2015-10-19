//
//  Article.swift
//  Pantry
//
//  Created by Jakob Lindh on 2015-10-18.
//  Copyright © 2015 Mattias. All rights reserved.
//

import Foundation

class Article {
    var name : String!
    var type : String!
    var ean : String!
    var weight : Float!
    var expired : Int!
    
    init(id : String) {
        self.ean = id
        let url: NSURL = NSURL(string: "https://api.outpan.com/v1/products/\(id)")!
        let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let key : NSString = "a5035d0391db998498362ed22ea6eddc:"
        let apiKey :NSData = key.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = apiKey.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        request1.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        //self.testLabel.text = "test"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request1) {(data, response, error) in
            if(error != nil) {
                print("error: \(error)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("error form server")
                })
            } else {
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                let jsonData = NSString(data: data!, encoding: NSUTF8StringEncoding)!.dataUsingEncoding(NSUTF8StringEncoding)!
                print( "data is received")

                do {
                    let parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
                    let gtin : String! = parsed["gtin"] as! String
                    if let aname = parsed["name"] as? String {
                        print("name not nil")
                        self.name = parsed["name"] as! String
                    } else {
                        print("name is nil")
                        self.name = "Article not found"
                    }
                    // control in console
                    print("gtin/ean : \(gtin)")
                    print("name: \(self.name)")

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        print(String(parsed))
                    })
                    //self.performSegueWithIdentifier("view2Segue",sender : nil)
                    
                } catch {
                    print("A JSON parsing error occurred, here are the details")
                }
            }
        }
        task.resume()
    }
}