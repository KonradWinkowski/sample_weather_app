//
//  InfoTableViewCell.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet var views: [UIView]!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        views.forEach({ $0.layer.cornerRadius = 5.0 })
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
