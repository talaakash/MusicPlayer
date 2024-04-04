//
//  MusicData.swift
//  MusicPlayer
//
//  Created by Akash on 04/04/24.
//

import Foundation

class MusicData{
    let name: String
    let url: String
    let year: Int
    
    init(name: String, url: String, year: Int) {
        self.name = name
        self.url = url
        self.year = year
    }
}
