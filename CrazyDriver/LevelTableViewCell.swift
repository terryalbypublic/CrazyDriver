//
//  LevelTableViewCell.swift
//  CrazyDriver
//
//  Created by Alberti Terence on 01/02/17.
//  Copyright © 2017 TA. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {

    var levelFilename = ""
    @IBOutlet weak var levelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
