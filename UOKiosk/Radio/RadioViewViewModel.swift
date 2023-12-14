//
//  RadioViewViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/29/23.
//
// Some learning for the AVPlayer: https://medium.com/@quangtqag/background-audio-player-sync-control-center-516243c2cdd1

import AVFoundation
import MediaPlayer
import SwiftUI

class RadioViewModel: NSObject, ObservableObject {
    // MARK: Properties
    let kwvaUrl: URL = URL(string: "http://kwvaradio.uoregon.edu:8000/stream/1/kwva-high.mp3")!
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    @Published var playOrStopImage: Image = Image(systemName: "play.fill")
    @Published var viewDidLoad = false
    @Published var isPlaying: Bool = false
    @Published var showingInformationSheet: Bool = false
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)

    // MARK: - Observe Status of Playing Radio Audio
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            if playerItem.status == .readyToPlay {
                // The player is ready to play
            } else if playerItem.status == .failed {
                // Handle error
                showBanner = true
                bannerData = BannerModifier.BannerData(title: "Error", detail: "Failed to connect to radio stream. Check internet connection.", type: .Error)
                DispatchQueue.main.async {
                    self.stop()
                }
            }
        }
    }

    // MARK: - ViewDidLoad
    func swiftUIViewDidLoad() {
        if viewDidLoad { return }
        defer { viewDidLoad = true }
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        setupRemoteTransportControls()
    }

    // MARK: - AVPlayer Controls
    @MainActor
    func playOrStop() {
        if isPlaying {
            stop()
        } else if !isPlaying {
            play()
        }
    }

    @MainActor
    private func play() {
        playerItem = AVPlayerItem(url: kwvaUrl)
        player = AVPlayer(playerItem: playerItem)
        playerItem?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        setupNowPlaying()
        guard let player = player else { return }
        player.play()
        playOrStopImage = Image(systemName: "stop.fill")
        isPlaying = true
    }

    @MainActor
    func stop() {
        guard let player = player else { return }
        playOrStopImage = Image(systemName: "play.fill")
        isPlaying = false
        player.replaceCurrentItem(with: nil)
    }

    // MARK: - Controlling Background Audio
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            guard let _ = self.player else { return .commandFailed }
            print("Play command - is playing: \(isPlaying)")
            if !isPlaying {
                DispatchQueue.main.async { self.play() }
                return .success
            }
            return .commandFailed
        }

        // Add handler for Stop Command
        commandCenter.stopCommand.addTarget { [unowned self] event in
            guard let _ = self.player else { return .commandFailed }
            print("Stop command - is playing: \(isPlaying)")
            if isPlaying {
                DispatchQueue.main.async { self.stop() }
                return .success
            }
            return .commandFailed
        }
    }

    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "KWVA"
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        if let image = UIImage(named: "KWVA") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Playing radio when app goes into the background
    @objc func handleAudioInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let interruptionTypeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue) else {
            return
        }

        switch interruptionType {
        case .began:
            // Audio interrupted, pause playback or perform any necessary actions
            DispatchQueue.main.async {
                self.stop()
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let interruptionOptions = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if interruptionOptions.contains(.shouldResume) {
                // Audio interruption ended, resume playback if desired
                DispatchQueue.main.async {
                    self.play()
                }
            }
        @unknown default:
            return
        }
    }

    // MARK: - Deinit
    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
}
