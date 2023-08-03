//
//  WaitingViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/18/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class LoadingViewController: ViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var gifImageView: UIImageView!
    
    var isLoadingViewPresenting = false
    
    private static var viewObject: LoadingViewController?
    
    static var loadingView: LoadingViewController {
        if let object = viewObject {
            return object
        }else {
            let view = Views.LoadingViewController.storyboardView as! LoadingViewController
            return view
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.gifImageView.loadGif(name: "loading")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20) {
            if self.isLoadingViewPresenting {
//                print("Loading View close")
                self.closeView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.isLoadingViewPresenting = true
        
//        self.indicatorView.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.isLoadingViewPresenting = false
//        print("Status \(self.isLoadingViewPresenting)")
    }
}

// MARK: - PRIVATE FUNCTIONS

extension LoadingViewController {

    private func closeView(_ completion: voidCompletion? = nil) {
        self.dismiss(animated: true) {
//            self.indicatorView.stopAnimating()
//            if let comp = completion {
//                comp()
//            }
        }
    }
}

