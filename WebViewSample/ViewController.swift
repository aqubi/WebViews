//
//  ViewController.swift
//  WebViewSample
//
//  Created by hideko on 11/20/15.
//  Copyright © 2015 Flask LLP. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var wkwebviewButton: UIButton!
    @IBOutlet weak var safariviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSURLCache.sharedURLCache().memoryCapacity = 0
        NSURLCache.sharedURLCache().diskCapacity = 0
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        NSUserDefaults.standardUserDefaults().registerDefaults(["urlstring" : "http://google.com"])
        urlText.text = NSUserDefaults.standardUserDefaults().stringForKey("urlstring")
        
        if #available(iOS 9.0, *) {
            
        } else {
            safariviewButton.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowUIWebView" {
            let controller = segue.destinationViewController as! UIWebViewController
            if let url = NSURL(string: urlText.text!) {
                controller.requestURL = url
            }
        } else if segue.identifier == "ShowWKWebView" {
            let controller = segue.destinationViewController as! WKWebViewController
            if let url = NSURL(string: urlText.text!) {
                controller.requestURL = url
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(urlText.text, forKey: "urlstring")
        NSUserDefaults.standardUserDefaults().synchronize()
        urlText.resignFirstResponder()
    }

    @IBAction func showSafariViewController(sender: AnyObject) {
        if let url = NSURL(string: urlText.text!) {
            if url.scheme == "http" || url.scheme == "https" {
                if #available(iOS 9.0, *) {
                    let controller = SFSafariViewController(URL: url)
                    controller.title = "SFSafariViewController"
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
        }
    }
    
    //MARK: UITextFieldDelegate implements
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlText.resignFirstResponder()
        return true
    }
}

