//
//  RadioViewViewModel.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/29/23.
//

import Foundation
import AVFoundation

class RadioViewModel: NSObject, ObservableObject {
    let kwvaUrl: URL = URL(string: "http://kwvaradio.uoregon.edu:8000/stream/1/kwva-high.mp3")!
    let playerItem: AVPlayerItem
    let player: AVPlayer?
    @Published var playPauseString: String = "play".uppercased()

    override init() {
        self.playerItem = AVPlayerItem(url: kwvaUrl)
        self.player = AVPlayer(playerItem: playerItem)
        super.init()

        playerItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            if playerItem.status == .readyToPlay {
                // The player is ready to play
            } else if playerItem.status == .failed {
                // Handle error
            }
        }
    }

    @MainActor
    func playPause() {
        if player?.timeControlStatus == .playing {
            pause()
            playPauseString = "play".uppercased()
        } else if player?.timeControlStatus == .paused {
            play()
            playPauseString = "pause".uppercased()
        } else {
            playPauseString = "error".uppercased()
        }
    }

    @MainActor
    private func play() {
        player?.play()
    }

    @MainActor
    private func pause() {
        player?.pause()
    }

    @MainActor
    func stop() {
        player?.replaceCurrentItem(with: nil)
    }

    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
}
