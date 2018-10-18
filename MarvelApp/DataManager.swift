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
import SVProgressHUD

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
    var images:[Int: UIImage] = [:] //char ID: UIImage

    
    

    private init()
    {

    }
    
    func downloadData()
    {
        SVProgressHUD.show(withStatus: "Downloading...")
        let offset = chars.count //0 at start, 20 next scroll ..etc
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
        parameters.updateValue(String(offset), forKey: "offset")
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
            else
            {
                print("Error \(String(describing: response.result.error))")
                self.loadCharsArray() // from device disk
                self.prepareImages() // from device disk

                
            }
            SVProgressHUD.dismiss()
            if(self.chars.count > offset) // new data is downloaded
            {
                self.delegate?.didFinishDownloading(sender: self)
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
            if let savedImage = getSavedImage(imageID: charID)
            {
                images[charID] = savedImage
            }
            else
            {
                downloadImage(imagePath: character.imagePath, charID: charID)
            }
        }
        saveCharsArray()
    }
    
    func prepareImages()
    {
        for char in chars
        {
            if let savedImage = getSavedImage(imageID: char.id)
            {
                images[char.id] = savedImage
            }
        }
    }
    
    func downloadImage(imagePath: String, charID: Int)
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
            if images[charID] == nil
            {
                //I made the download blocks the application to wait the new data (like facebook)
//                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url)
                    {
                        if let newImage = UIImage(data: data)
                        {
                            self.images[charID] = newImage
                            self.saveImageToDocumentDirectory(imageID: charID)
                   //         print(url)
                            print(self.images.count)

                        }
                    }
              //  }
            }
        }
    }
    
    func saveImageToDocumentDirectory(imageID: Int)
    {
        guard let image = self.images[imageID] else
        {
            return
        }
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else
        {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else
        {
            return
        }
        do
        {
            try data.write(to: directory.appendingPathComponent(String(imageID))!)
            return
        }
        catch
        {
            print("error saving image: \(error.localizedDescription)")
            return
        }
    }
    
    func getSavedImage(imageID: Int) -> UIImage?
    {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(String(imageID)).path)
        }
        return nil
    }
    
    func saveCharsArray()
    {
        guard let charsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("charsArray") else
        {
            return
        }
        let encoder = PropertyListEncoder()
        do
        {
            let data = try encoder.encode(self.chars)
            try data.write(to: charsFilePath)
        }
        catch
        {
            print("Error encoding, \(error)")
        }
        
    }
    
    func loadCharsArray()
    {
        guard let charsFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("charsArray") else
        {
            return
        }
        guard let data = try? Data(contentsOf: charsFilePath) else
        {
            return
        }
        let decoder = PropertyListDecoder()
        do
        {
            self.chars = try decoder.decode([CharModel].self , from: data)
        }
        catch
        {
            print("Error decoding, \(error)")

        }
        
    }

}
