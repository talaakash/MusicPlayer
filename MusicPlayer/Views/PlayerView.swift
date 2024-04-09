//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import Foundation
import UIKit
import Kingfisher

class PlayerView: UIView{
    @IBOutlet weak private var playingImage: UIImageView!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    var seletedIndex: Int?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(_:)), name: NSNotification.Name.indexChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changePlay(_:)), name: NSNotification.Name.isplaying, object: nil)
        animatePlayingImage()
        if !Audio.player.isPlaying{
            self.playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopAnimatingPlayingImage()
        }
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
    
    @objc func changeIndex(_ notification: NSNotification){
        seletedIndex = notification.userInfo?["index"] as? Int ?? seletedIndex
        let songDetail = Values.allMusics[seletedIndex!]
        if let name = songDetail["Name"]{
            self.musicName.text = name
        } else {
            self.musicName.text = songDetail["Url"]
        }
    }
    
    private func animatePlayingImage(){
        if let gifURL = Bundle.main.url(forResource: "AudioPlaying", withExtension: "gif") {
            let imageResource = KF.ImageResource(downloadURL: gifURL)
            playingImage.kf.setImage(with: imageResource)
        } else {
            print("GIF file not found in the asset catalog")
        }
    }
    
    private func stopAnimatingPlayingImage(){
        if let gifURL = Bundle.main.url(forResource: "AudioPlaying", withExtension: "gif") {
            playingImage.image = try? UIImage(data: Data(contentsOf: gifURL))
        }
    }
    
    @IBAction func playPuseController(_ sender: UIButton){
        Audio.player.tooglePlayPause()
    }
    
    @IBAction func nextClicked(_ sender: UIButton){
        Audio.player.playNext()
    }
    
    @IBAction func previusClicked(_ sender: UIButton){
        Audio.player.playPrevius()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: NSNotification.Name.openSongPreview, object: nil, userInfo: nil)
    }
}


