//
//  UIImage+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/7.
//

import SwiftUI

extension UIImage {
    
    class func combine(images: [UIImage]) -> UIImage {
        var image = images[0]
        let imagesToCombine = images.dropFirst()
        
        imagesToCombine.forEach { singleImage in
            image = UIImage.imageByCombiningImage(firstImage: image, withImage: singleImage)
        }
        
        return image
    }
    class func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        let newImageWidth = max(firstImage.size.width, secondImage.size.width )
        let newImageHeight = firstImage.size.height + secondImage.size.height
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)
        
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        let secondImageDrawY: Double = Double(firstImage.size.height)
        
        firstImage.draw(at: CGPoint(x: 0, y: 0))
        secondImage.draw(at: CGPoint(x: 0, y: secondImageDrawY))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
