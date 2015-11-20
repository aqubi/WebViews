//
//  UIWebViewController.swift
//  WebViewSample
//
//  Created by hideko on 11/21/15.
//  Copyright © 2015 Flask LLP. All rights reserved.
//

import UIKit

class UIWebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var requestURL:NSURL?
    var start:NSDate!
    let formatter = NSDateFormatter()
    
    override func loadView() {
        super.loadView()
        logTextView.text = ""
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "hh:mm:ss:SSS"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = requestURL {
            let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 60)
            self.start = NSDate()
            logTextView.text = "\(formatter.stringFromDate(start)) loadRequest"
            webView.loadRequest(request);
        } else {
            logTextView.text = "No URL"
        }
    }
    
    
    //MARK: UIWebViewDelegate implements
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) shouldStartLoadWithRequest"
        if let url = request.URL {
            logTextView.text = logTextView.text + " [\(url.absoluteString)]"
        }
        if (request.cachePolicy !=  .ReloadIgnoringLocalCacheData) {
            if let req = request as? NSMutableURLRequest {
                req.cachePolicy = .ReloadIgnoringLocalCacheData;
            }
        }
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        indicatorView.startAnimating()
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) webViewDidStartLoad"
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        indicatorView.stopAnimating()
        let diff = NSDate().timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        let time = NSString(format: "%0.2f" , diff)
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) webViewDidFinishLoad \(time) s"
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
}
