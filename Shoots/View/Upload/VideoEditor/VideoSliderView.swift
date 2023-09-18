//
//  VideoSliderView.swift
//  Items
//
//  Created by Ian on 23/06/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct VideoSliderView: View {
    @EnvironmentObject private var playerVM: PlayerViewModel
    @EnvironmentObject private var videoUtil: VideoUtil

    @State private var maxWidth: CGFloat = 0
    @State private var isShowingSeekerTime = false
    @State private var timer: Timer?
    let seekerHeight: CGFloat = 50
    let thumbSize: CGSize = CGSize(width: 10, height: 50)

    public init() { }

    public var body: some View {
        Group {
            if videoUtil.videoImageFrames.isEmpty {
                SpinnerView()
            } else {
                sliderView
            }
        }
//        .transition(.move(edge: .bottom))
        .padding()
    }

    var sliderView: some View {
        ZStack {
            imageFramesView
            rangeSlider
        }
        .frame(height: seekerHeight)
        .frame(maxWidth: 560)
        .padding(.horizontal)
        .padding(.bottom)
    }

    var rangeSlider: some View {
        VStack {
            RangeSlider(
                value: $playerVM.currentTime,
                lowerBound: $playerVM.startPlayingAt,
                upperBound: $playerVM.endPlayingAt,
                in: 0.0 ... playerVM.duration,
                onEditingChanged: rangeSliderEdited(isEditing:)
            )
            .frame(width: maxWidth)
            .rangeSliderStyle(rangeSliderStyle)
        }
    }

    var rangeSliderStyle: some RangeSliderStyle {
        HorizontalRangeSliderStyle(
            track:
                HorizontalRangeTrack(
                    view: Color.white,
                    mask: RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(lineWidth: 2)
                        .frame(height: seekerHeight)
                ),
            thumb: valueSliderThumb,
            lowerThumb: sliderThumb,
            upperThumb: sliderThumb,
            thumbOverlay: overlayTime,
            thumbSize: CGSize(width: 8, height: 60),
            lowerThumbSize: thumbSize,
            upperThumbSize: thumbSize,
            thumbInteractiveSize: CGSize(width: 8, height: 60),
            lowerThumbInteractiveSize: thumbSize,
            upperThumbInteractiveSize: thumbSize
        )
    }

    var sliderThumb: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .foregroundColor(.white)
            .overlay (
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .foregroundColor(.black)
                    .frame(width: 2, height: 20)
            )
    }

    var valueSliderThumb: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .foregroundColor(.orange)
    }

    var imageFramesView: some View {
        Group {
            if videoUtil.videoURL != nil && !videoUtil.videoImageFrames.isEmpty {
                HStack(spacing: 0) {
                    ForEach(videoUtil.videoImageFrames, id: \.self) { image in
                        Image(unifiedImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: seekerHeight)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .readViewSize { size in
                    maxWidth = size.width
                }
            }
        }
    }

    // was causing Attribute Cycle ...
    var overlayTime: some View {
        Color.clear
            .overlay {
                Text(getTime(from: playerVM.currentTime))
                    .foregroundColor(.orange)
                    .grayBackgroundRound()
                    .opacity(isShowingSeekerTime ? 1 : 0)
            }
    }

    private func rangeSliderEdited(isEditing: Bool) {
        playerVM.isEditingCurrentTime = isEditing
        if isEditing {
            withAnimation {
                isShowingSeekerTime = true
            }
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                withAnimation {
                    isShowingSeekerTime = false
                }
            }
        }
    }

    private func getTime(from value: Double) -> String {
        withAnimation {
            guard isShowingSeekerTime else {
                return ""
            }
            if value < 60 {
                return "\(Int(value.rounded())) s"
            } else if value < 60 * 60 {
                let minutes = value / 60
                let minutesIntDouble = Double(Int(minutes))
                let seconds = (minutes - minutesIntDouble) * 60
                return "\(Int(minutes)) m \(Int(seconds.rounded())) s"
            } else {
                let hour = value / (60 * 60)
                let hourIntDouble = Double(Int(hour))
                let minutes = (hour - hourIntDouble) * 60
                let minutesIntDouble = Double(Int(minutes))
                let seconds = (minutes - minutesIntDouble) * 60
                return "\(Int(hour)) h \(Int(minutes)) m \(Int(seconds.rounded()))s"
            }
        }
    }
}
