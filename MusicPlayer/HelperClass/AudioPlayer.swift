//
//  AudioPlayer.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import Foundation
import AVKit
import AVFoundation

class Audio{
    static let player = Audio()
    var player: AVAudioPlayer?
    private var currentPlaybackTime: TimeInterval = 0
    private var reapeat = 0
    private var playBackTime: [Int:TimeInterval] = [:]
    var currentIndex = 0
    var isPlaying = true
    private var timer: Timer?
    var onlinePlayer: AVPlayer?
    
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc private func applicationWillTerminate(_ notification: NSNotification){
        UserDefaults.standard.setValue(["DurationPlayed": player?.currentTime ?? 0,"Index": currentIndex], forKey: "LastPlayedSong")
    }
    
    func playMusic(index: Int){
        onlinePlayer?.pause()
        player?.pause()
        playBackTime[currentIndex] = player?.currentTime
        currentIndex = index
        isPlaying = true
        NotificationCenter.default.post(name: NSNotification.Name.indexChanged, object: nil, userInfo: ["index":currentIndex])
        NotificationCenter.default.post(name: NSNotification.Name.isplaying, object: nil, userInfo: ["isplaying":isPlaying])
        if Values.allMusics[index]["Name"] != nil{
            playFromUrl(index: index)
        } else {
            play(index: index)
        }
    }
    
    private func addPlayerView(){
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        ViewAdder.shared.addPlayerView(view: window, index: currentIndex)
    }
    
    func play(index: Int){  // Playing Audio
        let song = Values.allMusics[index]
        let url = Bundle.main.url(forResource: song["Url"], withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            if let oldTime = playBackTime[currentIndex]{
                player.currentTime = oldTime
            }
            player.prepareToPlay()
            player.play()
            player.delegate = self
            addPlayerView()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playFromUrl(index: Int){
        let song = Values.allMusics[index]
        let playerItem = AVPlayerItem(url: URL(string: song["Url"]!)!)
        onlinePlayer = AVPlayer(playerItem: playerItem)
        
        if onlinePlayer?.rate == 0{
            onlinePlayer?.play()
        }
        addPlayerView()
    }
    
    func getCurrentTime() -> TimeInterval{
        return player?.currentTime ?? TimeInterval()
    }
        
    func getTotalTime() -> TimeInterval{
        return player?.duration ?? TimeInterval()
    }
    
    func setNewInterval(progress: Double){
        player?.currentTime = progress * (player?.duration ?? TimeInterval())
    }
    
    func setNewInterval(interval: TimeInterval){
        player?.currentTime = interval
    }
    
    func setNewRepetitionMode(){
        if reapeat == 0{
            reapeat = 1
        } else if reapeat == 1{
            reapeat = -1
        } else {
            reapeat = 0
        }
        player?.numberOfLoops = reapeat
        NotificationCenter.default.post(name: NSNotification.Name.repetitionMode, object: nil, userInfo: ["repetitionMode":reapeat])
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
        currentPlaybackTime = player?.currentTime ?? TimeInterval()
    }
    
    func resumeAudio() {
        if let player = player, !player.isPlaying {
            player.currentTime = currentPlaybackTime
            player.play()
        }
    }
    
    func playNext(){
        if Values.allMusics.count > currentIndex + 1{
//            currentIndex = currentIndex + 1
            playMusic(index: currentIndex + 1)
        }
    }
    
    func playPrevius(){
        if currentIndex > 0{
//            currentIndex = currentIndex - 1
            playMusic(index: currentIndex - 1)
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
        playBackTime[currentIndex] = 0
        playNext()
    }
    
}
