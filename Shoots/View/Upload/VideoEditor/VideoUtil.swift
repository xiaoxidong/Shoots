//
//  VideoKit.swift
//  Items
//
//  Created by Ian on 23/06/2022.
//

import Foundation
import AVFoundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
class VideoUtil: ObservableObject {
    @Published var progress: Double = .zero
    @Published var videoImageFrames: [UnifiedImage] = []
    private var asset: AVAsset?
    private var timer: Timer?
    private(set) var exporter: AVAssetExportSession?

    var videoURL: URL? {
        didSet {
            asset = AVURLAsset(url: videoURL!, options: nil)
            generateImageFrames()
        }
    }

    var assetDuration: Double {
        asset?.duration.seconds ?? 0
    }

    func trim(
        from preferredStartTime: Double,
        to preferredEndTime: Double,
        with preset: Quality = .presetHighestQuality,
        removeAudio: Bool = false,
        onCompletion: @escaping (_ result: Result) -> Void)
    {
//        check if the asset is an online video or a local one. If online, download it first else the exporter will fail
        guard let asset = asset else {
            onCompletion(.error(.assetNotSet))
            return
        }

        let outputVideoURL = outputURL()
        
        if removeAudio {
            let composition = AVMutableComposition()
            let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            if let sourceVideoTrack: AVAssetTrack = asset.tracks(withMediaType: .video).first {
                let x = CMTimeRangeMake(start: .zero, duration: asset.duration)
                try? compositionVideoTrack?.insertTimeRange(x, of: sourceVideoTrack, at: .zero)
                compositionVideoTrack?.preferredTransform = sourceVideoTrack.preferredTransform
            }
            exporter = AVAssetExportSession(asset: composition, presetName: preset.value)
        } else {
            exporter = AVAssetExportSession(asset: asset, presetName: preset.value)
        }

        guard let exporter = exporter else {
            onCompletion(.error(.exporterInitFailed))
            return
        }

        var startTime = CMTime(seconds: preferredStartTime, preferredTimescale: 1000)
        var endTime = CMTime(seconds: preferredEndTime, preferredTimescale: 1000)
        if preferredStartTime < 0 {
            startTime = .zero
        }
        if preferredEndTime > assetDuration {
            endTime = asset.duration
        }
        let timeRange = CMTimeRange(start: startTime, end: endTime)
        exporter.outputURL = outputVideoURL
        exporter.outputFileType = .mp4
        exporter.timeRange = timeRange
        
        exporter.exportAsynchronously {
            if exporter.status == .completed {
                DispatchQueue.main.async {
                    onCompletion(.success(outputVideoURL))
                }
            }
        }
        observeExporter(callback: onCompletion)
    }

    func observeExporter(callback: @escaping (_ result: Result) -> Void) {
        guard let exporter = exporter else {
            callback(.error(.exporterInitFailed))
            return
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            withAnimation {
                self.progress = Double(exporter.progress)
            }
            if exporter.status == .completed || exporter.status == .failed || exporter.status == .cancelled {
                self.timer?.invalidate()
                if exporter.status == .cancelled {
                    callback(.error(.exporterCancelled))
                }
                if exporter.status == .failed {
                    callback(.error(.exporterFailed))
                }
            }
        }
    }

    func outputURL() -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("VideoEditor")
        if !FileManager.default.fileExists(atPath: directory.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        let pathC = "trimmedVideo\(videoURL?.lastPathComponent ?? "nil").mp4"
        let url = directory.appendingPathComponent(pathC)
        // If the file exists at the URL, the exporter will fail.
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        return url
    }

    func generateImageFrames() {
        videoImageFrames = []
        Task(priority: .background) {
            guard let asset = asset else {
                return
            }
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            // reduces RAM usage for 4K videos
            imgGenerator.maximumSize = CGSize(width: 512, height: 512)

            let assetDuration = asset.duration.seconds
            var timeValues: [NSValue] = []
            for index in 1 ... 11 {
                let timeInSeconds = assetDuration / 10 * Double(index)
                let time: CMTime = .init(seconds: timeInSeconds, preferredTimescale: 1000)
                timeValues.append(time as NSValue)
            }
            imgGenerator.generateCGImagesAsynchronously(forTimes: timeValues, completionHandler: {_, cgImage ,_,_,_ in
                if let img = cgImage {
                    let image = UnifiedImage(cgImage: img)
                    DispatchQueue.main.async {
                        self.videoImageFrames.append(image)
                    }
                }
            })
        }
    }

    static func cleanDirectory() {
        Task {
            let directory = FileManager.default.temporaryDirectory.appendingPathComponent("VideoEditor")
            if !FileManager.default.fileExists(atPath: directory.absoluteString) {
                do {
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                for pathURL in directoryContents {
                    try FileManager.default.removeItem(at: pathURL)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension VideoUtil {
    enum Result {
        case success(_ videoURL: URL)
        case error(_ error: VideoUtilError)
    }

    enum VideoUtilError: Error {
        case assetNotSet
        case exporterInitFailed
        case exporterCancelled
        case exporterFailed
    }

    enum Quality {
        case preset640x480
        case preset960x540
        case preset1280x720
        case preset1920x1080
        case preset3840x2160
        case presetHEVC1920x1080
        case presetLowQuality
        case presetMediumQuality
        case presetHighestQuality
        case presetPassthrough

        var value: String {
            switch self {
            case .preset640x480:
                return AVAssetExportPreset640x480
            case .preset960x540:
                return AVAssetExportPreset960x540
            case .preset1280x720:
                return AVAssetExportPreset1280x720
            case .preset1920x1080:
                return AVAssetExportPreset1920x1080
            case .preset3840x2160:
                return AVAssetExportPreset3840x2160
            case .presetHEVC1920x1080:
                return AVAssetExportPresetHEVC1920x1080
            case .presetLowQuality:
                return AVAssetExportPresetLowQuality
            case .presetMediumQuality:
                return AVAssetExportPresetMediumQuality
            case .presetHighestQuality:
                return AVAssetExportPresetHighestQuality
            case .presetPassthrough:
                return AVAssetExportPresetPassthrough
            }
        }
    }
}
