//
//  File 2.swift
//  
//
//  Created by Ian on 04/12/2022.
//

import SwiftUI
import AVKit
import Combine

#if os(iOS)
@available(iOS 13.0, *)
public struct CustomVideoPlayer: UIViewControllerRepresentable {
    @EnvironmentObject private var playerVM: PlayerViewModel

    public init() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }

    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = playerVM.player
        controller.allowsPictureInPicturePlayback = playerVM.allowsPictureInPicturePlayback
        if #available(iOS 14.2, *) {
            controller.canStartPictureInPictureAutomaticallyFromInline = playerVM.allowsPictureInPicturePlayback
        }
        return controller
    }

    public func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        if let player = controller.player, player != playerVM.player {
            controller.player = playerVM.player
        }
//        if videoURL != context.coordinator.url {
//            videoViewController.player = AVPlayer(url: videoURL)
//            context.coordinator.player = videoViewController.player
//            context.coordinator.url = videoURL
//        }
        controller.showsPlaybackControls = playerVM.isShowingControls
        controller.allowsPictureInPicturePlayback = playerVM.allowsPictureInPicturePlayback
//        videoViewController.player?.isMuted = isMuted.wrappedValue
//        videoViewController.videoGravity = videoGravity
//
//        context.coordinator.togglePlay(isPlaying: isPlaying.wrappedValue)
//        updateForSeek(context: context)
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

#elseif os(macOS)
@available(macOS 10.15, *)
public struct CustomVideoPlayer: NSViewRepresentable {
    @EnvironmentObject private var playerVM: PlayerViewModel

    public init() { }

    public func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.layer = AVPlayerLayer()
        view.player = playerVM.player
        view.controlsStyle = playerVM.isShowingControls ? .default : .none
        view.allowsPictureInPicturePlayback = playerVM.allowsPictureInPicturePlayback
        return view
    }

    public func updateNSView(_ nsView: AVPlayerView, context: Context) {
        // Will be called repeatedly
        nsView.controlsStyle = playerVM.isShowingControls ? .default : .none
        nsView.allowsPictureInPicturePlayback = playerVM.allowsPictureInPicturePlayback
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

#endif

@available(iOS 13.0, macOS 10.15, *)
public extension CustomVideoPlayer {
    class Coordinator: NSObject {
        private let parent: CustomVideoPlayer
        private var cancellable: AnyCancellable?

        private var playerVM: PlayerViewModel {
            parent.playerVM
        }

        public init(_ parent: CustomVideoPlayer) {
            self.parent = parent
            super.init()
        }

//        func configure(_ playerView: AVPlayerView) {

//        }
    }
}
