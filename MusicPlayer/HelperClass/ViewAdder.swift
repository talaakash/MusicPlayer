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

    private init(){
        playerView = Bundle.main.loadNibNamed("PlayerView", owner: nil, options: nil)?.first as? PlayerView
        playerView?.frame = CGRect(origin: CGPoint(x: 8, y: UIScreen.main.bounds.height - 100), size: CGSize(width: UIScreen.main.bounds.width - 16, height: 100))
    }
    
    func addPlayerView(view: UIView, index: Int){
        if view.contains(playerView ?? UIView()){
            return
        }
        removePlayerView()
        playerView?.seletedIndex = index
        Audio.player.currentIndex = index
        if let name = Values.allMusics[index]["Name"]{
            playerView?.musicName.text = name
        } else {
            playerView?.musicName.text = Values.allMusics[index]["Url"]
        }
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
}
