//
//  EditButton.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/4.
//

import SwiftUI

struct EditButton: UIViewControllerRepresentable {
    @Binding var image: UIImage
    
    typealias UIViewControllerType = ZLEditImageViewController
    
    func makeUIViewController(context: Context) -> ZLEditImageViewController {
        let vc = ZLEditImageViewController(image: image) { (resImage, editModel) in
            self.image = resImage
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ZLEditImageViewController, context: Context) {
        
    }
}



