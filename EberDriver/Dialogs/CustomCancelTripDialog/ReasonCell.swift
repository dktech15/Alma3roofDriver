//
//  ReasonCell.swift
//  EberDriver
//
//  Created by Elluminati on 06/07/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

protocol ReasonCellDelegate: AnyObject {
    func onClickButton(cell: ReasonCell, sender: UIButton)
}

class ReasonCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgReason: UIImageView!
    weak var delegate: ReasonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblName.font = FontHelper.font(type: .Regular)
        lblName.textColor = .themeTextColor
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.onClickButton(cell: self, sender: sender)
    }
    
}
