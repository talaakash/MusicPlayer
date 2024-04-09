//
//  SongDetailsVC.swift
//  MusicPlayer
//
//  Created by Akash on 04/04/24.
//

import UIKit
import Kingfisher

class SongDetailsVC: UIViewController {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var artistlbl: UILabel!
    @IBOutlet weak var realeaseDatelbl: UILabel!
    
    var songIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        GestureHandler.handle.backGesture(controller: navigationController!, view: self.view)
        guard let index = songIndex else { return }
        let details = Values.songDetails[index]
        songImage.kf.setImage(with: URL(string: details["Image"]!))
        artistlbl.text = details["Artist"]
        realeaseDatelbl.text = details["Date"]
    }
}
