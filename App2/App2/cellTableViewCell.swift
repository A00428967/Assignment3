//
//  cellTableViewCell.swift
//  App2
//
//  Created by cda2019 on 2019-07-26.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class cellTableViewCell: UITableViewCell {


    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
