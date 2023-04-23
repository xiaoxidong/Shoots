//
//  CustomShareNavigationController.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/23.
//

import SwiftUI
import CoreServices
import Social

@objc(CustomShareNavigationController)
class CustomShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.setViewControllers([CustomShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
