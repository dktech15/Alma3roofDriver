//
//  StopLocationTVC.swift
//  Eber
//
//  Created by Maulik Desai on 20/07/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

class StopLocationTVC: UITableViewCell {

    class var className : String { return "StopLocationTVC" }
    
    @IBOutlet weak var lblStopAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblStopAddress.textColor = UIColor.themeTextColor
        self.lblStopAddress.font = FontHelper.font(size: FontSize.regular15, type: FontType.Regular)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func setData(address: StopLocationAddress) {
//        self.lblStopAddress.text = address.address ?? ""
//    }
    
    func setLocationData(address: DestinationAddresses) {
        self.lblStopAddress.text = address.address ?? ""
    }
    
}
