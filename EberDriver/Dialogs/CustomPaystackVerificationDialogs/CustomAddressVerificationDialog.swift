//
//  CustomAddressVerificationDialog.swift
//  EberDriver
//
//  Created by Jaydeep Vyas  on 23/08/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class CustomAddressVerificationDialog: CustomDialog {
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!

    @IBOutlet weak var txtF: UITextField!
    @IBOutlet weak var txtFZipCode: UITextField!
    @IBOutlet weak var txtFCity: UITextField!
    @IBOutlet weak var txtFState: UITextField!


    //MARK:Variables
    var onClickRightButton : ((_ text:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil

    static let  verificationDialog = "DialogForPinVerification"

    public static func  showCustomAlertDialog
    (title:String,
     message:String,
     titleLeftButton:String,
     titleRightButton:String,
     txtFPlaceholder:String,
     tag:Int = 400,
     isHideBackButton : Bool
    ) ->
    CustomAddressVerificationDialog
    {


        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAddressVerificationDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;

        view.txtF.placeholder = txtFPlaceholder
        view.txtFCity.placeholder = "Enter City Name"
        view.txtFState.placeholder = "Enter State Name"
        view.txtFZipCode.placeholder = "Enter Zipcode"

        view.setLocalization()
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        if let view = (APPDELEGATE.window?.viewWithTag(400))
        {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        else
        {
            UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        view.btnRight.isHidden =  titleRightButton.isEmpty()
        view.lblTitle.isHidden = title.isEmpty()

        view.btnLeft.isHidden = isHideBackButton
        view.btnRight.isEnabled = false

        return view;
    }

    func setLocalization(){
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor

        btnRight.setupButton()
        /* Set Font */
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Light)

        txtF.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        txtFZipCode.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        txtFCity.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        txtFState.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)

        txtF.keyboardType = .default
        txtFZipCode.keyboardType = .numberPad
        txtFCity.keyboardType = .default
        txtFState.keyboardType = .default

        txtF.textColor = UIColor.themeTextColor
        txtFZipCode.textColor = UIColor.themeTextColor
        txtFCity.textColor = UIColor.themeTextColor
        txtFState.textColor = UIColor.themeTextColor

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }

    func checkValidation(){
        if txtF.text!.count <= 0 {
            btnRight.isEnabled = false
        }else if txtFCity.text!.count <= 0 {
            btnRight.isEnabled = false
        }else if txtFState.text!.count <= 0 {
            btnRight.isEnabled = false
        }else if txtFZipCode.text!.count <= 0 {
            btnRight.isEnabled = false
        }else{
            btnRight.isEnabled = true
            let str = txtF.text! + "," + txtFCity.text! + "," + txtFState.text! + "," + txtFZipCode.text!
            self.onClickRightButton!(str)
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder();
        return true
    }

    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any)
    {
        self.onClickLeftButton!();
    }
    @IBAction func onClickBtnRight(_ sender: Any)
    {
        checkValidation()
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()

    }

}
