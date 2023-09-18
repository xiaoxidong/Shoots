//
//  File 2.swift
//  
//
//  Created by Ian on 04/12/2022.
//

import Combine
import AVFoundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
final public class PlayerViewModel: ObservableObject {
    public let player = AVPlayer()
    @Published public var allowsPictureInPicturePlayback: Bool = true
    @Published public var isEditingCurrentTime = false {
        didSet { isEditingCurrentTime ? pause() : play() }
    }
    @Published public private(set) var isPlaying = false
    @Published public private(set) var isMuted = false
    @Published public var loopPlayback = true
    @Published public var isShowingControls = true {
        didSet { isShowingControls ? addTimeObserver() : () }
    }
    @Published public var currentTime: Double = .zero
    @Published public var duration: Double = .zero
    @Published public var startPlayingAt: Double = .zero
    @Published public var endPlayingAt: Double = .zero

    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?

    deinit {
        print("deinit")
        removeTimeObserver()
    }

    public init() {

        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.seekTo(self.currentTime)
            })
            .store(in: &subscriptions)

        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                self?.updatePlayState(with: status)
            }
            .store(in: &subscriptions)

        player.publisher(for: \.isMuted)
            .sink { [weak self] status in
                self?.isMuted = status
            }
            .store(in: &subscriptions)

        addTimeObserver()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }

    public func setCurrentItem(_ url: URL) {
        currentTime = .zero
        duration = .zero
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                let time = item.asset.duration.seconds
                self?.duration = time
                self?.endPlayingAt = time
                self?.player.play()
            })
            .store(in: &subscriptions)
    }

    public func seekForward() {
        var time = currentTime + 10
        if time >= duration {
            time = duration
        }
        player.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
        player.play()
    }

    public func seekBackward() {
        var time = currentTime - 10
        if time <= 0 {
            time = 0
        }
        player.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
        player.play()
    }

    public func play() {
        player.play()
    }

    public func pause() {
        player.pause()
    }

    public func mute() {
        guard isMuted == false else {
            return
        }
        player.isMuted = true
    }

    public func unmute() {
        guard isMuted == true else {
            return
        }
        player.isMuted = false
    }
    
    public func toggleMuted() {
        player.isMuted = !player.isMuted
    }

    public func seekTo(_ seconds: Double) {
        let cmTime = CMTime(seconds: seconds, preferredTimescale: 1000)
        player.seek(to: cmTime)
    }

    private func addTimeObserver() {
        let interval = CMTime(seconds: isShowingControls ? 1 : 0.25, preferredTimescale: 60)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.updateCurrentTime(time)
        }
    }

    private func removeTimeObserver() {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    private func updateCurrentTime(_ time: CMTime) {
        guard isEditingCurrentTime == false else {
            return
        }
        withAnimation {
            self.currentTime = time.seconds
        }
        if endPlayingAt != .zero && currentTime >= endPlayingAt {
            print("endPlayingAtReached currentTime >= endPlayingAt", startPlayingAt, currentTime, endPlayingAt, duration)
            endPlayingAtReached()
        }
    }

    private func endPlayingAtReached() {
        if loopPlayback {
            seekTo(startPlayingAt)
            player.play()
        } else {
            player.pause()
        }
    }

    private func updatePlayState(with status: AVPlayer.TimeControlStatus) {
        switch status {
        case .playing:
            if self.isPlaying == false {
                self.isPlaying = true
            }
        case .paused:
            if self.isPlaying == true {
                self.isPlaying = false
            }
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }

    @objc private func playerItemDidReachEnd(notification: NSNotification) {
        endPlayingAtReached()
    }
}
