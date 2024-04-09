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
    @IBOutlet weak var repetitionBtn: UIButton!
    @IBOutlet weak var totalDuration: UILabel!
    var timer: Timer?
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        currentIndex = Audio.player.currentIndex
        let songDetail = Values.allMusics[currentIndex]
        if let name = songDetail["Name"]{
            songName.text = name
        } else {
            songName.text = songDetail["Url"]
        }
        animatePlayingImage()
        
        if !Audio.player.isPlaying{
            self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopAnimatingPlayingImage()
        }
        
        totalDuration.text = Audio.player.getTotalInterval()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        songIntervalView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(_:)), name: NSNotification.Name.indexChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changePlay(_:)), name: NSNotification.Name.isplaying, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeRepetition(_:)), name: NSNotification.Name.repetitionMode, object: nil)
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let progress = Float(Audio.player.getCurrentTime() / Audio.player.getTotalTime())
            songIntervalView.setProgress(progress, animated: true)
        }
    }
    
    private func animatePlayingImage(){
        if let gifURL = Bundle.main.url(forResource: "AudioPlaying", withExtension: "gif") {
            let imageResource = KF.ImageResource(downloadURL: gifURL)
            gifImage.kf.setImage(with: imageResource)
        } else {
            print("GIF file not found in the asset catalog")
        }
    }
    
    private func stopAnimatingPlayingImage(){
        if let gifURL = Bundle.main.url(forResource: "AudioPlaying", withExtension: "gif") {
            gifImage.image = try? UIImage(data: Data(contentsOf: gifURL))
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: songIntervalView)
            let newProgress = location.x / songIntervalView.frame.width
            Audio.player.setNewInterval(progress: newProgress)
        }
    }
    
    @objc func changeRepetition(_ notification: NSNotification){
        let repetitionMode = notification.userInfo?["repetitionMode"] as? Int ?? currentIndex
        if repetitionMode == 0{
            repetitionBtn.tintColor = UIColor.white
        } else if repetitionMode == 1{
            repetitionBtn.tintColor = UIColor.green
        } else {
            repetitionBtn.tintColor = UIColor.red
        }
    }
    
    @objc func changeIndex(_ notification: NSNotification){
        currentIndex = notification.userInfo?["index"] as? Int ?? currentIndex
        let songDetail = Values.allMusics[currentIndex]
        if let name = songDetail["Name"]{
            self.songName.text = name
        } else {
            self.songName.text = songDetail["Url"]
        }
        totalDuration.text = Audio.player.getTotalInterval()
    }
    
    @objc func changePlay(_ notification: NSNotification){
        if !(notification.userInfo?["isplaying"] as! Bool){
            self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopAnimatingPlayingImage()
        } else {
            self.playPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            animatePlayingImage()
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
        Audio.player.setNewRepetitionMode()
    }
}
