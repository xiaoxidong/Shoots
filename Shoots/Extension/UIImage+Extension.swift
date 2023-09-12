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

        var tags: [String] = []
        images.forEach { i in
            i.tags.forEach { tag in
                if !tag.contains(tag) {
                    tags.append(tag)
                }
            }
        }
        let local = LocalImageData(image: image.pngData()!, app: images[0].app, fileName: images[0].fileName, fileSuffix: images[0].fileSuffix, chooseType: images[0].chooseType, picDescription: images[0].picDescription, tags: tags)
        return local
    }

    class func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        let newImageWidth = max(firstImage.size.width, secondImage.size.width)
        let newImageHeight = firstImage.size.height + secondImage.size.height
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)

        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        let secondImageDrawY = Double(firstImage.size.height)

        firstImage.draw(at: CGPoint(x: 0, y: 0))
        secondImage.draw(at: CGPoint(x: 0, y: secondImageDrawY))

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }
}
