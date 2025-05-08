//
//  MassNotificationCell.swift
//  EberDriver
//
//  Created by Rohit on 08/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class MassNotificationCell: UITableViewCell {
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    
    var index : IndexPath?
    var onClickAction : ((String,IndexPath) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var NIB: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
}
