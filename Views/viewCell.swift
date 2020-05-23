//
//  viewCell.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/19/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import UIKit

class viewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var catImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
