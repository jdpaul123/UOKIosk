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

@MainActor
class RadioViewModel: NSObject, ObservableObject {
    // MARK: Properties
    let kwvaUrl = URL(string: "http://kwvaradio.uoregon.edu:8000/stream/1/kwva-high.mp3")!
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    @Published var playOrStopImage = Image(systemName: "play.fill")
    @Published var viewDidLoad = false
    @Published var isPlaying = false
    @Published var showingInformationSheet = false
    @Published var showBanner  = false
    @Published var bannerData = BannerModifier.BannerData(title: "", detail: "", type: .Error)

    override init() {
        super.init()
        // FIXME: AVFoundation causing error logging: AddInstanceForFactory: No factory registered for id <CFUUID 0x600000238d40> F8BB1C28-BAE8-11D6-9C31-00039315CD46
        // https://stackoverflow.com/questions/58360765/swift-5-1-error-plugin-addinstanceforfactory-no-factory-registered-for-id-c
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch {
            print("Failed to set audio session category. With error: \(error.localizedDescription)")
        }
    }

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
    func playOrStop() {
        if isPlaying {
            stop()
        } else if !isPlaying {
            play()
        }
    }

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
        let image = UIImage(resource: .KWVA)
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
            return image
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
