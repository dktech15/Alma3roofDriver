//
//  RegisterVC.swift
//  Eber
//
//  Created by Elluminati on 17/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class RegisterVC: BaseVC, OtpDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblRegisterWith: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var stkForSocialLogin: UIStackView!
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrRegister: UIScrollView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var lblAlreadyHaveAccount: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblConfirmationTermsAndCondition: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var vwTermsCondition: UIView!
    @IBOutlet weak var btnCheckTC: UIButton!
    var isSignInWithApple:Bool = false
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    
    /*View For Language Notification*/
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnHideShowPassword: UIButton!
    
    @IBOutlet weak var stackViewGender: UIStackView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    var dialogForImage:CustomPhotoDialog? = nil
    var dialogForCountry:CustomCountryDialog? = nil
    var isPicAdded: Bool = false
    var isLocationGet: Bool = false
    var isCountryListGet: Bool = false
    var socialId:String = ""
    var arrForCountryList : NSMutableArray = NSMutableArray.init()
    var arrForCityList : NSMutableArray = NSMutableArray.init()
    var strCountryId:String? = ""
    var strCityId:String? = ""
    var signInConfig: GIDConfiguration!
    var strCountryCode = ""
    @IBOutlet weak var hvwSocialLogin: NSLayoutConstraint!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
        self.wsGetCountries()
        LocationCenter.default.addObserver(self, [#selector(self.locationUpdate(_:)), #selector(self.locationFail(_:))])
        LocationCenter.default.startUpdatingLocation()
               
        if preferenceHelper.getIsUseSocialLogin() {
            viewForSocialLogin.isHidden = false
            lblOr.isHidden = false
        } else {
            viewForSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
        
        btnGoogle.style = .wide
        
        let btnFacebook = FBLoginButton()
        btnFacebook.permissions = ["public_profile", "email"]
        btnFacebook.delegate = self
        stkForSocialLogin.addArrangedSubview(btnFacebook)
        
        if #available(iOS 13.0, *) {
            self.hvwSocialLogin.constant = 150.0
            let btnAppleID = ASAuthorizationAppleIDButton()
            btnAppleID.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            stkForSocialLogin.addArrangedSubview(btnAppleID)
        } else {
            self.hvwSocialLogin.constant = 100.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance.signOut()
        stackViewGender.isHidden = !preferenceHelper.getIsGenderShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func onOtpDone() {
        self.wsRegister()
    }
    
    func initialViewSetup() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        
        lblTitle.text = "TXT_REGISTER".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        txtEmail.textColor = UIColor.themeTextColor;
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtEmail.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtPassword.textColor = UIColor.themeTextColor;
        txtPassword.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtPassword.placeholder = "TXT_PASSWORD".localized
        
        txtFirstName.textColor = UIColor.themeTextColor;
        txtFirstName.placeholder = "TXT_FIRST_NAME".localized
        txtFirstName.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtLastName.textColor = UIColor.themeTextColor;
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtLastName.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtAddress.textColor = UIColor.themeTextColor;
        txtAddress.placeholder = "TXT_ADDRESS".localized
        txtAddress.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtPhoneNumber.textColor = UIColor.themeTextColor;
        txtPhoneNumber.placeholder = "TXT_PHONE_NO".localized
        txtPhoneNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtCountry.textColor = UIColor.themeTextColor;
        txtCountry.placeholder = "TXT_SELECT_COUNTRY".localized
        txtCountry.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtCity.textColor = UIColor.themeTextColor;
        txtCity.placeholder = "TXT_SELECT_CITY".localized
        txtCity.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        lblOr.textColor = UIColor.themeLightTextColor
        lblOr.text = " --- " + "TXT_OR".localized + " --- "
        lblOr.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        
        lblRegisterWith.textColor = UIColor.themeLightTextColor
        lblRegisterWith.text = "TXT_REGISTER_WITH".localized
        lblRegisterWith.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        
        lblAlreadyHaveAccount.textColor = UIColor.themeLightTextColor
        lblAlreadyHaveAccount.text = "TXT_ALREADY_HAVE_ACCOUNT".localized
        lblAlreadyHaveAccount.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        
        lblConfirmationTermsAndCondition.text = "TXT_CONDITIONING_TEXT".localized
        lblConfirmationTermsAndCondition.textColor = UIColor.themeTextColor
        lblConfirmationTermsAndCondition.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblAnd.text = "TXT_AND".localized
        lblAnd.textColor = UIColor.themeTextColor
        lblAnd.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnTerms.setTitle("TXT_TERMS_CONDITIONS".localizedCapitalized, for: .normal)
        btnTerms.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnTerms.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnPrivacyPolicy.setTitle("TXT_PRIVACY_POLICY".localizedCapitalized, for: .normal)
        btnPrivacyPolicy.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnPrivacyPolicy.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        btnCountryCode.setTitle(ProviderSingleton.shared.currentCountryPhoneCode, for: .normal)
        btnCountryCode.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnCountryCode.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        btnLogin.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnLogin.setTitle("TXT_LOGIN".localizedCapitalized, for: UIControl.State.normal)
        btnLogin.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        btnRegister.setTitle( "TXT_REGISTER".localized, for: UIControl.State.normal)
        btnRegister.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRegister.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRegister.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnRegister.isEnabled = false
        btnRegister.alpha = 0.5
        
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
        
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
    
    func setupLayout() {
        btnRegister.setRound(withBorderColor: UIColor.clear, andCornerRadious:btnRegister.frame.height/2, borderWidth: 1.0)
        navigationView.navigationShadow()
    }
    
    //MARK: - USER DEFINE METHODS
    func checkValidation() -> Bool {
        let validEmail = txtEmail.text!.checkEmailValidation(isEmailVerficationNeedToCheck: false)
        let validPhoneNumber = txtPhoneNumber.text!.isValidMobileNumber()
        let validPassword = txtPassword.text!.checkPasswordValidation()
        
        if ((txtFirstName.text?.count)! < 1 && (socialId.isEmpty() || self.isSignInWithApple)) {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_FIRST_NAME".localized);
            txtFirstName.becomeFirstResponder();
            return false
        } else if ((txtLastName.text?.count)! < 1) && socialId.isEmpty() {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_LAST_NAME".localized);
            txtLastName.becomeFirstResponder();
            return false
        } else if (txtCity.text!.isEmpty()) {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_CITY".localized);
            txtCity.becomeFirstResponder();
            return false
        } else if (txtCountry.text!.isEmpty()) {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_COUNTRY".localized);
            txtCountry.becomeFirstResponder();
            return false
        } else if validPhoneNumber.0 == false {
            Utility.showToast(message: validPhoneNumber.1);
            txtPhoneNumber.becomeFirstResponder();
            return false
        } else if validEmail.0 == false && (socialId.isEmpty() || self.isSignInWithApple) {
            Utility.showToast(message: validEmail.1);
            txtEmail.becomeFirstResponder();
            return false
        } else if validPassword.0 == false && socialId.isEmpty() {
            Utility.showToast(message: validPassword.1)
            txtPassword.becomeFirstResponder();
            return false
        } else if !self.btnCheckTC.isSelected {
            Utility.showToast(message: "MSG_PLEASE_AGREE_TERMS_CONDITON".localized)
            return false
        } else {
            return true
        }
    }
    
    //MARK: - Button action methods
    
    //update- Code for latest SDK
    @IBAction func onClickBtnGoogle(_ sender: Any) {
        self.socialId = ""
        
        let signInConfig = GIDConfiguration.init(clientID:Google.CLIENT_ID)
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authResult, error in
            guard error == nil else { return }
            guard let user = authResult?.user, error == nil else {
                print(error?.localizedDescription ?? "Error Occured")
                return
            }

            let url = user.profile?.imageURL(withDimension: 0)?.absoluteString ?? ""
            let userId = user.userID ?? ""
            let fullName = user.profile?.name ?? ""
            let name = fullName.components(separatedBy: " ")
            let email = user.profile?.email ?? ""
            GIDSignIn.sharedInstance.signOut()
            self.updateUiForSocialLogin(email:email, socialId:userId, firstName:(name[0]), lastName:(name[1]), profileUri:url, isSigninWithapple:false)
        }
    }
    //
    
    @IBAction func onClickBtnRegister(_ sender: Any?) {
        if(self.checkValidation()) {
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
                wsRegister()
                break;
            }
        }
    }
    
    func checkWhichOtpValidationON() -> Int {
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON;
        } else if (checkPhoneNumberVerification()) {
            return CONSTANT.SMS_VERIFICATION_ON;
        } else if (checkEmailVerification()) {
            return CONSTANT.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }
    
    func checkEmailVerification() -> Bool {
        return preferenceHelper.getIsEmailVerification()
    }
    
    func checkPhoneNumberVerification() -> Bool {
        return preferenceHelper.getIsPhoneNumberVerification()
    }
    
    @IBAction func onClickBtnPhoto(_ sender: Any) {
        openImageDialog()
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onClickBtnFemale(_ sender: Any) {
        btnMale.isSelected = false
        btnFemale.isSelected = true
    }
    
    @IBAction func onClickBtnMale(_ sender: Any) {
        btnMale.isSelected = true
        btnFemale.isSelected = false
    }
    
    
    func openImageDialog() {
        self.view.endEditing(true)
        self.dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, allowsEditing: true, andParent: self)
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage]
            (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperview()
        }
    }
    
    @IBAction func onClickBtnLogin(_ sender: Any) {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller .isKind(of: LoginVC.self) {
                    navigationController.popToViewController(controller, animated: true)
                    return;
                }
            }
            self.navigationController?.pushViewController(AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "loginVC"), animated: true)
        }
    }
    
    @IBAction func onClickBtnHideShowPassword(_ sender: Any) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        btnHideShowPassword.isSelected.toggle()
    }
    
    //MARK: - Get FB Data
    func getFBUserData() {
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start { (connection, result, error) in
                Utility.hideLoading()
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    let email:String = (dict["email"] as? String) ?? ""
                    Profile.loadCurrentProfile(completion: { (profile, error) in
                        if (error == nil) {
                            self.updateUiForSocialLogin(email: email , socialId: (profile?.userID)!, firstName: (profile?.firstName)!, lastName: (profile?.lastName)!, profileUri: (profile?.imageURL(forMode: .normal, size: self.imgProfilePic.frame.size)?.absoluteString) ?? "",isSigninWithapple: false)
                        } else {
                            Utility.showToast(message: (error?.localizedDescription)!)
                        }
                    })
                }
            }
        }
    }
    
    //MARK: - GOOGLE SIGN METHOD
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUiForSocialLogin(email:String = "",
                                socialId:String = "",
                                firstName:String = "",
                                lastName:String = "",
                                profileUri:String = "",isSigninWithapple: Bool) {
        if (!email.isEmpty()) {
            txtEmail.text = email
            txtEmail.isEnabled = false
        }
        
        self.socialId = socialId;
        txtFirstName.text = firstName
        txtLastName.text = lastName
        vwPassword.isHidden = true
        
        if isSigninWithapple {
            if preferenceHelper.getSigninWithAppleEmail().count > 0 {
                self.txtEmail.text = preferenceHelper.getSigninWithAppleEmail()
            }
            
            if preferenceHelper.getSigninWithAppleUserName().count > 0 {
                if preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[0].count > 0 {
                    self.txtFirstName.text = preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[0]
                } else {
                    self.txtFirstName.text = preferenceHelper.getSigninWithAppleUserName()
                }
                
                if preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[1].count > 0 {
                    self.txtLastName.text = preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[1]
                }
            }
            if ((txtFirstName.text!.isEmpty)) {
                txtFirstName.isEnabled = true
                txtLastName.isEnabled = true
            } else {
                txtFirstName.isEnabled = false
                txtLastName.isEnabled = false
            }
            
            if ((txtEmail.text!.isEmpty)) {
                txtEmail.isEnabled = true
            } else {
                txtEmail.isEnabled = false
            }
        }
        LoginManager.init().logOut()
        if (!profileUri.isEmpty()) {
            imgProfilePic.downloadedFrom(link: profileUri,isAppendBaseUrl: false)
            isPicAdded = true
        }
    }
    
    @IBAction func onClickBtnTerms(_ sender: Any) {
        if let termsUrl:URL = URL.init(string: preferenceHelper.getTermsAndCondition()) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(termsUrl, options:[ : ], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(termsUrl)
            }
        }
    }
    
    @IBAction func onClickBtnPrivacy(_ sender: Any) {
        if let privacyUrl:URL = URL.init(string: preferenceHelper.getPrivacyPolicy()) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(privacyUrl, options:[ : ], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(privacyUrl)
            }
        }
    }
    
    @IBAction func onClickBtnCheckTC(_ sender: Any) {
        if btnCheckTC.isSelected {
            self.btnCheckTC.isSelected = false
            btnRegister.isEnabled = false
            btnRegister.alpha = 0.5
        } else {
            self.btnCheckTC.isSelected = true
            btnRegister.isEnabled = true
            btnRegister.alpha = 1.0
        }
    }
    
    override func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        guard let userInfo = ntf.userInfo else { return }
        guard let location = userInfo["location"] as? CLLocation else { return }
        LocationCenter.default.fetchCityAndCountry(location: location) { [weak self] (city, country, error) in
            self?.isLocationGet = true
            self?.fillCountry()
            LocationCenter.default.stopUpdatingLocation()
        }
    }
    
    override func locationFail(_ ntf: Notification = Common.defaultNtf) {
        print("Location:- \(ntf.description)")
        self.isLocationGet = true
        self.fillCountry()
    }
}

//MARK: - Text Field Delegates
extension RegisterVC : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - TEXTFIELD DELEGATE METHODS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCountry {
            self.view.endEditing(true)
            self.dialogForCountry = CustomCountryDialog.showCustomCountryDialog(withDataSource:arrForCountryList)
            self.dialogForCountry?.onCountrySelected = { [unowned self, weak dialogForCountry = self.dialogForCountry] (country:Country) in
                if self.strCountryId! == country.id {
                } else {
                    self.txtCity.text = ""
                    self.txtCountry.text = country.countryname
                    self.btnCountryCode.setTitle(country.countryphonecode, for: .normal)
                    self.strCountryId = country.id
                    self.strCountryCode = country.alpha2
                    self.txtPhoneNumber.text = ""
                    self.arrForCityList.removeAllObjects()
                    for city in country.cityList {
                        self.arrForCityList.add(city)
                    }
                }
                dialogForCountry?.removeFromSuperview()
            }
            return false
        }
        
        if textField == txtCity {
            self.view.endEditing(true)
            if self.arrForCityList.count > 0 {
                let dialogForCity = CustomCityDialog.showCustomCityDialog(withDataSource:  self.arrForCityList)
                dialogForCity.onCitySelected = { [unowned self, unowned dialogForCity] (cityID:String, cityName:String) in
                    self.strCityId = cityID
                    self.txtCity.text = cityName
                    dialogForCity.removeFromSuperview();
                }
            } else {
                Utility.showToast(message: "MSG_NO_CITY_FOUND_IN_SELECTED_COUNTRY".localized)
            }
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPhoneNumber {
            self.createToolbar(textfield: txtPhoneNumber)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        } else if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPhoneNumber {
            if txtAddress.isHidden {
                textField.resignFirstResponder()
            } else {
                txtAddress.becomeFirstResponder()
            }
        } else if textField == txtAddress {
            textField.resignFirstResponder()
        } else {
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhoneNumber {
            if  (string == "") || string.count < 1 {
                return true
            } else if (textField.text?.count)! >= preferenceHelper.getMaxMobileLength() {
                return false
            }
        }
        return true;
    }
    
    func createToolbar(textfield : UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "TXT_DONE".localized,
            style: .plain,
            target: self,
            action: #selector(doneTextField(sender:))
        )
        doneButton.tag = textfield.tag
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }
    
    @objc func doneTextField(sender : UIBarButtonItem){
        view.endEditing(true)
    }
}

//MARK: - WEB SERVICE CALLS
extension RegisterVC {
    func wsRegister() {
        Utility.showLoading()
        var dictParam:[String:Any];
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        if socialId.isEmpty {
            dictParam =   [ PARAMS.PASSWORD  : txtPassword.text! ,
                            PARAMS.LOGIN_BY   : CONSTANT.MANUAL ,
                            PARAMS.SOCIAL_UNIQUE_ID  : ""]
        } else {
            dictParam = [ PARAMS.PASSWORD : "",
                          PARAMS.SOCIAL_UNIQUE_ID : socialId,
                          PARAMS.LOGIN_BY : CONSTANT.SOCIAL]
        }
        dictParam[PARAMS.EMAIL] = txtEmail.text!
        dictParam[PARAMS.FIRST_NAME] = txtFirstName.text!
        dictParam[PARAMS.LAST_NAME] = txtLastName.text!
        dictParam[PARAMS.ADDRESS] = txtAddress.text!
        dictParam[PARAMS.PHONE] = txtPhoneNumber.text!
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = btnCountryCode.title(for: .normal) ?? ""
        dictParam[PARAMS.DEVICE_TOKEN] = preferenceHelper.getDeviceToken()
        dictParam[PARAMS.DEVICE_TYPE] = CONSTANT.IOS
        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.COUNTRY] = txtCountry.text!
        dictParam[PARAMS.CITY] = txtCity.text!
        dictParam[PARAMS.COUNTRY_ID] = strCountryId!
        dictParam[PARAMS.CITY_ID] = strCityId!
        dictParam[PARAMS.DEVICE_TIMEZONE] = TimeZone.current.identifier
        dictParam["gender_type"] = btnMale.isSelected ? 0 : 1
        if isPicAdded {
            let alamoFire:AlamofireHelper = AlamofireHelper();
            alamoFire.getResponseFromURL(url: WebService.REGISTER, paramData: dictParam, image: imgProfilePic.image!) {(response, data, error) -> (Void) in
                Utility.hideLoading()
                if Parser.parseProviderData(response: response, data: data) {
                    if !(ProviderSingleton.shared.provider.isReferral == TRUE) && ProviderSingleton.shared.provider.countryDetail.isReferral {
                        Utility.hideLoading()
                        self.performSegue(withIdentifier: SEGUE.REGISTER_TO_REFERRAL, sender: self)
                    } else if (ProviderSingleton.shared.provider.isDocumentUploaded == FALSE) {
                        APPDELEGATE.gotoDocument()
                    } else {
                        APPDELEGATE.gotoMap()
                    }
                }
                let authProvider = AuthProvider.Instance
                authProvider.wsGenerateFirebaseAcessToken()
            }
        } else {
            let alamoFire:AlamofireHelper = AlamofireHelper();
            alamoFire.getResponseFromURL(url: WebService.REGISTER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
                Utility.hideLoading()
                if Parser.parseProviderData(response: response, data: data) {
                    if !(ProviderSingleton.shared.provider.isReferral == TRUE) && ProviderSingleton.shared.provider.countryDetail.isReferral {
                        Utility.hideLoading()
                        self.performSegue(withIdentifier: SEGUE.REGISTER_TO_REFERRAL, sender: self)
                    } else if (ProviderSingleton.shared.provider.isDocumentUploaded == FALSE) {
                        APPDELEGATE.gotoDocument()
                    } else {
                        APPDELEGATE.gotoMap()
                    }
                }
                let authProvider = AuthProvider.Instance
                authProvider.wsGenerateFirebaseAcessToken()
            }
        }
    }
    
    func wsGetCountries() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_COUTRIES, methodName: AlamofireHelper.POST_METHOD, paramData: Dictionary.init()) { (response, data, error) -> (Void) in
            Parser.parseCountries(response,data: data, toArray: self.arrForCountryList, completion: { [unowned self] result in
                if result {
                    self.isCountryListGet = true
                    self.fillCountry()
                }
                Utility.hideLoading()
            })
        }
    }
    
    func fillCountry() {
        if isCountryListGet && isLocationGet {
            let country:Country = self.arrForCountryList[0] as! Country
            var isCountryMatch: Bool = false
            for country in self.arrForCountryList {
                if let country = country as? Country {
                    if country.countryname.compare(LocationCenter.default.country) == ComparisonResult.orderedSame {
                        self.strCountryId = country.id
                        self.txtCountry.text = country.countryname
                        self.btnCountryCode.setTitle(country.countryphonecode, for: .normal)
                        self.arrForCityList.removeAllObjects()
                        self.strCountryCode = country.alpha2
                        for city in country.cityList {
                            self.arrForCityList.add(city)
                        }
                        isCountryMatch = true
                        break;
                    }
                }
            }
            if !isCountryMatch {
                self.strCountryId = country.id
                self.txtCountry.text = country.countryname
                self.btnCountryCode.setTitle(country.countryphonecode, for: .normal)
                self.strCountryCode = country.alpha2
                self.arrForCityList.removeAllObjects()
                for city in country.cityList {
                    self.arrForCityList.add(city)
                }
            }
        }
    }
    
    func wsGetOtp(isEmailOtpOn: Bool,isSmsOtpOn: Bool) {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        let strForEmail = txtEmail.text?.trim() ?? ""
        let strPhoneNumber = txtPhoneNumber.text?.trim() ?? ""
        let strForCountryPhoneCode = self.btnCountryCode.title(for: .normal)
        
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.EMAIL] = strForEmail
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
                    if let otpvc:OtpVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC {
                        otpvc.isFromCheckUser = true
                        self.present(otpvc, animated: true, completion: {
                            otpvc.delegate = self
                            otpvc.strForCountryPhoneCode =  strForCountryPhoneCode ?? ""
                            otpvc.strForPhoneNumber = strPhoneNumber
                            otpvc.strForEmail = strForEmail
                            otpvc.isFromCheckUser = true
                            otpvc.updateOtpUI(otpEmail: emailOtp, otpSms: smsOtp, emailOtpOn: isEmailOtpOn , smsOtpOn: isSmsOtpOn)
                        })
                    }
                } else {
                    Utility.hideLoading()
                }
            }
        }
    }
}

extension RegisterVC:LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            debugPrint("FB login error \(error!)")
        } else {
            if let finalResult = result {
                if finalResult.isCancelled {
                    debugPrint("Login Cancelled")
                } else {
                    Utility.showLoading()
                    self.getFBUserData()
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //debugPrint("\(#function))")
    }
}

@available(iOS 13.0, *)
extension RegisterVC: ASAuthorizationControllerDelegate {
    
    @objc func handleAppleIdRequest() {
        isSignInWithApple = true
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User id = \(userIdentifier)\nFull Name = \(String(describing: fullName)) \nEmail id = \(String(describing: email))")
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("The Apple ID credential is valid.")
                    DispatchQueue.main.async {
                        self.txtFirstName.text = appleIDCredential.fullName?.givenName ?? ""
                        print(appleIDCredential.fullName?.givenName ?? "")
                        self.txtEmail.text = appleIDCredential.email ?? ""
                        self.socialId = appleIDCredential.user
                        
                        if !(appleIDCredential.email ?? "").isEmpty {
                            preferenceHelper.setSigninWithAppleEmail(appleIDCredential.email ?? "")
                        }
                        
                        if !(appleIDCredential.fullName?.givenName ?? "").isEmpty {
                            preferenceHelper.setSigninWithAppleUserName((appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? ""))
                        }
                        
                        DispatchQueue.main.async {
                            if preferenceHelper.getSigninWithAppleEmail().count > 0 {
                                self.txtEmail.text = preferenceHelper.getSigninWithAppleEmail()
                            }
                            
                            if preferenceHelper.getSigninWithAppleUserName().count > 0 {
                                if preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[0].count > 0 {
                                    self.txtFirstName.text = preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[0]
                                } else {
                                    self.txtFirstName.text = preferenceHelper.getSigninWithAppleUserName()
                                }
                                
                                if preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[1].count > 0 {
                                    self.txtLastName.text = preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[1]
                                }
                            }
                        }
                        
                        self.updateUiForSocialLogin(email: self.txtEmail.text!, socialId: self.socialId, firstName: self.txtFirstName.text!, lastName: appleIDCredential.fullName?.familyName ?? "", profileUri: "", isSigninWithapple: true)
                        
                        if appleIDCredential.email?.contains("privaterelay.appleid.com") ?? false {
                            _ = self.checkValidation()
                        } else {
                            print("self.txtFirstName.text!\(self.txtFirstName.text!)")
                            _ = self.checkValidation()
                        }
                    }
                    break
                case .revoked:
                    print("The Apple ID credential is revoked.")
                    break
                case .notFound:
                    print("No credential was found, so show the sign-in UI.")
                    break
                default:
                    break
                }
            }
        } else {
            if let passwordCredential = authorization.credential as? ASPasswordCredential {
                let _ = passwordCredential.user
                let _ = passwordCredential.password
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple signin error = \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
