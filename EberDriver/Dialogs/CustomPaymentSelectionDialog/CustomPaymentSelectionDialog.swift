//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomPaymentSelectionDialog: CustomDialog
{
    //MARK: - OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    
    @IBOutlet weak var viewForCard: UIView!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    
    @IBOutlet weak var viewForCash: UIView!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var lblCash: UILabel!
    
    @IBOutlet weak var divider1: UIView!
    @IBOutlet weak var divider2: UIView!
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var lblIconCard: UILabel!
    @IBOutlet weak var imgIconCard: UIImageView!
    @IBOutlet weak var lblIconCash: UILabel!
    @IBOutlet weak var imgIconCash: UIImageView!

    @IBOutlet weak var viewForApple: UIView!
    @IBOutlet weak var btnApplePay: UIButton!
    @IBOutlet weak var lblApplePay: UILabel!
    @IBOutlet weak var imgApplePay: UIImageView!

    //MARK:Variables
    var onClickPaymentModeSelected : ((_ paymentMode: Int) -> Void)? = nil
    static let  verificationDialog = "CustomPaymentSelectionDialog"
    var paymentMode = PaymentMode.UNKNOWN

    public static func showCustomPaymentSelectionDialog() -> CustomPaymentSelectionDialog
    {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPaymentSelectionDialog
        view.alertView.backgroundColor = UIColor.themeDialogBackgroundColor
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        //view.viewForCard.isHidden = CurrentTrip.shared.isCardModeAvailable == FALSE
        //view.viewForCash.isHidden = CurrentTrip.shared.isCashModeAvailable == FALSE
        view.viewForApple.isHidden = !StripeApplePayHelper.isApplePayAvailable()
        view.setLocalization()
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        return view;
    }

    func setLocalization() {
        self.lblCard.text = "TXT_CARD".localized
        self.lblCard.textColor = UIColor.themeTextColor
        lblCard.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        self.lblCash.text = "TXT_CASH".localized
        self.lblCash.textColor = UIColor.themeTextColor
        lblCash.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)

        self.lblApplePay.text = "TXT_APPLE_PAY".localized
        self.lblApplePay.textColor = UIColor.themeTextColor
        lblApplePay.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)

        self.alertView.setShadow()
        divider1.backgroundColor = UIColor.themeLightDividerColor
        divider2.backgroundColor = UIColor.themeLightDividerColor
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeDialogBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        imgIconCard.tintColor = UIColor.themeImageColor
        imgIconCash.tintColor = UIColor.themeImageColor
        imgApplePay.tintColor = UIColor.themeImageColor
//        self.lblIconCard.text = FontAsset.icon_payment_card
//        self.lblIconCash.text = FontAsset.icon_payment_cash
//        self.lblIconCash.setForIcon()
//        self.lblIconCard.setForIcon()
        self.hideShowView()
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnCash(_ sender: Any)
    {
        self.paymentMode = PaymentMode.CASH
        if self.onClickPaymentModeSelected != nil
        {
            self.onClickPaymentModeSelected!(self.paymentMode)
        }
        self.removeFromSuperview()
    }

    @IBAction func onClickBtnCard(_ sender: Any)
    {
        self.paymentMode = PaymentMode.CARD
        if self.onClickPaymentModeSelected != nil
        {
            self.onClickPaymentModeSelected!(self.paymentMode)
        }
        self.removeFromSuperview()
    }

    @IBAction func onClickBtnApple(_ sender: Any)
    {
        self.paymentMode = PaymentMode.APPLE_PAY
        if self.onClickPaymentModeSelected != nil
        {
            self.onClickPaymentModeSelected!(self.paymentMode)
        }
        self.removeFromSuperview()
    }

    //MARK: - Custom Methods
    func hideShowView() {
        var count:Int = 0
        if self.viewForCard.isHidden == false {
            count += 1
        }
        if self.viewForCash.isHidden == false {
            count += 1
            if count == 2 {
                self.divider1.isHidden = false
            } else {
                self.divider1.isHidden = true
            }
        }
        if self.viewForApple.isHidden == false {
            count += 1
            if count == 2 && self.viewForCash.isHidden == false {
                self.divider2.isHidden = false
            } else if count == 2 && self.viewForCard.isHidden == false {
                self.divider1.isHidden = false
            } else {}

            if count == 3 {
                self.divider2.isHidden = false
            }
        }
    }
}
