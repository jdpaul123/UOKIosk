//
//  RadioViewViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/29/23.
//

import Foundation
import AVFoundation
import MediaPlayer
import SwiftUI

class RadioViewModel: NSObject, ObservableObject {
    let kwvaUrl: URL = URL(string: "http://kwvaradio.uoregon.edu:8000/stream/1/kwva-high.mp3")!
    let playerItem: AVPlayerItem
    let player: AVPlayer?
    @Published var playPauseImage: Image = Image(systemName: "play.fill")
    @Published var viewDidLoad = false
    var isPlaying: Bool {
        player?.timeControlStatus == .playing ? true : false
    }

    override init() {
        playerItem = AVPlayerItem(url: kwvaUrl)
        player = AVPlayer(playerItem: playerItem)
        super.init()

        playerItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)

    }

    // MARK: - Observe Status of Playing Radio Audio
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            if playerItem.status == .readyToPlay {
                // The player is ready to play
            } else if playerItem.status == .failed {
                // Handle error
            }
        }
    }

    // MARK: - ViewDidLoad
    func swiftUIViewDidLoad() {
        if viewDidLoad { return }
        defer { viewDidLoad = true }
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        setupRemoteTransportControls()
        setupNowPlaying()
    }

    // MARK: - AVPlayer Controls
    @MainActor
    func playPause() {
        guard let _ = player else {
            playPauseImage = Image(systemName: "square.split.diagonal.2x2.fill")
            return
        }
        if isPlaying {
            pause()
            playPauseImage = Image(systemName: "play.fill")
        } else if !isPlaying {
            play()
            playPauseImage = Image(systemName: "pause.fill")
        }
    }

    @MainActor
    private func play() {
        guard let player = player else { return }
        player.play()
        updateNowPlaying(isPause: false)
    }

    @MainActor
    private func pause() {
        guard let player = player else { return }
        player.pause()
        updateNowPlaying(isPause: true)
    }

    @MainActor
    func stop() {
        guard let player = player else { return }
        player.replaceCurrentItem(with: nil)
    }

    func updateNowPlaying(isPause: Bool) {
        guard let player = player else { return }
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Controlling Background Audio
    // Mark: instructions source https://medium.com/@quangtqag/background-audio-player-sync-control-center-516243c2cdd1
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

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            guard let _ = self.player else { return .commandFailed }
            print("Pause command - is playing: \(isPlaying)")
            if isPlaying {
                DispatchQueue.main.async { self.pause() }
                return .success
            }
            return .commandFailed
        }
    }

    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "KWVA"

        if let image = UIImage(named: "KWVA") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        guard let player = self.player else { return }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

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
            player?.pause()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let interruptionOptions = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if interruptionOptions.contains(.shouldResume) {
                // Audio interruption ended, resume playback if desired
                player?.play()
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
