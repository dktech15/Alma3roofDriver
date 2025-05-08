//
//  CustomPhotoDialog.swift
//  Eber
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomAppleCardDialog: CustomDialog
{
    //MARK: - OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    
    @IBOutlet weak var viewForCard: UIView!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var lblIconCard: UILabel!
    @IBOutlet weak var imgIconCard: UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton!

    //MARK:Variables
    var onClickPaymentModeSelected : ((_ paymentMode: Int) -> Void)? = nil
    static let  verificationDialog = "CustomAppleCardDialog"
    var paymentMode = PaymentMode.UNKNOWN
    var applePayButton: ApplePayButton?

    public static func showCustomPaymentSelectionDialog() -> CustomAppleCardDialog
    {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAppleCardDialog
        view.alertView.backgroundColor = UIColor.themeDialogBackgroundColor
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        
        if StripeApplePayHelper.isApplePayAvailable() {
            view.applePayButton = ApplePayButton()
            view.applePayButton?.addApplePayInVw(inVw: view.stkDialog, target: view, action: #selector(view.handleApplePayButtonTapped))
        }
        
        view.setLocalization()
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        return view;
    }

    func setLocalization() {
        self.lblCard.text = "TXT_CARD".localized
        self.lblCard.textColor = UIColor.themeTextColor
        lblCard.font = FontHelper.font(size: FontSize.button, type: FontType.Regular)
        
        self.alertView.setShadow()
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeDialogBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        btnCancel.setTitle("TXT_CANCEL".localized, for: .normal)
        btnCancel.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnCancel.setTitleColor(.themeButtonBackgroundColor, for: .normal)
        
        viewForCard.setRound(withBorderColor: .black, andCornerRadious: 4, borderWidth: 0.8)

        self.hideShowView()
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
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @objc func handleApplePayButtonTapped() {
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
    }
}
