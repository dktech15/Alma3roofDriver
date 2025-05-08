//
//  PendingTripCell.swift
//  EberDriver
//
//  Created by Rohit on 14/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class PendingTripCell: UITableViewCell {
    @IBOutlet weak var lblTripNumber : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblProviderServiceFees : UILabel!
    @IBOutlet weak var lblStartAddress : UILabel!
    @IBOutlet weak var lblEndAddress : UILabel!
    @IBOutlet weak var btnAccept : UIButton!
    @IBOutlet weak var btnReject : UIButton!
    
    var onClickAccept : ((String,IndexPath) ->())?
    var onClickReject : ((String,IndexPath) ->())?
    var index : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
//        lblTitle.text = "TXT_NOTIFICATION".localizedCapitalized
        lblTripNumber.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Regular)
        lblTripNumber.textColor = UIColor.themeTitleColor
        lblProviderServiceFees.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Regular)
        lblProviderServiceFees.textColor = UIColor.themeTitleColor
        
        lblUserName.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Regular)
        lblUserName.textColor = UIColor.themeTitleColor
        
        lblStartAddress.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Regular)
        lblStartAddress.textColor = UIColor.themeLightTextColor
        
        lblEndAddress.font = FontHelper.font(size: FontSize.regular
            , type: FontType.Regular)
        lblEndAddress.textColor = UIColor.themeLightTextColor
        
        btnAccept.backgroundColor = UIColor.themeButtonBackgroundColor
//        btnLogout.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnAccept.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnAccept.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        
        btnReject.backgroundColor = UIColor.themeButtonBackgroundColor
        btnReject.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        
        btnAccept.layer.cornerRadius = btnAccept.frame.height/2
        btnAccept.clipsToBounds = true
        btnReject.layer.cornerRadius = btnAccept.frame.height/2
        btnReject.clipsToBounds = true
        btnReject.setTitle("TXT_CANCEL".localized, for: UIControl.State.normal)
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
    
    @IBAction func actionAccept (_ sender : UIButton){
        print("Accept")
        self.onClickAccept?("",index!)
    }
    
    @IBAction func actionReject (_ sender : UIButton){
        print("Reject")
        self.onClickReject?("",index!)
    }
    
}
