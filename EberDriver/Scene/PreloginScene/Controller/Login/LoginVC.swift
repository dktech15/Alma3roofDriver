//
//  LoginVC.swift
//  Eber
//
//  Created by Elluminati on 17/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class LoginVC: BaseVC, UITextFieldDelegate {

    @IBOutlet weak var lblLoginWith: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var stkForSocialLogin: UIStackView!
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrLogin: UIScrollView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgetPasssword: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var hvwSocialLogin: NSLayoutConstraint!
    @IBOutlet weak var btnHideShowPassword: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var stkLoginForm: UIStackView!
    @IBOutlet weak var stkStackTag: UIStackView!
    
    @IBOutlet weak var lblPhoneCode: UILabel!
    @IBOutlet weak var viewPhoneCode: UIView!
    
    var isLocationGet: Bool = false
    var isCountryListGet: Bool = false

    var socialId:String = ""
    var arrLoginOptions = ["TXT_EMAIL".localized, "txt_phone".localized, "txt_login_with_otp".localized]
    var loginBy: LoginBY = .email

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
        
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
        
        self.addLoginOptions()
        
        let bundleID = Bundle.main.bundleIdentifier
        if bundleID == "com.elluminati.eber.driver" {
            addTapOnVersion()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance.signOut()
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
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
            self.socialId = user.userID ?? ""
            self.txtEmail.text = user.profile?.email ?? ""
            GIDSignIn.sharedInstance.signOut()
            self.wsLogin()
        }
    }
    //

    @IBAction func onClickBtnLogin(_ sender: Any?) {
        if(self.checkValidation()) {
            if loginBy == .LoginWithOtp {
                wsGetOtp()
            } else {
                wsLogin()
            }
        }
    }

    @IBAction func onClickBtnRegister(_ sender: Any) {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller.isKind(of: RegisterVC.self) {
                    navigationController.popToViewController(controller, animated: true)
                    return;
                }
            }
            self.navigationController?.pushViewController(AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "registerVC"), animated: true)
        }
    }

    @IBAction func onClickBtnForgetPassword(_ sender: Any) {
        openForgetPasswordDialog()
    }

    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func onClickBtnHideShowPassword(_ sender: Any) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        btnHideShowPassword.isSelected.toggle()
    }
    
    @IBAction func onClickCountryCode(_ sender: Any) {
        wsGetCountries(isOpenPopup: true)
    }

    //MARK: - USER DEFINE METHODS
    func checkValidation() -> Bool {
        let validEmail = txtEmail.text!.checkEmailValidation(isEmailVerficationNeedToCheck: false)
        let validPassword = txtPassword.text!.checkPasswordValidation()
        let validPhoneNumber = txtEmail.text!.isValidMobileNumber()

        if loginBy == .phone {
            if lblPhoneCode.text == "--" || lblPhoneCode.text!.isEmpty {
                Utility.showToast(message: "txt_select_country_phone_code".localized)
                return false
            } else if validPhoneNumber.0 == false {
                Utility.showToast(message: validPhoneNumber.1);
                return false
            } else if validPassword.0 == false {
                Utility.showToast(message: validPassword.1)
                txtPassword.becomeFirstResponder();
                return false
            } else {
                return true
            }
        } else if loginBy == .LoginWithOtp {
            if lblPhoneCode.text == "--" || lblPhoneCode.text!.isEmpty {
                Utility.showToast(message: "txt_select_country_phone_code".localized)
                return false
            } else if validPhoneNumber.0 == false {
                Utility.showToast(message: validPhoneNumber.1);
                return false
            } else {
                return true
            }
        } else {
            if validEmail.0 == false {
                Utility.showToast(message: validEmail.1)
                txtEmail.becomeFirstResponder()
                return false
            } else if validPassword.0 == false {
                Utility.showToast(message: validPassword.1)
                txtPassword.becomeFirstResponder();
                return false
            } else {
                return true
            }
        }
    }
    
    func addTapOnVersion() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap.numberOfTapsRequired = 3
        self.imgLogo.addGestureRecognizer(tap)
        self.imgLogo.isUserInteractionEnabled = true
    }
    
    func addLoginOptions() {
        let loginOption = LoginOptions()
        loginOption.translatesAutoresizingMaskIntoConstraints = false
        loginOption.delegate = self
        loginOption.dataSource = self
        stkStackTag.addArrangedSubview(loginOption)
        stkStackTag.isHidden = false
        if arrLoginOptions.count > 0 {
            let obj = arrLoginOptions[0]
            didSelectOption(at: loginOption.selectedIndex, text: obj, loginOption: loginOption)
        }
    }
    
    @objc func onClickVersionTap(_ sender: UITapGestureRecognizer) {
        let dialog = DialogForApplicationMode.showCustomAppModeDialog()
        
        dialog.onClickLeftButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
        
        dialog.onClickRightButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
    }

    func initialViewSetup() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
      
        lblTitle.text = "TXT_LOGIN".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        txtEmail.textColor = UIColor.themeTextColor;
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtEmail.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
        txtPassword.textColor = UIColor.themeTextColor;
        txtPassword.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtPassword.placeholder = "TXT_PASSWORD".localized
        
        lblOr.textColor = UIColor.themeLightTextColor
        lblOr.text = " --- " + "TXT_OR".localized + " --- "
        lblOr.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        
        lblLoginWith.textColor = UIColor.themeLightTextColor
        lblLoginWith.text = "TXT_LOGIN_WITH".localized
        lblLoginWith.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        
        lblDontHaveAccount.textColor = UIColor.themeLightTextColor
        lblDontHaveAccount.text = "TXT_DON'T_HAVE_ACCOUNT".localized
        lblDontHaveAccount.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        
        btnRegister.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnRegister.setTitle("TXT_REGISTER".localizedCapitalized, for: UIControl.State.normal)
        
        btnRegister.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        btnForgetPasssword.setTitleColor(UIColor.themeButtonBackgroundColor, for: UIControl.State.normal)
        btnForgetPasssword.setTitle("TXT_FORGOT_PASSWORD".localizedCapitalized, for: UIControl.State.normal)
        btnForgetPasssword.titleLabel?.font = FontHelper.font(size: FontSize.small, type: .Regular)
        
        btnLogin.setTitle( "TXT_LOGIN".localized, for: UIControl.State.normal)
        btnLogin.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnLogin.backgroundColor = UIColor.themeButtonBackgroundColor
        btnLogin.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor

//        btnHideShowPassword.setTitle(FontAsset.icon_hide_password, for: .normal)
//        btnHideShowPassword.setTitle(FontAsset.icon_show_password, for: .selected)
//        btnHideShowPassword.setSimpleIconButton()
//        btnHideShowPassword.titleLabel?.font = FontHelper.assetFont(size: 25)
        btnHideShowPassword.setImage(UIImage(named: "asset-password-hide"), for: .normal)
        btnHideShowPassword.setImage(UIImage(named: "asset-password-show"), for: .selected)
    }

    func setupLayout() {
        btnLogin.setRound(withBorderColor: UIColor.clear, andCornerRadious:btnLogin.frame.height/2, borderWidth: 1.0)
        navigationView.navigationShadow()
    }
    
    func fillCountry(arr: [Country]) {
        if isCountryListGet && isLocationGet {
            let country:Country = arr[0]
            var isCountryMatch: Bool = false
            for country in arr {
                if country.countryname.compare(LocationCenter.default.country) == ComparisonResult.orderedSame {
                    self.lblPhoneCode.text = country.countryphonecode
                    isCountryMatch = true
                    break;
                }
            }
            if !isCountryMatch {
                self.lblPhoneCode.text = country.countryphonecode
            }
        }
    }
    
    //MARK: - OBJC METHODS
    override func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        guard let userInfo = ntf.userInfo else { return }
        guard let location = userInfo["location"] as? CLLocation else { return }
        LocationCenter.default.fetchCityAndCountry(location: location) { [weak self] (city, country, error) in
            self?.isLocationGet = true
            LocationCenter.default.stopUpdatingLocation()
            self?.wsGetCountries()
        }
    }
    
    override func locationFail(_ ntf: Notification = Common.defaultNtf) {
        print("Location:- \(ntf.description)")
        self.isLocationGet = true
        self.wsGetCountries()
    }
}

//MARK: - Dialgos
extension LoginVC {
    func openForgetPasswordDialog() {
        self.view.endEditing(true)
        let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: "".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SEND".localized, editTextHint: "TXT_EMAIL".localized)
        dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
            dialogForForgetPassword.removeFromSuperview();
        }
        dialogForForgetPassword.onClickRightButton = { [unowned self, unowned dialogForForgetPassword] (text1:String) in
            let validEmail = text1.checkEmailValidation(isEmailVerficationNeedToCheck: false)
            if validEmail.0 == false {
                Utility.showToast(message: validEmail.1)
            } else {
                self.wsForgetPassword(email: text1)
                dialogForForgetPassword.removeFromSuperview();
            }
        }
    }

    func openLanguageDialog() {
        let dialogForLanguage:CustomLanguageDialog = CustomLanguageDialog.showCustomLanguageDialog()
        dialogForLanguage.onItemSelected = { [unowned self, unowned dialogForLanguage] (selectedItem:Int) in
            self.changed(selectedItem)
            dialogForLanguage.removeFromSuperview()
        }
    }

    func getFBUserData() {
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start { (connection, result, error) in
                Utility.hideLoading()
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    let email:String = (dict["email"] as? String) ?? ""
                    Profile.loadCurrentProfile(completion: { (profile, error) in
                        if (error == nil) {
                            self.socialId = (profile?.userID)!
                            self.txtEmail.text = email
                            LoginManager.init().logOut()
                            self.wsLogin()
                        } else {
                            Utility.showToast(message: (error?.localizedDescription)!)
                        }
                    })
                }
            }
        }
    }
    
    func openCountryList(arr: [Country]) {
        let array = NSMutableArray(array: arr)
        let dialogForCountry = CustomCountryDialog.showCustomCountryDialog(withDataSource:array)
        dialogForCountry.onCountrySelected = { [weak self] (country:Country) in
            guard let self = self else { return }
            self.lblPhoneCode.text = country.countryphonecode
            self.txtEmail.text = ""
            dialogForCountry.removeFromSuperview()
        }
    }

    //MARK: - GOOGLE SIGN METHOD
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtEmail {
            txtPassword.becomeFirstResponder();
        } else if textField == txtPassword {
            txtPassword.resignFirstResponder();
            onClickBtnLogin(nil)
        } else {
            self.view.endEditing(true)
            return true
        }
        return true
    }
}

//MARK: - WEB SERVICE CALLS
extension LoginVC {
    func wsLogin(otp:String? = nil) {
        Utility.showLoading()
        var dictParam:[String:Any];
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        if socialId.isEmpty {
            dictParam =   [PARAMS.EMAIL : txtEmail.text!  ,
                           PARAMS.PASSWORD : txtPassword.text! ,
                           PARAMS.LOGIN_BY : CONSTANT.MANUAL ,
                           PARAMS.DEVICE_TYPE : CONSTANT.IOS,
                           PARAMS.DEVICE_TOKEN : preferenceHelper.getDeviceToken(),
                           PARAMS.SOCIAL_UNIQUE_ID : "",
                           PARAMS.APP_VERSION : currentAppVersion]
            
            if loginBy == .phone {
                dictParam.removeValue(forKey: PARAMS.EMAIL)
                dictParam[PARAMS.PHONE] = txtEmail.text!
                dictParam[PARAMS.COUNTRY_PHONE_CODE] = lblPhoneCode.text!
            } else if loginBy == .LoginWithOtp || otp != nil {
                dictParam.removeValue(forKey: PARAMS.EMAIL)
                dictParam[PARAMS.PHONE] = txtEmail.text!
                dictParam[PARAMS.COUNTRY_PHONE_CODE] = lblPhoneCode.text!
                dictParam[PARAMS.otp_sms] = otp ?? ""
            }
        } else {
            dictParam =   [PARAMS.EMAIL : txtEmail.text!,
                           PARAMS.PASSWORD : "",
                           PARAMS.SOCIAL_UNIQUE_ID : socialId,
                           PARAMS.LOGIN_BY : CONSTANT.SOCIAL ,
                           PARAMS.DEVICE_TYPE : CONSTANT.IOS,
                           PARAMS.DEVICE_TOKEN :preferenceHelper.getDeviceToken(),
                           PARAMS.APP_VERSION : currentAppVersion]
        }

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.LOGIN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            Utility.hideLoading()
            if Parser.parseProviderData(response: response, data: data) {
                
                if !(ProviderSingleton.shared.provider.isReferral == TRUE) && ProviderSingleton.shared.provider.countryDetail.isReferral {
                    Utility.hideLoading()
                    self.performSegue(withIdentifier: SEGUE.LOGIN_TO_REFERRAL, sender: self)
                } else if (ProviderSingleton.shared.provider.isDocumentUploaded == FALSE) {
                    APPDELEGATE.gotoDocument()
                } else {
                    if ProviderSingleton.shared.tripId.isEmpty() {
                        APPDELEGATE.gotoMap()
                    } else {
                        if ProviderSingleton.shared.isProviderStatus == TripStatus.Completed.rawValue {
                            APPDELEGATE.gotoInvoice()
                        } else {
                            APPDELEGATE.gotoTrip()
                        }
                    }
                }
                let authProvider = AuthProvider.Instance
                authProvider.wsGenerateFirebaseAcessToken()
                
            }
        }
    }

    func wsForgetPassword(email:String) {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.EMAIL : email,
             PARAMS.TYPE  : CONSTANT.TYPE_PROVIDER,
             ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.FORGOT_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            if  Parser.isSuccess(response: response,data: data, withSuccessToast: true, andErrorToast: true) {}
        }
    }
    
    func wsGetCountries(isOpenPopup: Bool = false) {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_COUTRIES, methodName: AlamofireHelper.POST_METHOD, paramData: Dictionary.init()) { (response, data, error) -> (Void) in
            let arrForCountryList = NSMutableArray()
            Parser.parseCountries(response,data: data, toArray: arrForCountryList, completion: { [weak self] result in
                guard let self = self else { return }
                if result {
                    self.isCountryListGet = true
                    if let arr = arrForCountryList as? [Country] {
                        self.fillCountry(arr: arr)
                    }
                }
                if isOpenPopup {
                    self.openCountryList(arr: arrForCountryList as? [Country] ?? [])
                }
                Utility.hideLoading()
            })
        }
    }
    
    func wsGetOtp() {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        let strPhoneNumber = txtEmail.text?.trim() ?? ""
        let strForCountryPhoneCode = lblPhoneCode.text!
        
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.EMAIL] = ""
        dictParam[PARAMS.PHONE] = strPhoneNumber
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = strForCountryPhoneCode
        dictParam[PARAMS.TYPE] = 2
        
        afh.getResponseFromURL(url: WebService.GET_PROVIDERS_LOGIN_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            print(Utility.convertDictToJson(dict: response))
            if (error != nil) {
                Utility.hideLoading()
            } else {
                Utility.hideLoading()
                if Parser.isSuccess(response: response,data: data) {
                    let smsOtp:String = (response[PARAMS.SMS_OTP] as? String) ?? ""
                    let emailOtp:String = (response[PARAMS.EMAIL_OTP] as? String) ?? ""
                    if let otpvc:OtpVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC {
                        otpvc.delegate = self
                        otpvc.isFromLoginWithOTP = true
                        self.present(otpvc, animated: true, completion: {
                            otpvc.strForCountryPhoneCode =  strForCountryPhoneCode
                            otpvc.strForPhoneNumber = strPhoneNumber
                            otpvc.updateOtpUI(otpEmail: emailOtp, otpSms: smsOtp, emailOtpOn: false , smsOtpOn: true)
                        })
                    }
                } else {
                    Utility.hideLoading()
                }
            }
        }
    }
}

extension LoginVC: LoginButtonDelegate {
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
        print("Did logout via LoginButton")
    }
}

//MARK: - Signin With Apple
@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
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
                            self.txtEmail.text = appleIDCredential.email ?? ""
                            self.socialId = appleIDCredential.user
                            self.wsLogin()
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
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple signin error = \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginVC: LoginOptionsDatasource, LoginOptionsDelegate {
    func didSelectOption(at index: Int, text: String, loginOption: LoginOptions) {
        switch text {
        case "TXT_EMAIL".localized :
            print("Email")
            txtEmail.placeholder = "TXT_EMAIL".localized
            vwPassword.isHidden = false
            viewPhoneCode.isHidden = true
            if loginBy != .email {
                txtEmail.text = ""
            }
            loginBy = .email
        case "txt_phone".localized :
            print("Phone")
            txtEmail.placeholder = "txt_phone".localized
            vwPassword.isHidden = false
            viewPhoneCode.isHidden = false
            if loginBy == .email {
                txtEmail.text = ""
            }
            loginBy = .phone
        case "txt_login_with_otp".localized :
            print("login with otp")
            txtEmail.placeholder = "txt_phone".localized
            vwPassword.isHidden = true
            viewPhoneCode.isHidden = false
            if loginBy == .email {
                txtEmail.text = ""
            }
            txtPassword.text = ""
            loginBy = .LoginWithOtp
        default:
            print("default \(text)")
        }
    }
    
    func setOptions(in view: LoginOptions) -> [String] {
            if !preferenceHelper.getIsLoginWithOTP(){
                arrLoginOptions.removeLast()
            }
            return arrLoginOptions
        }
}

extension LoginVC: OtpDelegate {
    
    func onOtpDone() {
        //
    }
    
    func onOtpDone(otp: String) {
        txtPassword.text = ""
        wsLogin(otp: otp)
    }
}
