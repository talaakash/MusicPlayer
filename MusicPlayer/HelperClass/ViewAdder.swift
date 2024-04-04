//
//  AddPreview.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import Foundation
import UIKit

class ViewAdder{
    static let shared = ViewAdder()
    private var playerView: PlayerView?
    private var songDetailView: SongDetails?

    private init(){
        playerView = Bundle.main.loadNibNamed("PlayerView", owner: nil, options: nil)?.first as? PlayerView
        playerView?.frame = CGRect(origin: CGPoint(x: 8, y: UIScreen.main.bounds.height - 100), size: CGSize(width: UIScreen.main.bounds.width - 16, height: 100))
        songDetailView = Bundle.main.loadNibNamed("SongDetails", owner: nil, options: nil)?.first as? SongDetails
    }
    
    func addPlayerView(view: UIView, index: Int){
        removePlayerView()
        playerView?.seletedIndex = index
        Audio.player.currentIndex = index
        playerView?.musicName.text = Values.musics[index]
        view.addSubview(playerView ?? UIView())
        let originalY = playerView?.frame.origin.y ?? 0
        playerView?.frame.origin.y = view.frame.height
        UIView.animate(withDuration: 0.33, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.playerView?.frame.origin.y = originalY
        })
    }
    
    func removePlayerView(){
        playerView?.removeFromSuperview()
    }
    
    func addSongPreview(mainView: UIView, cell: UIView, index: Int){
        songDetailView?.artistName.text = Values.songDetails[index]["Artist"]
        songDetailView?.realeaseDate.text = Values.songDetails[index]["Date"]
        songDetailView?.frame = CGRect(x: cell.frame.minX + 40, y: cell.frame.maxY + 120, width: cell.frame.width - cell.frame.minX - 40, height: songDetailView?.frame.height ?? 50)
        mainView.addSubview(songDetailView!)
    }
    
    func removeSongPreview(){
        songDetailView?.removeFromSuperview()
    }
}
