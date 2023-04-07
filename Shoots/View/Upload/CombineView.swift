//
//  CombineView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/3/24.
//

import SwiftUI

struct CombineView: View {
    @State var images: [UIImage]
    @Binding var combinedImage: UIImage?
    
    @State var selected: UIImage? = nil
    @State var topOffsets: [CGFloat] = [0, 0]
    @State var bottomOffsets: [CGFloat] = [0, 0]
    @State var orignalimages: [UIImage] = []
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    @State var scrollDisabled = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let combinedImage = combinedImage {
                Image(uiImage: combinedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 12)
            } else {
                VStack(spacing: 12) {
                    ForEach(images.indices, id:\.self) { indice in
                        Image(uiImage: images[indice])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 560)
                            .overlay {
                                Group {
                                    Color.red
                                        .opacity(0.06)
                                        .border(Color.red, width: 1)
                                        .padding(.top, topOffset)
                                        .padding(.bottom, -bottomOffset)
                                    VStack {
                                        clipButton(top: true)
                                            .offset(y: topOffset)
                                            .offset(y: -15)
                                            .highPriorityGesture(
                                                DragGesture(minimumDistance: 1)
                                                    .onChanged { value in
                                                        scrollDisabled = true
                                                        topOffset = value.translation.height
                                                    }
                                                    .onEnded { value in
                                                        scrollDisabled = false
                                                        // 裁剪原图
                                                        topOffsets[indice] += topOffset
                                                        if topOffsets[indice] < 0 {
                                                            topOffsets[indice] = 0
                                                        }
                                                        
                                                        crop(indice: indice)
                                                        // 完成之后设置为初始值
                                                        topOffset = 0
                                                    }
                                            )
                                        Spacer(minLength: 0)
                                        clipButton(top: false)
                                            .offset(y: bottomOffset)
                                            .offset(y: 15)
                                            .highPriorityGesture(
                                                DragGesture(minimumDistance: 1)
                                                    .onChanged { value in
                                                        scrollDisabled = true
                                                        bottomOffset = value.translation.height
                                                    }
                                                    .onEnded { value in
                                                        scrollDisabled = false
                                                        // 裁剪原图
                                                        bottomOffsets[indice] += bottomOffset
                                                        if bottomOffsets[indice] > 0 {
                                                            bottomOffsets[indice] = 0
                                                        }
                                                        
                                                        crop(indice: indice)
                                                        // 完成之后设置为初始值
                                                        bottomOffset = 0
                                                    }
                                            )
                                    }
                                }.opacity(selected == images[indice] ? 1 : 0)
                            }
                            .padding(.horizontal, 12)
                            .zIndex(selected == images[indice] ? 1 : 0)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selected = images[indice]
                                }
                            }
                    }.frame(maxWidth: .infinity)
                }.padding(.vertical, 36)
            }
        }.scrollDisabled(scrollDisabled)
            .background(Color.shootLight.opacity(0.1))
        .navigationTitle("点击图片进行裁剪")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        combinedImage = UIImage.combine(images: images)
//                        dismiss()
                    } label: {
                        Text("保存")
                            .font(.system(size: 16, weight: .semibold))
                            .tint(.shootBlue)
                    }
                }
            }
            .onAppear {
                orignalimages = images
                topOffsets.removeAll()
                topOffsets.append(contentsOf: Array(repeating: 0, count: images.count))
            }
    }
    
    func crop(indice: Int) {
        let height = orignalimages[indice].size.height * (UIScreen.main.bounds.width - 24) / orignalimages[indice].size.width
        let rec = CGRect(x: 0, y: topOffsets[indice], width: UIScreen.main.bounds.width - 24, height: height + bottomOffsets[indice] - topOffsets[indice])
        
        images[indice] = cropImage(orignalimages[indice], toRect: rec, viewWidth: UIScreen.main.bounds.width - 24, viewHeight: height)!
    }
    
    func clipButton(top: Bool) -> some View {
        ZStack {
            Rectangle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round, miterLimit: 4.0, dash: [15.0], dashPhase: 0.0))
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.2), x: 0, y: 0, blur: 12)
            HStack(spacing: 0) {
                Image("left")
                    .offset(x: -15)
                    .shadow(color: Color.black.opacity(0.2), x: 0, y: 0, blur: 12)
                Spacer()
                Image("right")
                    .offset(x: 15)
                    .shadow(color: Color.black.opacity(0.2), x: 0, y: 0, blur: 12)
            }
        }.contentShape(Rectangle())
    }
    
    // 裁剪图片 https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                              y: cropRect.origin.y * imageViewScale,
                              width: cropRect.size.width * imageViewScale,
                              height: cropRect.size.height * imageViewScale)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}

struct CombineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CombineView(images: [UIImage(named: "s1")!, UIImage(named: "s2")!, UIImage(named: "s3")!], combinedImage: .constant(nil))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
