//
//  VideoDownloader.swift
//  Items
//
//  Created by Ian on 23/06/2022.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
public class VideoDownloader: NSObject, ObservableObject {
    private var downloadTask: URLSessionDownloadTask?
    @Published public var finalURL: URL?
    @Published public var progress: Progress = .init()
    @Published public var downloadedDataSize: String = ""
    @Published public var totalDataSize: String = ""
    private let formatter = ByteCountFormatter()

    public override init() {
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
    }

    public func downloadVideo(url: URL) async {
        let urlSession = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        downloadTask = urlSession.downloadTask(with: request)
        if #available(iOS 15.0, macOS 12.0, *) {
            downloadTask?.delegate = self
        } else {
            // Fallback on earlier versions
        }
        downloadTask?.resume()
        progress.fileOperationKind = .downloading
        // https://user-images.githubusercontent.com/30172987/177963000-dda66c43-602a-4b13-97e3-b10256a00b90.mov
    }

    public func cancelDownload() {
        progress.cancel()
        downloadTask?.cancel()
    }

    public func reset() {
        finalURL = nil
        downloadedDataSize = ""
        totalDataSize = ""
        progress = Progress()
    }

    private func calculateProgress(downloaded: Int64, total: Int64) {
        progress.totalUnitCount = total
        progress.completedUnitCount = downloaded
        DispatchQueue.main.async {
            self.downloadedDataSize = self.formatter.string(fromByteCount: downloaded)
            self.totalDataSize = self.formatter.string(fromByteCount: total)
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension VideoDownloader: URLSessionDownloadDelegate {
    // Delegate
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("VideoEditor")
        if !FileManager.default.fileExists(atPath: directory.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        let localURL: URL = directory.appendingPathComponent("downloadedVideo\(UUID()).mp4")
        if FileManager.default.fileExists(atPath: localURL.path) {
            try? FileManager.default.removeItem(at: localURL)
        }
        do {
            try FileManager.default.copyItem(at: location, to: localURL)

        } catch {
            print(error.localizedDescription)
        }
        print(localURL, "VideoDownloader Local URLL")
        DispatchQueue.main.async {
            self.finalURL = localURL
        }
    }

    // Delegate
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        calculateProgress(downloaded: totalBytesWritten, total: totalBytesExpectedToWrite)
    }
}
