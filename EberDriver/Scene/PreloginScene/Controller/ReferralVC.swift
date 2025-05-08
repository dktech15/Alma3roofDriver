//
//  ReferralVC.swift
//  Cabtown
//
//  Created by Jaydeep Vyas  on 30/08/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class ReferralVC: BaseVC {
    
    @IBOutlet weak var txtReferralCode: ACFloatingTextfield!
    
    @IBOutlet var lblImgWarning: UILabel!
    @IBOutlet var imgImgWarning : UIImageView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var viewForReferralError: UIView!
    @IBOutlet weak var lblReferralMsg: UILabel!
    @IBOutlet weak var lblReferralErrorMsg: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var lblImgReferral: UILabel!
    @IBOutlet var imgImgReferral : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ =   txtReferralCode.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
    }
    
    func initialViewSetup() {
        lblTitle.text = "TXT_REFERRAL".localized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        
        lblReferralMsg.text = "TXT_REFERRAL_MSG".localized
        lblReferralMsg.textColor = UIColor.themeTextColor
        lblReferralMsg.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblReferralErrorMsg.text = "TXT_REFERRAL_ERROR_MSG".localized
        lblReferralErrorMsg.textColor = UIColor.themeTextColor
        lblReferralErrorMsg.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        
        btnSkip.setTitle("TXT_SKIP".localizedCapitalized, for: .normal)
        btnSkip.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnSkip.setTitleColor(UIColor.themeButtonBackgroundColor, for: .selected)
        btnSkip.backgroundColor = UIColor.clear
        btnSkip.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        btnSubmit.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmit.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        btnSubmit.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
        
        txtReferralCode.placeholder = "TXT_ENTER_REFERRAL_CODE".localized
        
//        lblImgReferral.text = FontAsset.icon_referral
//        lblImgReferral.font = FontHelper.assetFont(size: lblImgReferral.font!.pointSize)
        imgImgReferral.tintColor = UIColor.themeImageColor
//        lblImgWarning.text = FontAsset.icon_warning
//        lblImgWarning.font = FontHelper.assetFont(size: lblImgWarning.font!.pointSize)
//        lblImgWarning.setForIcon()
//        lblImgReferral.setForIcon()
        imgImgWarning.tintColor = UIColor.themeImageColor
    }
    
    //MARK:- Action Methods
    @IBAction func onClickBtnSubmit(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation() {
            btnSkip.isSelected = false
            wsApplyReferral()
        }
    }
    
    @IBAction func onClickBtnSkip(_ sender: Any) {
        btnSkip.isSelected = true
        wsApplyReferral()
    }
    
    func checkValidation() -> Bool {
        if txtReferralCode.text?.isEmpty() ?? false {
            txtReferralCode.showErrorWithText(errorText: "VALIDATION_MSG_INVALID_REFERRAL_CODE".localized)
            return false
        }else {
            return true
        }
    }
}

extension ReferralVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension ReferralVC {
    func wsApplyReferral() {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        if btnSkip.isSelected {
            dictParam[PARAMS.REFERRAL_CODE] = ProviderSingleton.shared.provider.referralCode
            dictParam[PARAMS.REFERRAL_SKIP] = true
        }else {
            dictParam[PARAMS.REFERRAL_CODE] = txtReferralCode.text?.trim() ?? ""
            dictParam[PARAMS.REFERRAL_SKIP] = false
        }
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.APPLY_REFFERAL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            
            if (error != nil) {
                Utility.hideLoading()
            }else {
                if data != nil {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let responseModel = try! jsonDecoder.decode(ResponseModel.self, from: data!)
                        
                        if Parser.isSuccess(response: response,data: data) {
                            self.dismiss(animated: false, completion: nil)
                            if (ProviderSingleton.shared.provider.isDocumentUploaded == FALSE) {
                                APPDELEGATE.gotoDocument()
                            }else {
                                APPDELEGATE.gotoMap()
                            }
                        }else {
                            self.viewForReferralError.isHidden = false;
                            self.lblReferralErrorMsg.text = "ERROR_CODE_\(responseModel.errorCode)".localized
                            Utility.hideLoading()
                        }
                    }
                }
            }
        }
    }
}
