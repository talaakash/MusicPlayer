//
//  AudioPlayer.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import Foundation
import AVKit

class Audio{
    static let player = Audio()
    var player: AVAudioPlayer?
    private var currentPlaybackTime: TimeInterval = 0
    private var reapeat = 0
    var currentIndex = 0
    var isPlaying = true
    private var timer: Timer?
    
    private init(){
        
    }
    
    func play(fileName: String, fileType: String){  // Playing Audio
        let url = Bundle.main.url(forResource: fileName, withExtension: fileType)!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.numberOfLoops = reapeat
            player.play()
            player.delegate = self
//            startPlaybackTimer()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
//    func startPlaybackTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: true) { [weak self] _ in
//            if let currentTime = self?.player?.currentTime, let duration = self?.player?.duration{
//                if duration - currentTime <= 0.005 {
//                    self?.playNext()
//                }
//            }
//        }
//    }

    
    func getCurrentTime() -> TimeInterval{
        return player?.currentTime ?? TimeInterval()
    }
    
    func getTotalTime() -> TimeInterval{
        return player?.duration ?? TimeInterval()
    }
    
    func setNewInterval(progress: Double){
        player?.currentTime = progress * (player?.duration ?? TimeInterval())
    }
    
    func getTotalInterval() -> String{
        let totalInterval = player?.duration ?? 0
        let minutes = Int(totalInterval) / 60
        let seconds = Int(totalInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func tooglePlayPause(){
        if isPlaying{
            isPlaying = false
            Audio.player.pause()
        } else {
            isPlaying = true
            Audio.player.resumeAudio()
        }
        NotificationCenter.default.post(name: NSNotification.Name.isplaying, object: nil, userInfo: ["isplaying":isPlaying])
    }
    
    func pause(){
        player?.pause()
        currentPlaybackTime = player!.currentTime
    }
    
    func resumeAudio() {
        if let player = player, !player.isPlaying {
            player.currentTime = currentPlaybackTime
            player.play()
        }
    }
    
    func playNext(){
        if Values.musics.count > currentIndex + 1{
            currentIndex = currentIndex + 1
            play(fileName: Values.musics[currentIndex], fileType: "mp3")
            NotificationCenter.default.post(name: NSNotification.Name.indexChanged, object: nil, userInfo: ["index":currentIndex])
        }
    }
    
    func playPrevius(){
        if currentIndex > 0{
            currentIndex = currentIndex - 1
            play(fileName: Values.musics[currentIndex], fileType: "mp3")
            NotificationCenter.default.post(name: NSNotification.Name.indexChanged, object: nil, userInfo: ["index":currentIndex])
        }
    }
}

extension Audio: AVAudioPlayerDelegate{
    func isEqual(_ object: Any?) -> Bool {
        return true
    }
    
    var hash: Int {
        return 0
    }
    
    var superclass: AnyClass? {
        return nil
    }
    
    func `self`() -> Self {
        return self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func isProxy() -> Bool {
        return true
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        return true
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        return true
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        return true
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        return true
    }
    
    var description: String {
        return ""
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNext()
    }
    
}
