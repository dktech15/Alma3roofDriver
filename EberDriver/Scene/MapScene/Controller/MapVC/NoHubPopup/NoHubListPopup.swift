//
//  NoHubListPopup.swift
//  EberDriver
//
//  Created by Rohit on 24/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class NoHubListPopup: UIView {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewGotoHub: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    var onClickCancelButton : (() -> Void)? = nil
    var onClickGoToHubButton : (() -> Void)? = nil
    var userId = ""
    
    static let noHubListPopup = "NoHubListPopup"
    public static func showCustomVerificationDialog
        (editTextInputType:Bool = false,
         offerbutton:Bool = false,
         message:String = "") -> NoHubListPopup {
        
        let view = UINib(nibName: noHubListPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NoHubListPopup
        view.alertView.setShadow()
        view.setLocalization()
//        view.viewSendMoney.isHidden = true
//        view.viewUserDetails.isHidden = true
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    func setLocalization(){
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)

        viewGotoHub.backgroundColor = UIColor.themeButtonBackgroundColor
        viewGotoHub.sizeToFit()
        viewGotoHub.setRound(withBorderColor: .clear, andCornerRadious: (viewGotoHub.frame.height/2), borderWidth: 0)
   
        let error = "ERROR_CODE_625".localized
        lblMessage.text = error
        lblMessage.textColor = UIColor.themeTextColor

        
        
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
    }

    @IBAction func actionCancel(_ sender: UIButton) {
        self.onClickCancelButton!();
//        self.alertView.isHidden = false
//        self.viewPromoList.isHidden = true
    }

    @IBAction func actionGoToHub(_ sender: UIButton) {
        self.onClickGoToHubButton!();
//        self.alertView.isHidden = false
//        self.viewPromoList.isHidden = true
    }

}
