//
//  SendMoneyPopup.swift
//  Eber
//
//  Created by Rohit on 17/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class SendMoneyPopup: UIView {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewUserDetails: UIView!
    @IBOutlet weak var viewSendMoney: UIView!
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewSearchText: UIView!
    @IBOutlet weak var viewSendText: UIView!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUserDetails: UILabel!
    @IBOutlet weak var lblSendMoney: UILabel!
    
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var txtSendMoney : UITextField!
    @IBOutlet weak var txtUserNumber : UITextField!
    
    var onClickCancelButton : (() -> Void)? = nil
    var userId = ""
    var waletAmount = 0.0

    static let sendMoneyPopup = "SendMoneyPopup"
    public static func showCustomVerificationDialog
        (amount : Double,
         editTextInputType:Bool = false,
         offerbutton:Bool = false,
         countryId:String = "",
         cityId:String = "") -> SendMoneyPopup {
        
        let view = UINib(nibName: sendMoneyPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SendMoneyPopup
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.waletAmount = amount
        view.viewSendMoney.isHidden = true
        view.viewUserDetails.isHidden = true
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    func setLocalization(){
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        viewSearchText.setRound(withBorderColor: UIColor.themeLightTextColor
                               , andCornerRadious: 5.0, borderWidth: 1.0)
        viewSendText.setRound(withBorderColor: UIColor.themeLightTextColor
                               , andCornerRadious: 5.0, borderWidth: 1.0)
        
        viewSearch.backgroundColor = UIColor.themeButtonBackgroundColor
        viewSearch.sizeToFit()
        viewSearch.setRound(withBorderColor: .clear, andCornerRadious: (viewSearch.frame.height/2), borderWidth: 0)
   
        viewSend.backgroundColor = UIColor.themeButtonBackgroundColor
        viewSend.sizeToFit()
        viewSend.setRound(withBorderColor: .clear, andCornerRadious: (viewSend.frame.height/2), borderWidth: 0)
   
        lblUserDetails.textColor = UIColor.themeTextColor
        lblSendMoney.textColor = UIColor.themeTextColor
        
        
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblUserDetails.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblSendMoney.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        
        lblUserName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblEmail.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblPhone.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblCountryCode.text = preferenceHelper.getCountryCode()
        
    }

    @IBAction func actionCancel(_ sender: UIButton) {
        self.onClickCancelButton!();
//        self.alertView.isHidden = false
//        self.viewPromoList.isHidden = true
    }
    @IBAction func actionSearch(_ sender: UIButton) {
        self.getUserDetais()
    }
    @IBAction func actionSend(_ sender: UIButton) {
        self.sendMoney()
    }
    
    func getUserDetais(){
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.PHONE] = txtUserNumber.text!
        dictParam[PARAMS.TYPE] = 2//CONSTANT.TYPE_PROVIDER.toString()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SEARCH_USER_TO_SEND_MONEY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response,data, error)  -> (Void) in
            Utility.hideLoading()
            print(response)
            if (error != nil) {
                Utility.showToast(message: "Please Enter Valid Number")

            }else{
                self.viewUserDetails.isHidden = true
                self.viewSendMoney.isHidden = true
                self.viewNoData.isHidden = false
                if let data = response["user_detail"] as? JSONType{
                    self.viewUserDetails.isHidden = false
                    self.viewSendMoney.isHidden = false
                    self.viewNoData.isHidden = true
                    if let ui = data["_id"] as? String{
                        self.userId = ui
                    }
                    if let phone = data["phone"] as? String{
                        self.lblPhone.text = phone
                        if let country_phone_code = data["country_phone_code"] as? String{
                            self.lblPhone.text = "\(country_phone_code) \(self.lblPhone.text!)"
                        }
                    }
                    if let email = data["email"] as? String{
                        self.lblEmail.text = email
                    }
                   
                    if let firstName = data["first_name"] as? String{
                        self.lblUserName.text = firstName
                        if let lastName = data["last_name"] as? String{
                            self.lblUserName.text = "\(self.lblUserName.text!) \(lastName)"
                        }
                    }
                }else{
                    Utility.showToast(message: "Please Enter Valid Number")
                }
            }
        }
    }
    
    func sendMoney(){
        if txtSendMoney.text!.isEmpty{
            Utility.showToast(message: "Please enter valid amount")
            return
        }
        let amount = Double(txtSendMoney.text!)
        if amount! < 1{
            Utility.showToast(message: "Please enter valid amount")
            return
        }
        if waletAmount < amount!{
            Utility.showToast(message: "Please enter valid amount")
            return
        }

        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.FRIEND_ID] = self.userId
        dictParam[PARAMS.AMOUNT] = Double(txtSendMoney.text!)
        dictParam[PARAMS.TYPE] = 2//CONSTANT.TYPE_PROVIDER.toString()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SEND_MONEY_TO_FRIEND, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response,data, error)  -> (Void) in
            Utility.hideLoading()
            print(response)
            if (error != nil) {
            }else{
                if let data = response["success"] as? Bool{
                    if data{
                        Utility.showToast(message: "Send successfully")
                        self.onClickCancelButton!();
                    }
                }
                
            }
        }
    }
}
