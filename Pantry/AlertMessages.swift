//  Created by Mattias on 2015-09-04.
//  Copyright (c) 2015 Mattias. All rights reserved.

import Foundation
import UIKit

class AlertMessages : UIViewController{
    var textField : UITextField?
    var currentAlert : UIAlertController?
    
    func alert(currentWindow : UIViewController, title : String, message : String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        currentWindow.presentViewController(alertController, animated: true, completion: nil)
    }
}