//
//  ShareViewController.swift
//  ShareToUpload
//
//  Created by XiaoDong Yuan on 2023/4/12.
//

import CoreServices
import Social
import SwiftUI
import UniformTypeIdentifiers

class CustomShareViewController: UIViewController {
    private let typeImage = UTType.image.identifier

    var images: [LocalImageData] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let contentView = UploadView {
            self.cancelAction()
        } shareDoneAction: {
            self.doneAction()
        } uploadAction: {}
            .environmentObject(UserViewModel())
            .environmentObject(InfoViewModel())

        view = UIHostingView(rootView: contentView)
        view.isOpaque = true
        view.backgroundColor = .systemBackground
        
        self.isModalInPresentation = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        getItems()
        setupNavBar()
    }

    func getItems() {
//        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem, let itemProvider = extensionItem.attachments?.first else {
//            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
//            return
//        }

        // Check if object is of type text
        // https://medium.com/@damisipikuda/how-to-receive-a-shared-content-in-an-ios-application-4d5964229701
//        if itemProvider.hasItemConformingToTypeIdentifier(typeImage) {
//            share()
//        } else {
//            print("Error: No url or text found")
//            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
//        }
        let inputItem = extensionContext!.inputItems.first! as! NSExtensionItem
        let attachment = inputItem.attachments!.first!
        if attachment.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            attachment.loadItem(forTypeIdentifier: UTType.image.identifier, options: [:]) { data, _ in
                if let someURl = data as? URL {
                    let image = UIImage(contentsOfFile: someURl.path)
                    self.images.append(LocalImageData(image: image!.pngData()!, app: "", fileName: "", fileSuffix: ""))
                } else if let someImage = data as? UIImage {
//                    image = someImage
                    Defaults().set(LocalImageData(image: someImage.pngData()!, app: "", fileName: "", fileSuffix: ""), for: .shareImage)
                }
            }
        }
    }

    func share() {
        let inputItem = extensionContext!.inputItems.first! as! NSExtensionItem
        let attachment = inputItem.attachments!.first!
        if attachment.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: [:]) { data, _ in
                var image: UIImage?
                if let someURl = data as? URL {
                    let image = UIImage(contentsOfFile: someURl.path)
                    self.images.append(LocalImageData(image: image!.pngData()!, app: "", fileName: "", fileSuffix: ""))
                } else if let someImage = data as? UIImage {
//                    image = someImage
                    self.images.append(LocalImageData(image: someImage.pngData()!, app: "", fileName: "", fileSuffix: ""))
                }
            }
        } else {
            print("=====")
        }
        print("=====")
    }

    private func setupNavBar() {
        navigationItem.title = ""
        navigationController?.isNavigationBarHidden = true
//        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
//        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

//        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
//        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    @objc private func cancelAction() {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
