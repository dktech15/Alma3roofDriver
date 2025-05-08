//
//  HubListCell.swift
//  EberDriver
//
//  Created by elluminati on 17/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import Foundation
import UIKit

class HubListCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var onClickButton: ((_ cell:HubListCell) -> ())? = nil
    
    static var NIB: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.textColor = .themeTextColor
        lblName.font = FontHelper.font(type: .Bold)
        
        lblAddress.textColor = .themeTextColor
        lblAddress.font = FontHelper.font(type: .Regular)
    }
    
    func setData(data: Hubs) {
        lblName.text = data.name ?? "-"
        lblAddress.text = data.address ?? ""
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        if let colser = onClickButton {
            colser(self)
        }
    }
}

