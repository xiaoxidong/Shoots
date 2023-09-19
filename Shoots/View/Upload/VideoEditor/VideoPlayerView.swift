//
//  VideoPlayerView.swift
//  Shoots
//
//  Created by XiaoDong Yuan on 2023/9/19.
//

import SwiftUI
import AVFoundation
import AVKit
import SDWebImageSwiftUI

struct VideoPlayerView: View {
    @State var player: AVPlayer? = nil
    
    @State var show = false
    @State var data: Data? = nil
    var body: some View {
        if !show {
            VideoPlayer(player: player)
                .onAppear {
                    self.player = AVPlayer(url: Bundle.main.url(forResource: "swish", withExtension: "mp4")!)
                    player?.play()
                }
                .onTapGesture {
                    generateAnimatedGif()
                }
        } else {
//            Image(uiImage: UIImage(data: data!)!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
            
            WebImage(url: animatedGifFileURL)
                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                .onSuccess { image, _, _ in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                .placeholder(Image(systemName: "photo")) // Placeholder Image
                // Supports ViewBuilder as well
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
        }
    }
    
    @State var startTime: Double = 2.0 //seconds
    @State var endTime: Double =  6.0 //seconds
    @State var frameRate = 20 //how many frames per second
    
    @State var animatedGifFileURL: URL? = nil
    
    
    func generateAnimatedGif() {
        guard let movie = self.player?.currentItem?.asset else {
            print("error, no movie in player")
            return
        }
        
        let totalFrames = Int((endTime - startTime) * Double(frameRate))
        
        
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
            let timeStamp = CMTime(seconds: startTime + Double(frameTime), preferredTimescale: 600)
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
                        self.animatedGifFileURL = destinationURL
                        
                        
                        do {
                            self.data = try Data(contentsOf:(animatedGifFileURL)!)
                            show.toggle()
                        } catch (let error){
                            print(error.localizedDescription)
                        }
                        //this is just a standard QuickLook controller
                        //I like using this instead of an embedded WebKit view to display
                        //the animated gif
//                        let qlPreviewController = QLPreviewController()
////                        qlPreviewController.dataSource = self
//                        qlPreviewController.currentPreviewItemIndex = 0
//                        self.present(qlPreviewController, animated: true)
                    }
                    
                }
            }
            
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
