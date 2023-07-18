//
//  ShareViewController.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/12.
//

import SwiftUI
import CoreServices
import Social

class CustomShareViewController: UIViewController {
    private let typeImage = String(kUTTypeImage)
    
    var images: [UIImage] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let contentView = UploadView(uploadData: .constant([]), shareExtension: true)  {
            self.cancelAction()
        } shareDoneAction: {
            self.doneAction()
        } uploadAction: {

        }
        
        view = UIHostingView(rootView: contentView)
        view.isOpaque = true
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray6
        getItems()
        setupNavBar()
    }
    
    func getItems() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        // Check if object is of type text
        // https://medium.com/@damisipikuda/how-to-receive-a-shared-content-in-an-ios-application-4d5964229701
        if itemProvider.hasItemConformingToTypeIdentifier(typeImage) {
            share()
        } else {
            print("Error: No url or text found")
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    func share() {
        let inputItem = extensionContext!.inputItems.first! as! NSExtensionItem
        let attachment = inputItem.attachments!.first as! NSItemProvider
        if attachment.hasItemConformingToTypeIdentifier( kUTTypeImage as String) {
            attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: [:]) { (data, error) in
                var image: UIImage?
                if let someURl = data as? URL {
                    image = UIImage(contentsOfFile: someURl.path)
                } else if let someImage = data as? UIImage {
                    image = someImage
                }
            }
            
        }
    }
    
    private func setupNavBar() {
        self.navigationItem.title = ""
        self.navigationController?.isNavigationBarHidden = true
//        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
//        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

//        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
//        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
