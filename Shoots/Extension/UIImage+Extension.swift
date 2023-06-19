//
//  UIImage+Extension.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/7.
//

import SwiftUI

extension UIImage {
    class func combine(images: [LocalImageData]) -> LocalImageData {
        var image = UIImage(data: images[0].image)!
        let imagesToCombine = images.dropFirst()
        
        imagesToCombine.forEach { singleImage in
            image = UIImage.imageByCombiningImage(firstImage: image, withImage: UIImage(data: singleImage.image)!)
        }
        
        let local = LocalImageData(image: image.pngData()!, app: images[0].app, pattern: images[0].pattern, fileName: images[0].fileName, fileSuffix: images[0].fileSuffix)
        return local
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
