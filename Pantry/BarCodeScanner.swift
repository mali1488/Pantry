//
//  BarCodeScanner.swift
//  Pantry
//
//  Created by Mattias on 2015-10-18.
//  Copyright © 2015 Mattias. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class BarCodeScanner : UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    /* Barcode variables */
    var session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    /* ----------------- */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
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
                // STOP RUNNING :S
                session.stopRunning()
                //self.previewLayer.hidden = true
                let data = metadataObj as! AVMetadataMachineReadableCodeObject
                print("\(data.stringValue)")
                let article = Article(id: data.stringValue)
                let tabController = self.tabBarController! as! TabBarController
                tabController.items.append(data.stringValue)
                
                let alertController = UIAlertController(title: "Entry found", message:
                    "Added ean article with id \(data.stringValue) to pantry", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,
                    handler: {(action: UIAlertAction!) -> Void in
                        self.session.startRunning()
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
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