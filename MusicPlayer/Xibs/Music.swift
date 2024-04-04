//
//  Music.swift
//  MusicPlayer
//
//  Created by Akash on 03/04/24.
//

import UIKit

class Music: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var previewBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
