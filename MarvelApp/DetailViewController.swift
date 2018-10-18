//
//  DetailViewController.swift
//  MarvelApp
//
//  Created by Tony Sameh on 10/17/18.
//  Copyright © 2018 Amahy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    
    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet weak var charInfo: UITextView!
    var char:CharModel?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let currentChar = char
        {
            self.navigationItem.title = "\(currentChar.id)"
            self.charImage.image = DataManager.shared.images[currentChar.imagePath]
            self.charInfo.text = currentChar.info
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
