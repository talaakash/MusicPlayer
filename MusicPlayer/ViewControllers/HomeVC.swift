//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import UIKit
import AVFAudio

class HomeVC: UIViewController {

    @IBOutlet weak var musicTbl: UITableView!
    
    var songArray: [MusicData] = []
    var lastPreview: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

//    func addDataInArray(data: [String:Any]){
//        if let playlist = data["albums"] as? [String:Any]{
//            if let songs = playlist["items"] as? [[String:Any]]{
//                for song in songs {
//                    if let data = song["data"] as? [String:Any]{
//                        let uri = data["uri"] as? String ?? ""
//                        let url = uri.convertInSpotifyUrl()
//                        songArray.append(MusicData(name: data["name"] as? String ?? "", url: url, year: data["year"] as? Int ?? 0))
//                    }
//                }
//            }
//        }
//        if let song = songArray.first?.url{
//            Audio.player.play()
//        }
//    }
    
    private func setup(){
        NotificationCenter.default.addObserver(self, selector: #selector(openPreview(_:)), name: NSNotification.Name.openSongPreview, object: nil)
        
        musicTbl.register(UINib(nibName: "Music", bundle: nil), forCellReuseIdentifier: "Musics")
//        ApiHelper.shared.getData(complationHandler: { status, data in
//            self.addDataInArray(data: data!)
//        })
//        Audio.player.player?.delegate = self
    }
    
    @objc func openPreview(_ notification: NSNotification){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongPreviewVC") as! SongPreviewVC
        self.navigationController?.customPresent(vc, transitionType: .fade, animated: true)
    }
    
    @objc func previewSong(sender: UIButton){
        if sender.tag == lastPreview{
            lastPreview = nil
            ViewAdder.shared.removeSongPreview()
            return
        }
        lastPreview = sender.tag
        let cell = musicTbl.cellForRow(at: IndexPath(row: lastPreview!, section: 0))!
        ViewAdder.shared.addSongPreview(mainView: self.view, cell: cell, index: lastPreview!)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Values.musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Musics", for: indexPath) as! Music
        cell.name.text = Values.musics[indexPath.row]
        cell.previewBtn.tag = indexPath.row
        cell.previewBtn.addTarget(nil, action: #selector(previewSong(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Audio.player.play(fileName: Values.musics[indexPath.row], fileType: "mp3")
        ViewAdder.shared.addPlayerView(view: self.view, index: indexPath.row)
        
    }
}

//extension HomeVC: AVAudioPlayerDelegate{
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        Audio.player.playNext()
//    }
//}

/*
 proper naming // Done
 Play from online url
 DEtail Screen with common music player   // Done
 Auto Play next  
 */
