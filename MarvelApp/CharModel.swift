//
//  CharModel.swift
//  MarvelApp
//
//  Created by Tony Sameh on 10/15/18.
//  Copyright © 2018 Amahy. All rights reserved.
//

import UIKit

class CharModel: Codable
{
    var id:Int
    var name:String
    var imagePath:String
    var info:String
    
    
    
    init(pID: Int, pName: String, pImagePath: String, pInfo: String )
    {
        id = pID
        name = pName
        imagePath = pImagePath
        info = pInfo
    }
}
