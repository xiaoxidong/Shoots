//
//  TitlePageControll.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI
import CHIPageControl

struct TitlePageControll: UIViewRepresentable {
    var progress: Int
    var numberOfPages: Int
    var tintColor: UIColor
    var currentPageTintColor: UIColor
    
    typealias UIViewType = CHIPageControlJalapeno
    func makeUIView(context: Context) -> CHIPageControl.CHIPageControlJalapeno {
        let pageControl = CHIPageControlJalapeno(frame: CGRect(x: 0, y:0, width: 20, height: 4))
        pageControl.numberOfPages = numberOfPages
        pageControl.radius = 4
        pageControl.tintColor = tintColor
        pageControl.currentPageTintColor = currentPageTintColor
        pageControl.enableTouchEvents = true
        
        return pageControl
    }
    
    func updateUIView(_ uiView: CHIPageControl.CHIPageControlJalapeno, context: Context) {
        uiView.set(progress: progress, animated: true)
        uiView.tintColor = tintColor
        uiView.currentPageTintColor = currentPageTintColor
    }
}
