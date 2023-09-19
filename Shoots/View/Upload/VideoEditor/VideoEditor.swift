//
//  VideoTrimmer.swift
//  Items
//
//  Created by Ian on 23/06/2022.
//

import SwiftUI
import AVFoundation
import Photos
import SDWebImageSwiftUI

@available(iOS 14.0, macOS 11, *)
public struct VideoEditor: View {
    @Binding var videoURL: URL?
    @Binding var gifURL: URL?
    
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
    @State var show = false
    @State var data: Data? = nil
    @State var showToast = false
    @State var toastText = "时间不能超过 3 秒"
    public var body: some View {
        ZStack {
            if videoURL != nil {
                videoPlayer
            } else {
                LoadingView()
            }
            videoOverlay
        }
        .background(Color.black.ignoresSafeArea(.all))
        .transition(.move(edge: .bottom))
        .overlay {
            if isExporting {
                LoadingView()
            }
        }
        .onAppear(perform: initialiseOrResetEditor)
        .onDisappear {
            cancelButtonActions()
        }
        .environmentObject(videoUtil)
        .environmentObject(playerVM)
        .onChange(of: videoURL) { newValue in
            initialiseOrResetEditor()
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .alert, type: .error(), title: toastText)
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
//        EditorControlButton("checkmark.circle.fill", action: doneButtonActions)
//            .padding(.trailing)
        
        Button {
            doneButtonActions()
        } label: {
            Text("完成")
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(.shootWhite)
                .background(Color.shootBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }.padding(.trailing)
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
            playerVM.pause()
//            MediaPicker.cleanDirectory()
//            VideoUtil.cleanDirectory()
        }
    }
    
    private func doneButtonActions() {
        if playerVM.endPlayingAt - playerVM.startPlayingAt > 3 {
            // 提示时间不能超过多少
            showToast.toggle()
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
            playerVM.setCurrentItem(exportedVideoURL!)
            withAnimation {
                isExporting = false
                isExportCompletedSuccessfully = true
            }
            //                playerVM.startPlayingAt = .zero
            //                playerVM.play()
            //                print("Trim was a success")
            
            generateAnimatedGif()
            // 隐藏浮层
            //            dismiss()
        case let .error(error):
            withAnimation {
                isExporting = false
            }
            print(error)
            //                onCompletion(.failure(error))
        }
    }
    
    var frameRate = 20
    func generateAnimatedGif() {
        self.playerVM.player.pause()
        guard let movie = self.playerVM.player.currentItem?.asset else {
            print("error, no movie in player")
            return
        }
        
        let totalFrames = Int((playerVM.endPlayingAt - playerVM.startPlayingAt) * Double(frameRate))
        print(playerVM.endPlayingAt - playerVM.startPlayingAt)
        //create empty file to hold gif
        let destinationFilename = String(NSUUID().uuidString + ".gif")
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(destinationFilename)
        
        //metadata for gif file to describe it as an animated gif
        let fileDictionary = [kCGImagePropertyGIFDictionary : [
            kCGImagePropertyGIFLoopCount : 0]]
        
        //metadata to apply to each frame of the file (we'll use this in the completion block)
        let frameDictionary = [kCGImagePropertyGIFDictionary : [
            kCGImagePropertyGIFDelayTime: 1.0 / 20.0]]
        
        guard let animatedGifFile = CGImageDestinationCreateWithURL(destinationURL as CFURL, UTType.gif.identifier as CFString, totalFrames, nil) else {
            print("error creating gif file")
            return
        }
        CGImageDestinationSetProperties(animatedGifFile, fileDictionary as CFDictionary)
        
        //generate frames
        let frameGenerator = AVAssetImageGenerator(asset: movie)
        frameGenerator.requestedTimeToleranceBefore = CMTime(seconds: 0, preferredTimescale: 600)
        frameGenerator.requestedTimeToleranceAfter = CMTime(seconds: 0, preferredTimescale: 600)
        
        var timeStamps = [NSValue]()
        
        for currentFrame in 0..<totalFrames {
            let frameTime = Double(currentFrame) / Double(frameRate)
            let timeStamp = CMTime(seconds: Double(frameTime), preferredTimescale: 600)
            timeStamps.append(NSValue(time: timeStamp))
        }
        
        //The completion handler never says when it's actually done so
        //keeping track of the number of frames it's generated will let us know when to
        //end the process and clean up
        var framesGenerated = 0
        
        frameGenerator.generateCGImagesAsynchronously(forTimes: timeStamps) { requestedTime, frameImage, actualTime, result, error in
            guard let frameImage = frameImage else {
                print("no image")
                return
            }
            
            framesGenerated = framesGenerated + 1
            CGImageDestinationAddImage(animatedGifFile, frameImage, frameDictionary as CFDictionary)
            
            if framesGenerated == totalFrames {
                if CGImageDestinationFinalize(animatedGifFile) {
                    DispatchQueue.main.async {
                        print("success \(destinationURL)")
                        self.gifURL = destinationURL
                        dismiss()
                    }
                }
            }
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
