//
//  PaymentWebViewController.swift
//  QPay
//
//  Created by Mahmoud on 01/02/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit
import WebKit


class PaymentWebViewController: ViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
     var paymentSucces: (()-> ())?
     var paymentFailure: (()-> ())?
   
    var link: String?
    convenience init( link: String){
        self.init()
        self.link = link
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        guard let url = URL(string: link ?? "") else {
            return
        }
        webView.load(URLRequest(url: url ))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
   
    
    
}


extension PaymentWebViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        
        self.showLoadingView(self)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        self.showLoadingView(self)
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        
        self.hideLoadingView()
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            self.showLoadingView(self)
            
            let string = url
          
            if string.contains("True") || string.contains("SUCCESS"){
                self.hideLoadingView()
                self.navigationController?.popViewController(animated: true)
                self.paymentSucces?()

            }else if  string.contains("false") || string.contains("FAILURE"){
                self.hideLoadingView()
                self.navigationController?.popViewController(animated: true)
                self.paymentFailure?()
              
            }
        }
    }
    
   
    
}

