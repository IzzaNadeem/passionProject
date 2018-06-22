//
//  PlayViewController.swift
//  passionProject
//
//  Created by C4Q on 5/30/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import AVFoundation


class PlayViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate  {
    
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistTitle: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackTitle.text = "Nothing Playing"
        self.artistTitle.text = ""
    }
    // MARK:  properties
    var player:SPTAudioStreamingController?
    var isChangingProgress:Bool?
    
    @IBAction func rewind(_ sender: UIButton) {
        self.player?.skipPrevious(nil)
    }
    
    
    @IBAction func playPause(_ sender: UIButton) {
        self.player?.setIsPlaying((self.player?.playbackState.isPlaying)!, callback: nil)
    }
    
    @IBAction func fastForward(_ sender: UIButton) {
        self.player?.skipNext(nil)
    }
    @IBAction func seekValueChanged(_ sender: UISlider) {
        self.isChangingProgress = false
        guard let currentTrackDuration = self.player?.metadata.currentTrack?.duration else {return}
        let dest = currentTrackDuration * Double(self.progressSlider.value)
        self.player?.seek(to: dest, callback: nil)
    }
    
    @IBAction func logoutFromPlayer(_ sender: UIButton) {
        if self.player != nil {
            self.player?.logout()
        } else {
//           dismiss(animated: true, completion: nil)
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Mark: Logic
    func updateUI() {
        var auth: SPTAuth = SPTAuth.defaultInstance()
        if self.player?.metadata == nil || self.player?.metadata.currentTrack == nil {
            self.coverView.image = nil
            return
        }
        
        self.spinner.startAnimating()
        
        self.nextButton.isEnabled = self.player?.metadata.nextTrack != nil
        self.prevButton.isEnabled = self.player?.metadata.prevTrack != nil
        self.trackTitle.text = self.player?.metadata.currentTrack?.name
        self.artistTitle.text = self.player?.metadata.currentTrack?.artistName
        guard let pathUri = self.player?.metadata.currentTrack?.uri else {return}
        
        SPTTrack.track(withURI: URL(string: pathUri), accessToken: auth.session.accessToken, market: nil) { (error, track) in
            if let track = track as? SPTTrack {
                guard let imageURL: URL = track.album.largestCover.imageURL else {return}
                
                // Pop over to a background queue to load the image over the network.
                DispatchQueue.global().async {
                    do {
                        guard let imageData = try? NSData(contentsOf: imageURL, options: []) else {return}
                        guard let image: UIImage = UIImage(data: imageData as Data) else {return}
                        
                        // …and back to the main queue to display the image.
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                            self.coverView.image = image
                            
                        }
                    }
                    
                }
                
                
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //super.handleNewSession
    }
    
    func handleNewSession() {
        let auth: SPTAuth = SPTAuth.defaultInstance()
        if self.player == nil {
        let error:NSError? = nil
            self.player = SPTAudioStreamingController.sharedInstance()
           // try! self.player?.start(withClientId: auth.clientID, audioController: nil, allowCaching: true) {
            if ((try? self.player?.start(withClientId: auth.clientID, audioController: nil, allowCaching: true)) != nil) {
                self.player?.delegate = self
                self.player?.playbackDelegate = self
                self.player?.diskCache = SPTDiskCache.init(capacity: (1024 * 1024 * 64))
                self.player?.login(withAccessToken: auth.session.accessToken)
            } else {
                self.player = nil
                let alert = UIAlertController(title: "Error init", message: error?.description, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                self.closeSession()
            }
        }
    }
    
    func closeSession() {
        SPTAuth.defaultInstance().session = nil
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
     // Mark: Track Player Delegates
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        let alertView = UIAlertController(title: "Message from Spotify", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        print("is playing = \(isPlaying)")
        if isPlaying {
            self.activateAudioSession()
        } else {
            self.deactivateAudioSession()
        }
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
        self.updateUI()
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceive event: SpPlaybackEvent) {
        print("isPlaying= \(self.player!.playbackState.isPlaying), isRepeating= \(self.player!.playbackState.isRepeating), isShuffling= \(self.player!.playbackState.isShuffling), isActiveDevice= \(self.player!.playbackState.isActiveDevice), positionMs= \(self.player!.playbackState.position)")
      
        
    }
   
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        self.closeSession()
    }
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        let code = (error as NSError).code
        print("didReceiveError: \(code), \(error.localizedDescription)")
        if (code == Int(SPErrorNeedsPremium.rawValue)) {
            let alert = UIAlertController(title: "Premium account required", message: "Premium account is required to showcase application functionality. Please login using premium account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.closeSession()
            }))
            self.present(alert, animated: true, completion: nil)
        }
       
    }
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        if self.isChangingProgress != nil {
            return
        }
        self.progressSlider.value = Float(position/(self.player?.metadata.currentTrack!.duration)!)
    }
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        print("Starting \(trackUri)")
        print("Source \(self.player?.metadata.currentTrack?.playbackSourceUri)")
        // If context is a single track and the uri of the actual track being played is different
        // than we can assume that relink has happended.
        var isRelinked: Bool = (self.player?.metadata.currentTrack?.playbackSourceUri.contains("spotify:track"))! && self.player?.metadata.currentTrack?.playbackSourceUri != trackUri
        print("Relined: \(isRelinked)")
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        print("Finishing: \(trackUri)")
    }

    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        self.updateUI()
        self.player?.playSpotifyURI("spotify:user:spotify:playlist:2yLXxKhhziG2xzy7eyD4TD", startingWith: 0, startingWithPosition: 10, callback: { (error) in
            if let error = error {
                print("failed to play:\(error)")
            }
        })
    }

    // Mark: - Audio Session
    func activateAudioSession() {
       try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
       try? AVAudioSession.sharedInstance().setActive(true)
    }
    func deactivateAudioSession() {
       try? AVAudioSession.sharedInstance().setActive(false)
    }

}
