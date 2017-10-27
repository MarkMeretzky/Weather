//
//  TableViewCell.swift
//  Weather
//
//  Created by Mark Meretzky on 10/27/17.
//  Copyright © 2017 NYU School of Professional Studies. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //called by dequeueReusableCell(withIdentifier:for:)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier);
    }
    
    //never called
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
