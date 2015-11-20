//
//  WKWebViewController.swift
//  WebViewSample
//
//  Created by hideko on 11/21/15.
//  Copyright © 2015 Flask LLP. All rights reserved.
//

import UIKit
import WebKit

@available(iOS 8.0, *)
class WKWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var progressView:UIProgressView!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var webView:WKWebView!
    var requestURL:NSURL?
    var start:NSDate!
    let formatter = NSDateFormatter()
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.UIDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        let topLayout = NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
        let bottomLayout = NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let leadingLayout = NSLayoutConstraint(item: webView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        let trailingLayout = NSLayoutConstraint(item: webView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        self.view.insertSubview(webView, atIndex: 0)
        self.view.addConstraints([topLayout, bottomLayout, leadingLayout, trailingLayout])
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "hh:mm:ss:SSS"
        logTextView.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let url = requestURL {
            let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 60)
            self.start = NSDate()
            logTextView.text = "\(formatter.stringFromDate(start)) loadRequest"
            webView.loadRequest(request)
        } else {
            logTextView.text = "No URL"
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) estimatedProgress \(webView.estimatedProgress)"

        } else if keyPath == "loading" {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
            if webView.loading {
                logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) loading start"
                indicatorView.startAnimating()
            } else {
                let diff = NSDate().timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
                let time = NSString(format: "%0.2f" , diff)
                logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) loading end \(time) s"
                indicatorView.stopAnimating()
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.stopLoading()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: WKUIDelegate implements
//    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        return webView
//    }
    
    //MARK: WKNavigationDelegate implements
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) didStartProvisionalNavigation"
    }
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) didReceiveServerRedirectForProvisionalNavigation"
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) didFailProvisionalNavigation"
        print(error)
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) didCommitNavigation"
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) didFinishNavigation"
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        logTextView.text = logTextView.text + "\n\(formatter.stringFromDate(NSDate())) didFailNavigation"
        print(error)
    }
}
