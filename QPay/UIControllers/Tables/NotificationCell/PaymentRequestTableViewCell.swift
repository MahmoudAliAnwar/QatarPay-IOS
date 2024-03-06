//
//  PaymentRequestTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/25/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Combine

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requestBackgroundView: UIView!
    @IBOutlet weak var requestmageView: UIImageView!
    @IBOutlet weak var requestDescription: UILabel!
    @IBOutlet weak var requestTime: UILabel!
    
    var notification: NotificationModel? {
        didSet {
            
            if notification?.isReadByUser == false {
                self.requestBackgroundView.backgroundColor = .mUnread_Notification
            }else if notification?.isReadByUser == true {
                self.requestBackgroundView.backgroundColor = .clear
            }
            
            if let imgUrl = notification?.sendByUserImageLocation {
                let url = correctUrlString(urlString: imgUrl)

                /// Show Image From Cache
                if let murl = URL(string: url) {
                    self.cancellable = loadImage(for: murl).sink { [unowned self] image in
                        if let img = image {
                            self.showImage(image: img)
                        }
                    }
                }
                
                /// Show Image From URL
//                getImageFromURLString(urlString: url) { (status, image) in
//                    if status {
//                        if let img = image {
//                            self.requestmageView.image = img
//                        }
//                    }
//                }
            }
            
            if let message = notification?.message {
                self.requestDescription.text = message
            }
            
            if let dateString = notification?.deliveredTime {
                let resDate = dateString.server1StringToDate()
                
                if let date = resDate {
                    self.requestTime.text = date.formatDate("MMM dd, yyyy - hh:mm a")
                }
            }
        }
    }
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.requestmageView.image = .ic_avatar
//        self.requestmageView.alpha = 0.0
        self.animator?.stopAnimation(true)
        self.cancellable?.cancel()
    }

    private func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
            .flatMap({ url -> AnyPublisher<UIImage?, Never> in
//            let url = URL(string: url)!
            return ImageLoader.shared.loadImage(from: url)
        })
        .eraseToAnyPublisher()
    }

    private func showImage(image: UIImage) {
//        self.requestmageView.alpha = 0.0
        self.animator?.stopAnimation(false)
        self.requestmageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
//            self.requestmageView.alpha = 1.0
        })
    }
}

// MARK: - ACTIONS

extension NotificationTableViewCell {
    
    @IBAction func optionAction(_ sender: UIButton) {
        
        if let parent = self.parentViewController as? NotificationsViewController, let not = self.notification {
            parent.openRemoveNotificationView(not)
        }
//        if self.notification?.typeID == 10 {
//            if let parent = self.parentViewController as? NotificationsViewController {
//                let vc = UIStoryboard.view(view: .ConfirmPaymentRequestViewController) as! ConfirmPaymentRequestViewController
//                vc.notification = self.notification
//                vc.updateViewElementDelegate = self
//                parent.present(vc, animated: true)
//            }
//        }
    }
}

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension NotificationTableViewCell: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if let parent = self.parentViewController as? NotificationsViewController {
            if view is ConfirmPaymentRequestViewController || view is ConfirmPinCodeViewController {
                parent.viewWillAppear(true)
            }
        }
    }
}
