//
//  TableViewCell.swift
//  MarvelApp
//
//  Created by Tony Sameh on 10/14/18.
//  Copyright © 2018 Amahy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet weak var charLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
