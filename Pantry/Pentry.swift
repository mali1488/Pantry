//  Created by Mattias on 2015-10-10.
//  Copyright © 2015 Mattias. All rights reserved.

import Foundation
import UIKit
import AVFoundation
let GETDATA : Int = 0
class Pentry : UIViewController, UITableViewDelegate,UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate {
    /* Barcode variables */
    var session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    
    var items = ["Ströbröd","Vete mjöl","Strösocker","Bakpulver"]
    
    @IBOutlet weak var tableViewReference: UITableView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewReference.delegate = self
        self.tableViewReference.dataSource = self
        self.tableViewReference.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableViewReference.layer.masksToBounds = true
        self.tableViewReference.layer.borderColor = UIColor(red: 64/255, green: 152/255, blue:156/255, alpha: 0.0).CGColor
        self.tableViewReference.layer.borderWidth = 2.0
        self.tableViewReference.layer.cornerRadius = 5
        self.tableViewReference.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
        self.tableViewReference.separatorColor = UIColor(white: 1, alpha: 0)
        print("pentry loded itemscount\(self.items.count)")
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =  [ UIViewAutoresizing.FlexibleTopMargin ,
            UIViewAutoresizing.FlexibleBottomMargin ,
            UIViewAutoresizing.FlexibleLeftMargin ,
            UIViewAutoresizing.FlexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        do {
            let input = try AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
            session.addInput(input)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            //previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as AVCaptureVideoPreviewLayer
            previewLayer.frame = self.view.bounds
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.view.layer.addSublayer(previewLayer)
            
            // Start the scanner. You'll have to end it yourself later.
            session.startRunning()
        } catch _ {
            print("some error in initializing input")
        }
       
    }
    
    // -------- TableView functions --------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("You pressed detail #\(indexPath.row)!")
        //self.tempInst = indexPath.row
        self.performSegueWithIdentifier("details", sender: nil)
    }
    
    func details(sender:UIButton){
        print("BUTTONPRESS")
        let cell = sender.superview as! UITableViewCell
        let index = self.tableViewReference.indexPathForCell(cell)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableViewReference!.dequeueReusableCellWithIdentifier("cell")
        let name = self.items[indexPath.row]
        let white = UIColor(red: 244/255, green: 244/255, blue:244/255, alpha: 1.0) as UIColor
        cell!.textLabel?.text = "\(name)"
        cell!.textLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0)
        cell!.alpha = 0
        let bgColorView = UIView()
        cell!.backgroundColor = UIColor(red: 64/255, green: 152/255, blue:156/255, alpha: 0.0)
        bgColorView.backgroundColor = UIColor(white: 1, alpha: 0)
        cell!.selectedBackgroundView = bgColorView
        
        // AccessoryType can be : DetailButton, .Checkmark .None
        //cell!.accessoryType = .DetailDisclosureButton
        //cell!.tintColor = UIColor(red: 244/255, green: 244/255, blue:244/255, alpha: 1.0)
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, 0, 50, 50)
        button.backgroundColor =  UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 0.0)
        button.setTitleColor(UIColor(red: 0.0, green: 0.0, blue:0.0, alpha: 1.0), forState: UIControlState.Normal)
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
    // ----------------------------------------
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil {
            //qrCodeFrameView?.frame = CGRectZero
            //messageLabel.text = "No QR code is detected"
            print("nil? \(metadataObjects)")
            return
        } else if (metadataObjects.count == 0) {
            print("metadata count is zero : \(metadataObjects)")
            return
        } else {
            print("read metadata")
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject = previewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                //qrCodeFrameView?.frame = barCodeObject.bounds;
                
                if metadataObj.stringValue != nil {
                    print("stringvalue is nil")
                } else {
                    print("stringvalue: \(metadataObj.stringValue)")
                }
            } else if metadataObj.type == AVMetadataObjectTypeEAN13Code {
                session.stopRunning()
                self.previewLayer.hidden = true
                let data = metadataObj as! AVMetadataMachineReadableCodeObject
                print("\(data.stringValue)")
                let article = Article(id: data.stringValue)
            }
            
        }
        // Get the metadata object.
        /*let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            //qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                print("stringvalue is nil")
            } else {
                print("stringvalue: \(metadataObj.stringValue)")
            }
        }*/
    }
    
    func captureOutput(captureOutput: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBufferRef, fromConnection connection: AVCaptureConnection) {
        
        print("frame received")
    }
}