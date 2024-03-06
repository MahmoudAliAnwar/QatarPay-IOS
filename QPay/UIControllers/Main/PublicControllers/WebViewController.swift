//
//  WebViewViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/27/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class WebViewController: ViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var webPageUrl: URL?
    var parentView: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarView?.isHidden = true
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension WebViewController {
    
    func setupView() {
        
        self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
        
//        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
//        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
//        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        if let url = webPageUrl {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

extension WebViewController {
    
    @objc
    private func back(_ sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.navigationController?.popTo(RefillWalletViewController.self)
//        self.navigationController?.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
//            print(Float(webView.estimatedProgress))
            
        }else if keyPath == #keyPath(WKWebView.url) {
            // Whenever URL changes, it can be accessed via WKWebView instance
//            if let url = webView.url {
//
//            }
        }
    }
}

// MARK: - WEB DELEGATE

/*
 Visa for test

 4005 5500 0000 0019
 04/2023
 111
 
 4000 6200 0000 0007
 03/2030    737
 */

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        print("Redirect \(webView.url)")
        guard let requestURL = webView.url else {
            return
        }
        
        DispatchQueue.main.async {
            let callBack = self.navigationController?.checkViewIfExists(MoneyTransferViewController.self)
            guard callBack?.isExists == true else { return }
            
            let refillView = self.navigationController?.viewControllers[callBack!.index] as! MoneyTransferViewController
            if requestURL.absoluteString.contains("True") ||
                requestURL.absoluteString.contains("SUCCESS") {
                refillView.refillClousure = (false, "Wallet Refilled Successfully")
                self.navigationController?.popTo(MoneyTransferViewController.self)
                
            } else if requestURL.absoluteString.contains("false") ||
                        requestURL.absoluteString.contains("FAILURE") {
                
                refillView.refillClousure = (false, "Wallet Refilled Failed")
                self.navigationController?.popTo(MoneyTransferViewController.self)
            }
        }
            
            /// Old way ...
//            if requestURL.absoluteString.contains("message") {
//
//                DispatchQueue.global(qos: .background).async {
//
//                    URLSession.shared.dataTask(with: requestURL) { data, response, error in
//                        if let data = data {
//
//                            do {
//                                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                                if let string = object as? String {
//                                    do {
//                                        let jsonData = string.data(using: .utf8)!
//                                        let baseResponse: BaseResponse = try JSONDecoder().decode(BaseResponse.self, from: jsonData)
//                                        print(baseResponse)
//                                        DispatchQueue.main.async {
//                                            if let parent = self.parentView as? CheckoutViewController {
//                                                parent.baseResponse = baseResponse
//                                                self.navigationController?.popViewController(animated: true)
//                                            }
//                                        }
//
//                                    } catch {
//                                        print("Error \(error)")
//                                    }
//                                }
//                            } catch {
//                                print("Error \(error)")
//                            }
//                        }
//                    }.resume()
//                }
//            }
    }

//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
//
//        if(navigationAction.navigationType == .other) {
//            if let requestURL = navigationAction.request.url {
//                //do what you need with url
////                print("other => \(requestURL)")
//                if requestURL.absoluteString.contains("message") {
//
//                    URLSession.shared.dataTask(with: requestURL) { data, response, error in
//                        if let data = data {
//
//                            do {
//                                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                                if let string = object as? String {
//                                    do {
//                                        let jsonData = string.data(using: .utf8)!
//                                        let baseResponse: BaseResponse = try JSONDecoder().decode(BaseResponse.self, from: jsonData)
////                                        print(baseResponse)
//                                        DispatchQueue.main.async {
////                                            decisionHandler(.cancel)
//                                            if let parent = self.parentView as? CheckoutViewController {
//                                                parent.baseResponse = baseResponse
//                                                self.navigationController?.popViewController(animated: true)
//                                            }
//                                        }
//
//                                    } catch {
//                                        print("Error \(error)")
//                                    }
//                                }
//                            } catch {
//                                print("Error \(error)")
//                            }
//                        }
//                    }.resume()
//                }
//                //self.delegate?.openURL(url: navigationAction.request.url!)
//            }
////            decisionHandler(.allow)
////            return
//        }
//        decisionHandler(.allow)
//
//        //http://151.106.28.182:1124/api/api/NoqoodyUser/PaymentResponse/?success=False&code=OK&message=No%20transaction%20exist%20for%20the%20supplied%20transaction%20or%20order%20Id&InvoiceNo=NPIB147123063426638&reference=NWR202027290229111340&PUN=NPIB147123063426638
//        // Response "{\"success\":false,\"code\":\"BadRequest\",\"message\":\"Payment Failed \",\"errors\":[]}"
//    }
}

extension WebViewController{
}
