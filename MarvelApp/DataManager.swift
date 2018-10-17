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
class DataManager
{
    //shared instance
    static let shared = DataManager()
    var delegate:DataManagerDelegate?
    // developer.marvel information
    let publicKey = "d61a662c80563b05a2656a2d44a9f65a"
    let privateKey = "c118dafc7cc11d4a8a401e843e8e4e26b8d56765"
    let baseURL = "https://gateway.marvel.com/v1/public/characters"
    let numberOfItems = 20
    
    //data array
    var chars:[CharModel] = [CharModel]()
    var images:[String: UIImage] = [:]

    
    

    private init()
    {

    }
    
    func downloadData(ofsset: Int)
    {
        chars.removeAll()
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
                
                
           //     print(charsJSON)
                print(charsJSON["data"]["results"][0]["name"])
                self.fillCharsArray(charsJSON: charsJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func fillCharsArray(charsJSON: JSON)
    {
        for i in 0..<numberOfItems
        {
            let oneCharJSON = charsJSON["data"]["results"][i]
            guard
                let charID = oneCharJSON["id"].int,
                let charName = oneCharJSON["name"].string,
                let charImagePath = oneCharJSON["thumbnail"]["path"].string,
                let charImageExt = oneCharJSON["thumbnail"]["extension"].string,
                let charInfo = oneCharJSON["description"].string
            else
            {
                continue
            }
            let character = CharModel(pID: charID, pName: charName, pImagePath: "\(charImagePath).\(charImageExt)", pInfo: charInfo)
            chars.append(character)
            saveToImageCache(imagePath: character.imagePath)
        }
        delegate?.didFinishDownloading(sender: self)
    }
    
    func saveToImageCache(imagePath: String)
    {
        // save image to images cache
        guard var url = URL(string: imagePath) else
        {
            return
        }
        
        if var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        {
            urlComps.scheme = "https"
            url = urlComps.url!
            if images[imagePath] == nil
            {
//                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url)
                    {
                        if let newImage = UIImage(data: data)
                        {
                            self.images[imagePath] = newImage
                   //         print(url)
                            print(self.images.count)
                        }
                    }
              //  }
            }
        }
    }

}
