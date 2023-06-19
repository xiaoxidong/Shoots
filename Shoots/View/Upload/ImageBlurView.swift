//
//  EditButton.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/4.
//

import SwiftUI

struct ImageBlurView: UIViewControllerRepresentable {
    @Binding var image: Data
    
    typealias UIViewControllerType = ZLEditImageViewController
    
    func makeUIViewController(context: Context) -> ZLEditImageViewController {
        let vc = ZLEditImageViewController(image: UIImage(data: image)!) { (resImage, editModel) in
            self.image = resImage.pngData()!
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ZLEditImageViewController, context: Context) {
        
    }
}



