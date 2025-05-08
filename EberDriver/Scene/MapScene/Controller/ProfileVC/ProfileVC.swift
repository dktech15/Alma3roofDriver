//
//  ProfileVC.swift
//  Eber Driver
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC,OtpDelegate {

    //MARK: - Outlets Declaration
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    @IBOutlet weak var scrProfile: UIScrollView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnSelectCountry: UIButton!
    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txtAddress: ACFloatingTextfield!
    @IBOutlet weak var txtNewPassword: ACFloatingTextfield!
    @IBOutlet weak var btnChangePicuture: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewForNewPassword: UIView!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnHideShowPassword: UIButton!
    @IBOutlet weak var btnDeleteAccount: UIButton!

    @IBOutlet weak var stackViewProfile: UIStackView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    //MARK: - Variable Declaration
    var isPicAdded: Bool = false
    var dialogForImage:CustomPhotoDialog?;
    var password:String = "";
    var arrForCountryList: NSMutableArray = NSMutableArray.init()
    var strCountryId:String? = ""
    var strForCountryPhoneCode:String = ""
    let provider = ProviderSingleton.shared.provider
    var strCountryCode = ""

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
        if provider.socialUniqueId.isEmpty {
            viewForNewPassword.isHidden = false
        } else {
            viewForNewPassword.isHidden = true
        }
        self.wsGetCountries()
        setProfileData();
    }

    @IBAction func onClickBtnHideShowPassword(_ sender: Any) {
        txtNewPassword.isSecureTextEntry = !txtNewPassword.isSecureTextEntry
        btnHideShowPassword.isSelected.toggle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackViewProfile.isHidden = !preferenceHelper.getIsGenderShow()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        navigationView.navigationShadow()
        imgProfilePic.setRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }

    func initialViewSetup() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.scrProfile.backgroundColor = UIColor.themeViewBackgroundColor;
        lblTitle.text = "TXT_PROFILE".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        btnChangePassword.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnChangePassword.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnChangePassword.setTitle("TXT_CHANGE".localizedCapitalized, for: .normal)
        btnChangePassword.setTitle("TXT_CANCEL".localizedCapitalized, for: .selected)
        txtFirstName.placeholder = "TXT_FIRST_NAME".localized
        txtFirstName.text = "".localized
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtLastName.text = "".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtEmail.text = "".localized
        txtNewPassword.placeholder = "TXT_NEW_PASSWORD".localized
        txtNewPassword.text = "".localized
        txtMobileNumber.placeholder = "TXT_PHONE_NO".localized
        txtMobileNumber.text = "".localized
        txtAddress.placeholder = "TXT_ADDRESS".localized
        txtAddress.text = "".localized
        btnDeleteAccount.setTitle("txt_delete_account".localized, for: .normal)
        btnDeleteAccount.setTitleColor(.red, for: .normal)
        btnSelectCountry.setTitle("TXT_DEFAULT".localized, for: .normal)
        btnSelectCountry.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnSelectCountry.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
        btnSave.setImage(UIImage(named: "asset-edit_u"), for: .normal)
        btnSave.setImage(UIImage(named: "asset-save_u"), for: .selected)
        btnSave.tintColor = UIColor.themeImageColor
        
//        btnSave.setTitle(FontAsset.icon_edit, for: .normal)
//        btnSave.setTitle(FontAsset.icon_checked, for: .selected)
//        btnSave.setTitleColor(UIColor.themeTextColor, for: .normal)
//        btnSave.setUpTopBarButton()
//        btnHideShowPassword.setTitle(FontAsset.icon_hide_password, for: .normal)
//        btnHideShowPassword.setTitle(FontAsset.icon_show_password, for: .selected)
//        btnHideShowPassword.setSimpleIconButton()
//        btnHideShowPassword.titleLabel?.font = FontHelper.assetFont(size: 25)
        btnHideShowPassword.setImage(UIImage(named: "asset-password-hide"), for: .normal)
        btnHideShowPassword.setImage(UIImage(named: "asset-password-show"), for: .selected)
        
        btnMale.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        btnMale.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
        btnMale.tintColor = UIColor.themeImageColor
        btnFemale.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        btnFemale.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
        btnFemale.tintColor = UIColor.themeImageColor
    }

    func onOtpDone() {
        self.openVerifyAccountDialog()
    }

    @IBAction func onClickBtnMale(_ sender: Any) {
//        btnMale.isSelected = true
//        btnFemale.isSelected = false
    }
    @IBAction func onClickBtnFemale(_ sender: Any) {
//        btnMale.isSelected = false
//        btnFemale.isSelected = true
    }
    
    @IBAction func onClickBtnCountryDialog(_ sender: Any) {
        //openCountryDialog()
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        txtNewPassword.text = ""
        btnChangePassword.isSelected = !btnChangePassword.isSelected
        txtNewPassword.isEnabled = !txtNewPassword.isEnabled
        if btnChangePassword.isSelected {
            _ =  txtNewPassword.becomeFirstResponder()
        }
    }

    @IBAction func onClickBtnSave(_ sender: Any) {
        self.view.endEditing(true)
        editProfile()
        btnSave.isSelected = true
    }

    @IBAction func onClickBtnEditImage(_ sender: Any) {
        openImageDialog()
    }

    func openImageDialog() {
        self.view.endEditing(true)
        self.dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, allowsEditing: true, andParent: self)
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperview()
        }
    }

    //MARK: - User Define Methods
    func checkValidation() -> Bool {
        let validEmail = txtEmail.text!.checkEmailValidation()
        if validEmail.0 == false {
            txtEmail.showErrorWithText(errorText: validEmail.1)
            scrProfile.scrollRectToVisible(txtEmail.frame, animated: true)
            return false
        }

        let validPhoneNumber = txtMobileNumber.text!.isValidMobileNumber()
        if validPhoneNumber.0 == false {
            txtMobileNumber.showErrorWithText(errorText: validPhoneNumber.1)
            scrProfile.scrollRectToVisible(txtMobileNumber.frame, animated: true)
            return false
        }

        let validPassword = txtNewPassword.text!.checkPasswordValidation()
        if validPassword.0 == false && txtNewPassword.isEnabled {
            txtNewPassword.showErrorWithText(errorText: validPassword.1)
            scrProfile.scrollRectToVisible(txtNewPassword.frame, animated: true)
            return false
        } else {
            return true
        }
    }

    func enableTextFields(enable: Bool) -> Void {
        txtFirstName.isEnabled = enable
        txtLastName.isEnabled = enable
        txtMobileNumber.isEnabled = enable
        txtAddress.isEnabled = enable
        txtEmail.isEnabled = false
        txtNewPassword.isEnabled = false
        btnChangePassword.isEnabled = enable
        btnSelectCountry.isEnabled = enable
        btnChangePicuture.isEnabled = enable
        btnHideShowPassword.isEnabled = enable
    }

    func setProfileData() {
        txtFirstName.text = provider.firstName
        txtLastName.text = provider.lastName
        txtMobileNumber.text = provider.phone;
        txtAddress.text = provider.address;
        btnSelectCountry.setTitle(provider.countryPhoneCode, for: .normal)
        btnChangePassword.isSelected = false
        txtEmail.text = provider.email
        txtNewPassword.isHidden = false
        if !provider.picture.isEmpty {
            imgProfilePic.downloadedFrom(link: provider.picture)
        }
        provider.gender_type == 0 ? (btnMale.isSelected = true) : (btnMale.isSelected = false)
        provider.gender_type == 1 ? (btnFemale.isSelected = true) : (btnFemale.isSelected = false)
        btnFemale.isUserInteractionEnabled = false
        btnMale.isUserInteractionEnabled = false
        strForCountryPhoneCode = provider.countryPhoneCode
        enableTextFields(enable: false)
    }

    func editProfile() -> Void {
        if (!txtFirstName.isEnabled) {
            enableTextFields(enable: true)
            _ =  txtFirstName.becomeFirstResponder()
        } else {
            if (checkValidation()) {
                switch (self.checkWhichOtpValidationON()) {
                    case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                        wsGetOtp(isEmailOtpOn: true, isSmsOtpOn: true)
                        break;
                    case CONSTANT.SMS_VERIFICATION_ON:
                        wsGetOtp(isEmailOtpOn: false, isSmsOtpOn: true)
                        break;
                    case CONSTANT.EMAIL_VERIFICATION_ON:
                        wsGetOtp(isEmailOtpOn: true, isSmsOtpOn: false)
                        break;
                    default:
                        self.openVerifyAccountDialog();
                        break;
                }
            }
        }
    }

    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
            navigationVC.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func onClickDeleteAccount(_ sender: Any) {
        self.view.endEditing(true)
        let dailog = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRM".localized, message: "txt_are_you_sure_account_delete".localized, titleLeftButton: "TXT_NO".localizedCapitalized, titleRightButton: "TXT_YES".localized)
        dailog.onClickRightButton = { [weak self] in
            dailog.removeFromSuperview()
            guard let self = self else { return }
            self.openVerifyAccountDialog(isDelete: true)
        }
        dailog.onClickLeftButton = {
            dailog.removeFromSuperview()
        }
    }

    //MARK: - Dialog Methods
    func checkWhichOtpValidationON() -> Int{
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON;
        } else if (checkPhoneNumberVerification()) {
            return CONSTANT.SMS_VERIFICATION_ON;
        } else if (checkEmailVerification()) {
            return CONSTANT.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }

    func checkEmailVerification() -> Bool{
        return false
    }

    func checkPhoneNumberVerification() -> Bool{
        return preferenceHelper.getIsPhoneNumberVerification() && !(txtMobileNumber.text! == provider.phone)
    }

    func openVerifyAccountDialog(isDelete: Bool = false) {
        self.view.endEditing(true)
        if !provider.socialUniqueId.isEmpty {
            self.password = ""
            if isDelete {
                self.wsDeleteAccount()
            } else {
                self.wsUpdateProfile()
            }
        } else {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized, editTextHint: "TXT_CURRENT_PASSWORD".localized,  editTextInputType: true)
            dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
                dialogForVerification.removeFromSuperview();
            }
            dialogForVerification.onClickRightButton = { [unowned self, unowned dialogForVerification] (text:String) in
                if (text.count < passwordMinLength) {
                    let myString = String(format: NSLocalizedString("VALIDATION_MSG_INVALID_PASSWORD", comment: ""),passwordMinLength.toString())
                    dialogForVerification.editText.showErrorWithText(errorText: myString)
                } else {
                    self.password = text
                    if isDelete {
                        self.wsDeleteAccount()
                    } else {
                        self.wsUpdateProfile()
                    }
                    dialogForVerification.removeFromSuperview();
                }
            }
        }
    }

    func openCountryDialog() {
        self.view.endEditing(true)
        self.view.endEditing(true)
        let dialogForCountry  = CustomCountryDialog.showCustomCountryDialog(withDataSource: arrForCountryList)
        dialogForCountry.onCountrySelected = { [unowned self, unowned dialogForCountry] (country:Country) in
            if country.countryphonecode != self.strForCountryPhoneCode {
                self.txtMobileNumber.text = ""
                self.strForCountryPhoneCode = country.countryphonecode
                self.btnSelectCountry.setTitle(self.strForCountryPhoneCode, for: .normal)
            }
            dialogForCountry.removeFromSuperview()
        }
    }
}

//MARK: - UITextField Delegate Methods
extension ProfileVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            _ = txtLastName.becomeFirstResponder()
        }
        if textField == txtLastName {
            _ = txtEmail.becomeFirstResponder()
        } else if textField == txtEmail {
            _ = txtMobileNumber.becomeFirstResponder()
        } else if textField == txtMobileNumber {
            if txtAddress.isHidden {
            } else {
                _ = txtAddress.becomeFirstResponder()
            }
        } else if textField == txtAddress {
            _ = textField.resignFirstResponder();
        } else {
            _ = textField.resignFirstResponder();
            return true
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber {
            if (string == "") || string.count < 1 {
                return true
            } else if (textField.text?.count)! >= preferenceHelper.getMaxMobileLength() {
                return false
            }
        }
        return true;
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - Web Service Calls
extension ProfileVC {
    func wsUpdateProfile() {
        let name = txtFirstName.text!.trim()
        let lastname = txtLastName.text!.trim()
        let dictParam: [String: Any] =
            [PARAMS.FIRST_NAME: name,
             PARAMS.LAST_NAME: lastname,
             PARAMS.EMAIL: txtEmail.text!,
             PARAMS.OLD_PASSWORD: password,
             PARAMS.NEW_PASSWORD: txtNewPassword.text ?? "",
             PARAMS.LOGIN_BY: CONSTANT.MANUAL,
             PARAMS.COUNTRY_PHONE_CODE:strForCountryPhoneCode,
             PARAMS.PHONE: txtMobileNumber.text!,
             PARAMS.ADDRESS: txtAddress.text ?? "",
             PARAMS.DEVICE_TYPE: CONSTANT.IOS,
             PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
             PARAMS.TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.SOCIAL_UNIQUE_ID: provider.socialUniqueId,
             "gender_type" : btnMale.isSelected ? 0 : 1
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        Utility.showLoading()
        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.UPADTE_PROFILE, paramData: dictParam, image: imgProfilePic.image) {
                (response, data, error) -> (Void) in
                Utility.hideLoading()
                if Parser.parseProviderData(response: response, data: data) {
                    Utility.showToast(message: "MSG_CODE_19".localized)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            alamoFire.getResponseFromURL(url: WebService.UPADTE_PROFILE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
                Utility.hideLoading()
                if Parser.parseProviderData(response: response, data: data) {
                    Utility.showToast(message: "MSG_CODE_19".localized)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func wsGetOtp(isEmailOtpOn: Bool,isSmsOtpOn: Bool) {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        _ = txtEmail.text?.trim() ?? ""
        let strPhoneNumber = txtMobileNumber.text?.trim() ?? ""

        var dictParam: [String: Any] = [:]
        dictParam[PARAMS.PHONE] = strPhoneNumber
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_PROVIDER

        afh.getResponseFromURL(url: WebService.GET_VERIFICATION_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            print(Utility.convertDictToJson(dict: response))
            if (error != nil) {
                Utility.hideLoading()
            } else {
                Utility.hideLoading()
                if Parser.isSuccess(response: response,data: data) {
                    let smsOtp:String = (response[PARAMS.SMS_OTP] as? String) ?? ""
                    let emailOtp:String = (response[PARAMS.EMAIL_OTP] as? String) ?? ""
                    if let otpvc:OtpVC = AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC {
                        self.present(otpvc, animated: true, completion: {
                            otpvc.delegate = self
                            otpvc.strForCountryPhoneCode = self.strForCountryPhoneCode
                            otpvc.strForPhoneNumber = strPhoneNumber
                            otpvc.updateOtpUI(otpEmail: emailOtp, otpSms: smsOtp, emailOtpOn: isEmailOtpOn , smsOtpOn: isSmsOtpOn)
                        })
                    }
                } else {
                    Utility.hideLoading()
                }
            }
        }
    }
    func wsGetCountries() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_COUTRIES, methodName: AlamofireHelper.POST_METHOD, paramData: Dictionary.init()) { (response, data, error) -> (Void) in
            Parser.parseCountries(response,data: data, toArray: self.arrForCountryList, completion: { [unowned self] result in
                if result {
                    for country in self.arrForCountryList{
                        let country = country as! Country
                        if country.countryphonecode == provider.countryPhoneCode{
                            strCountryCode = country.alpha2
                        }
                    }
                }
                Utility.hideLoading()
            })
        }
    }
    
    func wsDeleteAccount() {
        Utility.showLoading()
        
        let dictParam : [String : Any] =
            [
                PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                PARAMS.PASSWORD : self.password,
                PARAMS.SOCIAL_ID : ProviderSingleton.shared.provider.socialUniqueId,
                PARAMS.TOKEN : preferenceHelper.getSessionToken()
        ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_PROVIDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                preferenceHelper.setSessionToken("");
                preferenceHelper.setUserId("");
                ProviderSingleton.shared.clear()
                preferenceHelper.removeImageBaseUrl()
                UIViewController.clearPBRevealVC()
                APPDELEGATE.gotoLogin()
            }
        }
    }
}
