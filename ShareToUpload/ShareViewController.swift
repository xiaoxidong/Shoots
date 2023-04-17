//
//  ShareViewController.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/12.
//

import SwiftUI

class ActionViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = UploadView(uploadImages: [])

        view = UIHostingView(rootView: contentView)
        view.isOpaque = true
        view.backgroundColor = .systemBackground
    }

}
