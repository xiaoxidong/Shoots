//
//  ImageCropperView.swift
//
//
//  Created by Anthony Fernandez on 12/18/20.
//

import SwiftUI

public struct ImageCropperView: View {
    @Binding var inputImage: NSImage?
    @Binding var cropedImage: NSImage?

    @State var rect: CGRect = .zero
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                MacCloseButton()
                Spacer()
                Text("裁剪头像")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.shootGray)
                Spacer()
                saveButton
            }.padding()
            
            if let images = cropedImage {
                Image(nsImage: images)
                    .resizable()
                    .scaledToFit()
            }
            else if let image = inputImage {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        GeometryReader { reader in
                            CropperView(viewModel: CropperViewModel(parentProxy: reader, cropRect: nil, ratio: CropperRatio(width: 1, height: 1), onCropChanged: { rect in
                                self.rect = rect
                            }))
                        }
                    )
            }
        }
    }
    
    var saveButton: some View {
        Button {
            save()
        } label: {
            Text("保存")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.shootBlack)
                .padding(4)
                .contentShape(Rectangle())
        }.buttonStyle(.plain)
    }
    
    @Environment(\.presentationMode) var mode
    func save() {
        if let image = inputImage {
            let size = image.size
            let width = rect.size.width - rect.origin.x
            let height = rect.size.height - rect.origin.y
            let realRect = CGRect(x: size.width * rect.origin.x, y: size.height * rect.origin.y, width: size.width * width, height: size.height * height)
            cropedImage = NSImage(cgImage: (image.cgImage?.cropping(to: realRect))!, size: .zero)
            mode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Public API

//public extension ImageCropperView {
//    func onCropChanged(_ action: @escaping ((CGRect) -> Void)) -> Self {
//        var copy = self
//        copy.onCropChanged = action
//        return copy
//    }
//}
