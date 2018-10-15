//
//  CharModel.swift
//  MarvelApp
//
//  Created by Tony Sameh on 10/15/18.
//  Copyright © 2018 Amahy. All rights reserved.
//

import UIKit

class CharModel: NSObject
{
    var name:String
    var imageURL:String
    var info:String
    
    init(pName: String, pImageURL: String, pInfo: String )
    {
        name = pName
        imageURL = pImageURL
        info = pInfo
    }
}
