//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var musicTbl: UITableView!
    
    var songArray: [MusicData] = []
    var lastPreview: Int?
    var lastIndexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        NotificationCenter.default.addObserver(self, selector: #selector(openPreview(_:)), name: NSNotification.Name.openSongPreview, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(_:)), name: NSNotification.Name.indexChanged, object: nil)
        
        musicTbl.register(UINib(nibName: "Music", bundle: nil), forCellReuseIdentifier: "Musics")
        
        if let last = UserDefaults.standard.value(forKey: "LastPlayedSong") as? [String:Any]{
            let index = last["Index"] as? Int ?? 0
            Audio.player.playMusic(index: index)
            Audio.player.setNewInterval(interval: last["DurationPlayed"] as? TimeInterval ?? 0)
            Audio.player.tooglePlayPause()
            lastIndexPath = IndexPath(row: index, section: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.changeSelection()
            })
//            let cell = musicTbl.cellForRow(at: lastIndexPath!) as? Music
//            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {  _ in
//                let progress = Float(Audio.player.getCurrentTime() / Audio.player.getTotalTime())
//                cell?.songProgress.setProgress(progress, animated: true)
//            }
        }
    }
    
    @objc func changeIndex(_ notification: NSNotification){
        lastIndexPath = IndexPath(row: notification.userInfo?["index"] as! Int, section: 0)
        changeSelection()
        musicTbl.scrollToRow(at: lastIndexPath!, at: .middle, animated: true)
    }
    
    @objc func openPreview(_ notification: NSNotification){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongPreviewVC") as! SongPreviewVC
        self.navigationController?.customPresent(vc, transitionType: .fade, animated: true)
    }
    
//    @objc func songEnded(_ notification: NSNotification){
//        lastIndexPath = IndexPath(row: (lastIndexPath?.row ?? 0) + 1, section: 0)
//        changeSelection()
//        
//    }
    
    @objc func previewSong(sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SongDetailsVC") as! SongDetailsVC
        vc.songIndex = sender.tag
        self.navigationController?.customPush(vc, transitionType: .moveIn, animated: true)
    }
    
    private func changeSelection(){
        if Values.allMusics[lastIndexPath?.row ?? 0]["Name"] != nil{
            return
        }
        musicTbl.beginUpdates()
        musicTbl.endUpdates()
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Values.allMusics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Musics", for: indexPath) as! Music
        let song = Values.allMusics[indexPath.row]
        if let name = song["Name"]{
            cell.name.text = name
            return cell
        }
        cell.name.text = song["Url"]
        cell.previewBtn.tag = indexPath.row
        cell.previewBtn.addTarget(nil, action: #selector(previewSong(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Audio.player.playMusic(index: indexPath.row)
        lastIndexPath = indexPath
        changeSelection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if lastIndexPath == indexPath{
            let cell = tableView.cellForRow(at: indexPath) as? Music
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {  _ in
                let progress = Float(Audio.player.getCurrentTime() / Audio.player.getTotalTime())
                cell?.songProgress.setProgress(progress, animated: true)
            }
            return 80
        }
        return 50
    }
}
