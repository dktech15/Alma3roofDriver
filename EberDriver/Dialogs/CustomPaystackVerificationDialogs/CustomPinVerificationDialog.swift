//
//  CustomPinVerificationDialog.swift
//  Eber
//
//  Created by Jaydeep Vyas  on 17/08/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class CustomPinVerificationDialog: CustomDialog
{
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txtF: UITextField!
    let datePicker = UIDatePicker()

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
     isHideBackButton : Bool,
     isShowBirthdayTextfield : Bool = false
    ) ->
    CustomPinVerificationDialog
    {


        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPinVerificationDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;

        view.txtF.placeholder = txtFPlaceholder

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

        if isShowBirthdayTextfield{
            view.setDatePicker()
            view.txtF.inputView = view.datePicker
        }else{
            view.txtF.keyboardType = .numberPad
        }

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
//        setDatePicker()
//        txtF.inputView = datePicker
        txtF.keyboardType = .numberPad
        txtF.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }

    func setDatePicker() {
        //Format Date
        datePicker.locale = Locale(identifier: preferenceHelper.getLanguageCode())
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        txtF.inputAccessoryView = toolbar
    }

    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        formatter.dateFormat = "MM-dd-yyyy"
        txtF.text = formatter.string(from: datePicker.date)
        self.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.endEditing(true)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{

        if textField == self.txtF
        {
            textField.resignFirstResponder()
        }
        else
        {
            textField.resignFirstResponder();
        }
        return true
    }

    //ActionMethods

    @IBAction func onClickBtnLeft(_ sender: Any)
    {
            self.onClickLeftButton!();
    }
    @IBAction func onClickBtnRight(_ sender: Any)
    {
        self.onClickRightButton!(txtF.text ?? "")
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()

    }

}
