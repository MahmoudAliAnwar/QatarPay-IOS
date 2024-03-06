//
//  AlertView.swift
//  kulud
//
//  Created by Hussam Elsadany on 04/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Loaf

public enum AlertViewState {
    case success
    case error
    case warning
    case info
}

struct AlertView {
    
    private init() {}
    
    static func show(message: String, state: AlertViewState, sender: UIViewController) {
        Loaf(message,
                  state: getState(state: state),
                  location: .top,
                  presentingDirection: .vertical,
                  dismissingDirection: .vertical,
                  sender: sender)
            .show()
    }
    
    private static func getState(state: AlertViewState) -> Loaf.State {
        
        var loafState: Loaf.State!
        
        switch state {
        case .success:
            loafState = .success
        case .error:
            loafState = .error
        case .warning:
            loafState = .warning
        case .info:
            loafState = .info
        }
        return loafState
    }
}
