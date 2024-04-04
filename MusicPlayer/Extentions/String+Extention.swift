//
//  String+Extention.swift
//  MusicPlayer
//
//  Created by Akash on 04/04/24.
//

import Foundation

extension String{
    func convertInSpotifyUrl() -> String{
        var url = "https://open.spotify.com"
        let array = self.split(separator: ":")
        let arr = array.compactMap({ String($0)} )
        url.append("/\(arr[1])/\(arr[2])")
        return url
    }
}
