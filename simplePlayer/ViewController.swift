//
//  ViewController.swift
//  simplePlayer
//
//  Created by Victor Serov on 15/07/2022.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    var player:AVPlayer!
    
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let asset = AVAsset(url: URL(string: "https://somafm.com/groovesalad256.pls")!)
    
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["availableMediaCharacteristicsWithMediaSelectionOptions"])
        
        player = AVPlayer(playerItem: playerItem)
        
        setupRemoteTransportControls()
        
        prepareToPlay()
    }
    
    
    func prepareToPlay()
    {
        player.allowsExternalPlayback = true
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do
        {
         
            try audioSession.setCategory(.playback, mode: .default)
        
            // Make the audio session active.
        
            try audioSession.setActive(true)
        }
        catch
        {
            print("error")
        }
        
        player.play()
        
        setMetadata()
        
        
    }

    func setMetadata()
    {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = URL(string: "sss.com")
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = NSNumber(value: MPNowPlayingInfoMediaType.audio.rawValue)
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        nowPlayingInfo[MPMediaItemPropertyTitle] = "metadata.title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "metadata.artist"
        
        image = UIImage(named: "Colosseum.jpg")!
        
        let mediaArtwork = MPMediaItemArtwork(boundsSize: image.size) {
            (size: CGSize) -> UIImage in
            return self.image
        }
        
        nowPlayingInfo[MPMediaItemPropertyArtwork] = mediaArtwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = "metadata.albumArtist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "metadata.albumTitle"
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 200
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 43
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Next Command
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.next()
            return .success
        }
        
        // Add handler for Previous Command
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.previous()
            return .success
        }
    }
    
    func next()
    {
        print("next pressed")
    }
    
    func previous()
    {
        print("prev pressed")
    }

}

