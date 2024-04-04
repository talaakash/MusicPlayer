//
//  ApiHelper.swift
//  MusicPlayer
//
//  Created by Akash on 04/04/24.
//

import Foundation

class ApiHelper{
    static let shared = ApiHelper()
    private init(){ }
    
    func getData(complationHandler: @escaping (Bool,[String:Any]?) -> Void){
        let headers = [
            "X-RapidAPI-Key": "6b17dc6f14mshfcac8132c98d075p1866aejsn3919a725ea57",
            "X-RapidAPI-Host": "spotify23.p.rapidapi.com"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify23.p.rapidapi.com/search/?q=punjabi&type=multi&offset=0&limit=10&numberOfTopResults=5")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                complationHandler(false,nil)
            } else {
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                complationHandler(true,jsonData)
            }
        })
        dataTask.resume()
    }
}
