//
//  VideoTrimmer.swift
//  Items
//
//  Created by Ian on 23/06/2022.
//

import SwiftUI
import AVFoundation
import Photos

@available(iOS 14.0, macOS 11, *)
public struct VideoEditor: View {
    @Binding var videoURL: URL?
    @Binding var selectedImages: [UIImage]
    
    @StateObject private var videoUtil: VideoUtil = VideoUtil()
    @StateObject private var playerVM = PlayerViewModel()
    
    @State private var isShowingControlButtonNames: Bool = false
    @State private var isShowingSlider: Bool = false
    
    @State private var isExporting = false
    @State private var isExportCompletedSuccessfully: Bool = false {
        didSet { playerVM.isShowingControls = isExportCompletedSuccessfully }
    }
    @State private var exportedVideoURL: URL? = nil
    
    @Environment(\.dismiss) var dismiss
    public var body: some View {
        ZStack {
            if videoURL != nil {
                videoPlayer
            } else {
                SpinnerView()
            }
            videoOverlay
        }
        .background(Color.black.ignoresSafeArea(.all))
        .transition(.move(edge: .bottom))
        .overlay {
            if isExporting {
                exportingOverlay
            }
        }
        .onAppear(perform: initialiseOrResetEditor)
        .onDisappear {
            playerVM.pause()
            cancelButtonActions()
        }
        .environmentObject(videoUtil)
        .environmentObject(playerVM)
        .onChange(of: videoURL) { newValue in
            initialiseOrResetEditor()
        }
    }
    
    var videoPlayer: some View {
        Group {
            if isExportCompletedSuccessfully {
                CustomVideoPlayer()
                    .padding(.top)
            } else {
                CustomVideoPlayer()
            }
        }
    }
    
    var videoOverlay: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
//                cancelButton
                Spacer()
                doneButton
//                if isExportCompletedSuccessfully {
//                    doneButton
//                } else {
//                    controlsButtons
//                }
            }
            .padding(.top)
            Spacer()
//            if isShowingSlider && !isExportCompletedSuccessfully {
//
//            }
            
            VideoSliderView()
                .background(Color.gray.opacity(0.001)) // somehow fixes slider issue
//                .padding(.horizontal)
        }
        .buttonStyle(.borderless)
        .foregroundColor(.white)
    }
    
    var cancelButton: some View {
        EditorControlButton(
            isExportCompletedSuccessfully ? "pencil.circle" : "xmark.circle",
            action: cancelButtonActions
        )
        .padding(.leading)
    }
    
    var controlsButtons: some View {
        VStack(alignment: .center, spacing: 15) {
            doneButton
            EditorControlButton(audioControlImage) {
                withAnimation {
                    playerVM.isMuted ? playerVM.unmute() : playerVM.mute()
                }
            }
            EditorControlButton("timeline.selection") {
                withAnimation {
                    isShowingSlider.toggle()
                }
            }
        }
        .frame(maxWidth: 60)
    }
    
    var doneButton: some View {
        EditorControlButton("checkmark.circle.fill", action: doneButtonActions)
            .padding(.trailing)
    }
    
    var audioControlImage: String {
        playerVM.isMuted ? "speaker" : "speaker.slash"
    }
    
    var exportingOverlay: some View {
        NavigationView {
            VStack {
#if os(macOS)
                Text("Exporting Video...")
                    .font(.title)
                    .padding()
#endif
                ProgressView(value: videoUtil.progress)
                    .progressViewStyle(.linear)
                    .padding()
                Button(action: cancelExport) {
                    Text("Cancel")
                }
                .padding()
            }
            .navigationTitle("Exporting Video...")
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private func cancelButtonActions() {
        withAnimation {
            if isExportCompletedSuccessfully {
                initialiseOrResetEditor()
            } else {
                // delete from storage
                playerVM.pause()
                dismiss()
                videoURL = nil
                MediaPicker.cleanDirectory()
                VideoUtil.cleanDirectory()
            }
        }
    }
    
    private func doneButtonActions() {
        if playerVM.endPlayingAt - playerVM.startPlayingAt > 3 {
            // 提示时间不能超过多少
            
        } else {
            playerVM.pause()
            withAnimation {
                isExporting = true
            }
            videoUtil.trim(
                from: playerVM.startPlayingAt,
                to: playerVM.endPlayingAt,
                with: .presetHighestQuality,
                removeAudio: playerVM.isMuted,
                onCompletion: exportCompleted(_:)
            )
        }
    }
    
    private func exportCompleted(_ result: VideoUtil.Result) {
        switch result {
            case let .success(successURL):
                exportedVideoURL = successURL
//                playerVM.setCurrentItem(exportedVideoURL!)
//                withAnimation {
//                    isExporting = false
//                    isExportCompletedSuccessfully = true
//                }
//                playerVM.startPlayingAt = .zero
//                playerVM.play()
//                print("Trim was a success")
                
            // URL to Gif
            // Download the video and write it to temp storage
            print("Downloading video…")
            let data = try! Data(contentsOf: exportedVideoURL!)
            let fileName = String(format: "%@_%@", ProcessInfo.processInfo.globallyUniqueString, "html5gif.mp4")
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            try! data.write(to: fileURL, options: [.atomic])
                
            let frameRate: Int = 20
            let duration: TimeInterval = 9.68
            let totalFrames = Int(duration * TimeInterval(frameRate))
            let delayBetweenFrames: TimeInterval = 1.0 / TimeInterval(frameRate)
            
            var timeValues: [NSValue] = []
            
            for frameNumber in 0 ..< totalFrames {
                let seconds = TimeInterval(delayBetweenFrames) * TimeInterval(frameNumber)
                let time = CMTime(seconds: seconds, preferredTimescale: Int32(NSEC_PER_SEC))
                timeValues.append(NSValue(time: time))
            }
            
            let asset = AVURLAsset(url: exportedVideoURL!)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.requestedTimeToleranceBefore = CMTime(seconds: 0.05, preferredTimescale: 600)
            generator.requestedTimeToleranceAfter = CMTime(seconds: 0.05, preferredTimescale: 600)
            
            let sizeModifier: CGFloat = 0.1
            generator.maximumSize = CGSize(width: 450.0 * sizeModifier, height: 563.0 * sizeModifier)
            
            // Set up resulting image
            let fileProperties: [String: Any] = [
                kCGImagePropertyGIFDictionary as String: [
                    kCGImagePropertyGIFLoopCount as String: 0
                ]
            ]
            
            let frameProperties: [String: Any] = [
                kCGImagePropertyGIFDictionary as String: [
                    kCGImagePropertyGIFDelayTime: delayBetweenFrames
                ]
            ]

            let resultingFilename = String(format: "%@_%@", ProcessInfo.processInfo.globallyUniqueString, "html5gif.gif")
            let resultingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(resultingFilename)
            let destination = CGImageDestinationCreateWithURL(resultingFileURL as CFURL, UTType.gif.identifier as CFString, totalFrames, nil)!
            CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
            
            print("Converting to GIF…")
            var framesProcessed = 0
            let startTime = CFAbsoluteTimeGetCurrent()
            
            generator.generateCGImagesAsynchronously(forTimes: timeValues) { (requestedTime, resultingImage, actualTime, result, error) in
                guard let resultingImage = resultingImage else { return }
                
                framesProcessed += 1
                
                CGImageDestinationAddImage(destination, resultingImage, frameProperties as CFDictionary)
                
                if framesProcessed == totalFrames {
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                    print("Done converting to GIF! Frames processed: \(framesProcessed) • Total time: \(timeElapsed) s.")
                    
                    // Save to Photos just to check…
                    let result = CGImageDestinationFinalize(destination)
                    print("Did it succeed?", result)
                    
                    if result {
                        print("Saving to Photos…")

                        PHPhotoLibrary.shared().performChanges({
                            PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: resultingFileURL)
                        }) { (saved, err) in
                            print("Saved?", saved)
                        }
                    }
                }
            }
//            do {
//                let data = try Data(contentsOf: exportedVideoURL!)
//
//                let fileName = String(format: "%@_%@", ProcessInfo.processInfo.globallyUniqueString, "html5gif.mp4")
//                let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//
//                try data.write(to: fileURL, options: [.atomic])
//
//                print("Downloaded, starting GIF conversion…")
//
//                let outfileName = String(format: "%@_%@", ProcessInfo.processInfo.globallyUniqueString, "outfile.gif")
//                let outfileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(outfileName)
//
//                let startTime = CFAbsoluteTimeGetCurrent()
//
//                let _ = MobileFFmpeg.execute("-i \(fileURL.path) -vf fps=50,scale=450:-1 \(outfileURL.path)")
//
//                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
//                print("Time elapsed: \(timeElapsed) s.")
//
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: outfileURL)
//                }) { (saved, err) in
//                    print("Saved?", saved)
//                }
//            } catch {
//                print("Error was:", error)
//            }
            
            // 隐藏浮层
//            dismiss()
            case let .error(error):
                withAnimation {
                    isExporting = false
                }
//                onCompletion(.failure(error))
        }
    }
    
    private func cancelExport() {
        videoUtil.exporter?.cancelExport()
        playerVM.play()
        withAnimation {
            isExporting = false
        }
    }
    
    private func initialiseOrResetEditor() {
        isExportCompletedSuccessfully = false
        isShowingSlider = false
        playerVM.isShowingControls = false
        playerVM.currentTime = .zero
        playerVM.startPlayingAt = .zero
        playerVM.endPlayingAt = .zero
        guard let videoURL = videoURL else {
            return
        }
        if videoUtil.videoURL != videoURL {
            videoUtil.videoURL = videoURL
        }
        playerVM.setCurrentItem(videoURL)
        playerVM.play()
    }
}
