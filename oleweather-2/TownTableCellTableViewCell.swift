//
//  TownTableCellTableViewCell.swift
//  oleweather-2
//
//  Created by arek on 08/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import UIKit

class TownTableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var tableItem: UIView!
    @IBOutlet weak var towne: UILabel!
    @IBOutlet weak var imagee: UIImageView!
    @IBOutlet weak var temperaturee: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
