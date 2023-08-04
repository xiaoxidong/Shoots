//
//  SelectPhotoView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/4/10.
//

import Photos
import SwiftUI

struct SelectPhotoView: UIViewControllerRepresentable {
    @Binding var show: Bool
    @Binding var selectedImages: [UIImage]
    @Binding var selectedAssets: [PHAsset]

    @State var selectedResults: [ZLResultModel] = []
    @State var takeSelectedAssetsSwitch = true
    @State var isOriginal = true

    let vc = UIViewController()

    typealias UIViewControllerType = UIViewController
    func makeUIViewController(context _: Context) -> UIViewController {
//        shows()
        return vc
    }

    func updateUIViewController(_: UIViewController, context _: Context) {
        if show {
            print("-----")
        }
        vc.title = show ? "fff" : "ss"
//        if true {
//            ac.showPreview(animate: true, sender: vc)
//        } else {
//            ac.showPhotoLibrary(sender: vc)
//        }

        shows()
    }

    func shows() {
        let ac = ZLPhotoPreviewSheet(results: nil)
        let minItemSpacing: CGFloat = 2
        let minLineSpacing: CGFloat = 2

        // Custom UI
        ZLPhotoUIConfiguration.default()
//            .navBarColor(.white)
//            .navViewBlurEffectOfAlbumList(nil)
//            .indexLabelBgColor(.black)
//            .indexLabelTextColor(.white)
            .minimumInteritemSpacing(minItemSpacing)
            .minimumLineSpacing(minLineSpacing)
            .columnCountBlock { Int(ceil($0 / (428.0 / 4))) }

        // Custom image editor
        ZLPhotoConfiguration.default()
            .editImageConfiguration
//            .imageStickerContainerView(ImageStickerContainerView())
            .canRedo(true)
//            .tools([.draw, .clip, .mosaic, .filter])
//            .adjustTools([.brightness, .contrast, .saturation])
//            .clipRatios([.custom, .circle, .wh1x1, .wh3x4, .wh16x9, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)])
//            .imageStickerContainerView(ImageStickerContainerView())
//            .filters([.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)])

        /*
         ZLPhotoConfiguration.default()
             .cameraConfiguration
             .devicePosition(.front)
             .allowRecordVideo(false)
             .allowSwitchCamera(false)
             .showFlashSwitch(true)
          */

        ZLPhotoConfiguration.default()
            // You can first determine whether the asset is allowed to be selected.
            .canSelectAsset { _ in
                true
            }
            .noAuthorityCallback { type in
                switch type {
                case .library:
                    debugPrint("No library authority")
                case .camera:
                    debugPrint("No camera authority")
                case .microphone:
                    debugPrint("No microphone authority")
                }
            }

        /// Using this init method, you can continue editing the selected photo
//        ac = ZLPhotoPreviewSheet(results: takeSelectedAssetsSwitch ? selectedResults : nil)

        ac.selectImageBlock = { results, isOriginal in
//            guard let `self` = self else { return }
            self.selectedResults = results
            self.selectedImages = results.map { $0.image }
            self.selectedAssets = results.map { $0.asset }
            self.isOriginal = true

            debugPrint("images: \(self.selectedImages)")
            debugPrint("assets: \(self.selectedAssets)")
            debugPrint("isEdited: \(results.map { $0.isEdited })")
            debugPrint("isOriginal: \(isOriginal)")

            show = false
        }
        ac.cancelBlock = {
            debugPrint("cancel select")
            show = false
        }
        ac.selectImageRequestErrorBlock = { errorAssets, errorIndexs in
            debugPrint("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        ac.showPreview(animate: true, sender: vc)
    }

//    func makeCoordinator() -> SelectPhotoView.Coordinator {
//        return Coordinator(showing: $show)
//    }
//
//    class Coordinator: NSObject {
//        @Binding var showing: Bool
//
//        init(showing: Binding<Bool>) {
//            self._showing = showing
//        }
//    }
}
