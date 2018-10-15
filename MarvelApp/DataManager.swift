//
//  DataManager.swift
//  MarvelApp
//
//  Created by Tony Sameh on 10/15/18.
//  Copyright © 2018 Amahy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CryptoSwift

// singleton class for requesting, updating and caching data
class DataManager: NSObject
{
    static let shared = DataManager()
    let publicKey = "d61a662c80563b05a2656a2d44a9f65a"
    let privateKey = "c118dafc7cc11d4a8a401e843e8e4e26b8d56765"
    let baseURL = "https://gateway.marvel.com/v1/public/characters"

    private override init()
    {

    }
    
    func downloadData(ofsset: Int)
    {
        print("downloading data...")
        let url = baseURL + ""
        var parameters: [String: String] = [:]
        let ts = String(NSDate.timeIntervalSinceReferenceDate)
        print("time stampe: \(ts)")
        
        let signature = ts + privateKey + publicKey
        let hash = signature.md5()
        
        print("signature: \(signature)")
        print("hash: \(signature.md5())")
        
        parameters.updateValue(publicKey, forKey: "apikey")
        parameters.updateValue(ts, forKey: "ts")
        parameters.updateValue(hash, forKey: "hash")
        print("called url: \(url)")
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the Marvel Characters")
                let charsJSON : JSON = JSON(response.result.value!)
                
                
                print(charsJSON)
 
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }

}
