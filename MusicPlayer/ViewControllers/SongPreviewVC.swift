//
//  SongPreview.swift
//  MusicPlayer
//
//  Created by Akash on 04/04/24.
//

import UIKit
import Kingfisher

class SongPreviewVC: UIViewController {

    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var songIntervalView: UIProgressView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var totalDuration: UILabel!
    var timer: Timer?
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        if let gifURL = Bundle.main.url(forResource: "AudioPlaying", withExtension: "gif") {
            let imageResource = KF.ImageResource(downloadURL: gifURL)
            gifImage.kf.setImage(with: imageResource)
        } else {
            print("GIF file not found in the asset catalog")
        }
        currentIndex = Audio.player.currentIndex
        songName.text = Values.musics[currentIndex]
        
        if !Audio.player.isPlaying{
            self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
        totalDuration.text = Audio.player.getTotalInterval()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        songIntervalView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(_:)), name: NSNotification.Name.indexChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changePlay(_:)), name: NSNotification.Name.isplaying, object: nil)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let progress = Float(Audio.player.getCurrentTime() / Audio.player.getTotalTime())
            songIntervalView.setProgress(progress, animated: true)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: songIntervalView)
            let newProgress = location.x / songIntervalView.frame.width
            Audio.player.setNewInterval(progress: newProgress)
        }
    }
    
    @objc func changeIndex(_ notification: NSNotification){
        currentIndex = notification.userInfo?["index"] as? Int ?? currentIndex
        songName.text = Values.musics[currentIndex]
        totalDuration.text = Audio.player.getTotalInterval()
    }
    
    @objc func changePlay(_ notification: NSNotification){
        if !(notification.userInfo?["isplaying"] as! Bool){
            self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            self.playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton){
        Audio.player.tooglePlayPause()
    }
    
    @IBAction func playNextClicked(_ sender: UIButton){
        Audio.player.playNext()
    }
    
    @IBAction func playPreviusClicked(_ sender: UIButton){
        Audio.player.playPrevius()
    }
    
    @IBAction func reapeatClicked(_ sender: UIButton){
        
    }
}
