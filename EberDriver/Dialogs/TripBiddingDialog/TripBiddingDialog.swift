//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class TripBiddingDialog:CustomDialog {

    //MARK: - OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblMaxBidLimit: UILabel!
    @IBOutlet weak var vwEditText: UIView!
    @IBOutlet weak var editText: ACFloatingTextfield!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var alertView: UIView!

    //MARK: - Variables
    var onClickRightButton : ((_ dialog:TripBiddingDialog ) -> Void)? = nil
    var onClickBtnChange : ((_ dialog:TripBiddingDialog ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var price: Double = 0
    var isAcceptedWithSamePrice: Bool = false
    
    static let  verificationDialog = "TripBiddingDialog"

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public static func showDialog
    (price: Double, tag: Int = 159) -> TripBiddingDialog {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TripBiddingDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.tag = tag
        
        view.price = price
        view.setLocalization()

        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }

    func setLocalization() {
        /* Set Color */
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
        lblMaxBidLimit.textColor = .themeWalletDeductedColor
        editText.textColor = UIColor.themeTextColor
        editText.delegate = self
        
        btnChange.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnChange.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        btnChange.backgroundColor = UIColor.themeButtonBackgroundColor
        
        btnChange.setupButton()
        btnRight.setupButton()
        
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        btnChange.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        lblMessage.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblMaxBidLimit.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        editText.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        btnLeft.setTitle("TXT_CLOSE".localized, for: UIControl.State.normal)
        btnRight.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        btnChange.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        
        lblTitle.text = "txt_bidding".localized
        lblMessage.text = "txt_bidding_price".localized.replacingOccurrences(of: "****", with: "\(price.toCurrencyString())")
        
        editText.placeholder = "txt_enter_bid_price".localized
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if let priceDouble = Double(editText.text!) {
            self.isAcceptedWithSamePrice = priceDouble == self.price
        }
        if self.onClickRightButton != nil {
            self.onClickRightButton!(self)
        }
    }
    
    @IBAction func onClickBtnChange(_ sender: Any) {
        if editText.text!.isEmpty {
            Utility.showToast(message: "txt_enter_bidding_price".localized)
        } else {
            if let priceDouble = Double(editText.text!) {
                self.isAcceptedWithSamePrice = priceDouble == self.price
            }

            if self.onClickBtnChange != nil {
                self.onClickBtnChange!(self)
            }
        }
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
    }
}

extension TripBiddingDialog: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.editText {
            textField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == editText {
            var updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            
            if let currentInputMode = textField.textInputMode {
                let localeIdentifier = editText.doubleValueLocale != nil ? editText.doubleValueLocale! : (currentInputMode.primaryLanguage ?? "en")
                let decimalSeparator = Locale(identifier: localeIdentifier).decimalSeparator ?? "."
                updatedText = updatedText.replacingOccurrences(of: decimalSeparator, with: ".")
                editText.doubleValueLocale = localeIdentifier
            }
            
            if updatedText.isEmpty {
                editText.doubleValueText = nil
                editText.doubleValueLocale = nil
                return true
            }
            if let value = updatedText.toEnglishDouble() {
                editText.doubleValueText = value
                return true
            }
        }
        return false
    }
}
