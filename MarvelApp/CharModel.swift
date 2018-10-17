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
    var imagePath:String
    var info:String
    
    init(pName: String, pImagePath: String, pInfo: String )
    {
        name = pName
        imagePath = pImagePath
        info = pInfo
    }
}
