//
//  SettingVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {
    /*View For Language Navigation*/
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLanguage: UIButton!
    
    /*View For Language Notification*/
    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var viewForLanguage: UIView!
    
    /*View For Select Language*/
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var lblAppVersion: UILabel!
    
    @IBOutlet weak var lblAppVersionValue: UILabel!
    
    //MARK: View life cycle
    @IBOutlet weak var viewForRequestAlertNotifiation: UIView!
    @IBOutlet weak var lblRequestAlert: UILabel!
    @IBOutlet weak var lblRequestAlertMessage: UILabel!
    @IBOutlet weak var swRequestAlertNotificationSound: UISwitch!
    
    @IBOutlet weak var viewForPickupNotifiationSound: UIView!
    @IBOutlet weak var lblPickupNotificationSound: UILabel!
    @IBOutlet weak var lblPickupNotificationSoundMessage: UILabel!
    @IBOutlet weak var swPickupNotificationSound: UISwitch!
    
    @IBOutlet weak var viewForHeatMap: UIView!
    @IBOutlet weak var lblHeatMap: UILabel!
    @IBOutlet weak var lblHeatMapMessage: UILabel!
    @IBOutlet weak var swHeatMap: UISwitch!
    
    @IBOutlet weak var viewForAppLock: UIView!
    @IBOutlet weak var lblAppLock: UILabel!
    @IBOutlet weak var lblAppLockMessage: UILabel!
    @IBOutlet weak var swAppLock: UISwitch!
    
    @IBOutlet weak var viewForPushNotifiationSound: UIView!
    @IBOutlet weak var lblStopPushNotificationSound: UILabel!
    @IBOutlet weak var lblStopPushNotificationSoundMessage: UILabel!
    @IBOutlet weak var swPushNotificationSound: UISwitch!
    @IBOutlet weak var tblProviderLanguage: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgSave: UIImageView!
    
    @IBOutlet weak var lblGoingHome: UILabel!
    @IBOutlet weak var lblGoingHomeDesc: UILabel!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var viewGoingAddress: UIView!
    
    var arrLocation:[Double] = [0.0,0.0]
    var isAddressChangeAllowed = false
    var isGoingHomeAllowed = false
    var arrForProviderLanguage:[Language] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()
        self.wsGetLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swRequestAlertNotificationSound.isOn = preferenceHelper.getIsRequsetAlertSoundOn()
        swPickupNotificationSound.isOn = preferenceHelper.getIsPickupAlertSoundOn()
        swHeatMap.isOn = preferenceHelper.getIsHeatMapOn()
        swAppLock.isOn = preferenceHelper.getBiomatricVerification()
        self.isGoingHomeAllowed = preferenceHelper.getGoingHomeOn()
        self.isAddressChangeAllowed = preferenceHelper.getGoingHomeAddressOn()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
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
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
        preferenceHelper.setIsRequsetAlertSoundOn(swRequestAlertNotificationSound.isOn)
    }
    @IBAction func onPickupSwitchChange(_ sender: Any) {
        preferenceHelper.setIsPickupAlertSoundOn(swPickupNotificationSound.isOn)
    }
    
    @IBAction func onHeatmapSwitchChange(_ sender: Any) {
        preferenceHelper.setIsHeatMapOn(swHeatMap.isOn)
    }
    
    @IBAction func onAppLockSwitchChange(_ sender: Any) {
        BiometricAuthentication()
    }
    
    @IBAction func onGoingHomeSwitchChanged(_ sender: UISwitch) {
        //preferenceHelper.setGoingHomeOn(self.switchGoingHome.isOn)
    }
    
    @IBAction func onClickBtnSave(_ sender: Any) {
        wsupdateSetting()
    }
    
    func setLocalization() {
        viewForLanguage.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblTitle.text = "TXT_SETTINGS".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        lblLanguageTitle.textColor = UIColor.themeTextColor
        lblLanguageTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblLanguageMessage.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblLanguageMessage.text = "MSG_LANGUAGE".localized
        
        lblSelectLanguage.textColor = UIColor.themeTextColor
        lblSelectLanguage.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblSelectLanguage.text = "TXT_SELECT_LANGUAGE_YOU_CAN_SPEAK".localized
        
        lblHeatMap.textColor = UIColor.themeTextColor
        lblHeatMap.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblHeatMap.text = "TXT_HEAT_MAP".localized
        
        lblHeatMapMessage.textColor = UIColor.themeTextColor
        lblHeatMapMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblHeatMapMessage.text = "TXT_HEAT_MAP_MSG".localized
        
        lblAppLock.textColor = UIColor.themeTextColor
        lblAppLock.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblAppLock.text = "Biometric Lock"
        
        lblAppLockMessage.textColor = UIColor.themeTextColor
        lblAppLockMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblAppLockMessage.text = "Enable biometric authentication for added security."
        
        lblRequestAlert.textColor = UIColor.themeTextColor
        lblRequestAlert.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblRequestAlert.text = "TXT_REQUEST_ALERT".localized
        
        lblRequestAlertMessage.textColor = UIColor.themeTextColor
        lblRequestAlertMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblRequestAlertMessage.text = "TXT_REQUEST_ALERT_MSG".localized
        
        lblPickupNotificationSound.textColor = UIColor.themeTextColor
        lblPickupNotificationSound.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblPickupNotificationSound.text = "TXT_PICKUP_ALERT".localized
        
        lblPickupNotificationSoundMessage.textColor = UIColor.themeTextColor
        lblPickupNotificationSoundMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblPickupNotificationSoundMessage.text = "TXT_PICKUP_ALERT_MSG".localized
        
        lblStopPushNotificationSound.textColor = UIColor.themeTextColor
        lblStopPushNotificationSound.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblStopPushNotificationSound.text = "TXT_PUSH_NOTIFICATION".localized
        
        lblStopPushNotificationSoundMessage.textColor = UIColor.themeTextColor
        lblStopPushNotificationSoundMessage.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        lblStopPushNotificationSoundMessage.text = "TXT_PUSH_NOTIFICATION_MSG".localized
        
        lblGoingHome.textColor = UIColor.themeTextColor
        lblGoingHome.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblGoingHome.text = "TXT_GOING_HOME".localized
        
        lblGoingHomeDesc.textColor = UIColor.themeOverlayColor
        lblGoingHomeDesc.font = FontHelper.font(size: FontSize.extraSmall, type: FontType.Regular)
        lblGoingHomeDesc.text = preferenceHelper.getGoingHomeAddressOn() ? "txt_set_home_address".localized : "TXT_GOING_HOME_MSG".localized
        
        /*btnSave.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
         btnSave.setTitleColor(UIColor.themeTextColor  , for: .normal)*/
        
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        lblAppVersion.textColor = UIColor.themeTextColor
        lblAppVersion.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblAppVersion.text = "TXT_APP_VERSION".localized
        
        lblAppVersionValue.textColor = UIColor.themeTextColor
        lblAppVersionValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblAppVersionValue.text = currentAppVersion
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
//        btnSave.setTitle(FontAsset.icon_checked, for: .normal)
//        btnSave.setUpTopBarButton()
        imgSave.tintColor = UIColor.themeImageColor
        viewGoingAddress.isHidden = !preferenceHelper.getGoingHomeAddressOn()
        viewForAppLock.isHidden = !preferenceHelper.getAllowBiomatricVerification()
        
        let p = ProviderSingleton.shared.provider
        self.txtAddress.text = p.address
                        
        let bundleID = Bundle.main.bundleIdentifier
        if bundleID == "com.elluminati.eber.driver" {
            addTapOnVersion()
        }
    }
    
    //MARK: Button action methods
    @IBAction func openLangueDialog(_ sender: Any) {
        self.openLanguageDialog()
    }
    
    func openLanguageDialog() {
        let dialogForLanguage:CustomLanguageDialog = CustomLanguageDialog.showCustomLanguageDialog()
        dialogForLanguage.onItemSelected = { [unowned self, unowned dialogForLanguage]
            (selectedItem:Int) in
            self.changed(selectedItem)
            dialogForLanguage.removeFromSuperview()
        }
    }
    
    func addTapOnVersion() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap.numberOfTapsRequired = 3
        self.lblAppVersion.addGestureRecognizer(tap)
        self.lblAppVersion.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap2.numberOfTapsRequired = 3
        self.lblAppVersionValue.addGestureRecognizer(tap2)
        self.lblAppVersionValue.isUserInteractionEnabled = true
    }
    
    func BiometricAuthentication() {
        AppLockManager.shared.BiometricAuth { result in
                switch result {
                    case .success:
                        // Authentication successful
                    preferenceHelper.setBiomatricVerification(self.swAppLock.isOn)

                    case .failure:
                        // Authentication failed or was canceled
                        self.notIdentify()
                }
        }
    }
    
    func notIdentify(){
        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "try again!", style: .default) { [weak self] (_) in self?.BiometricAuthentication() }
        ac.addAction(okAction)
        self.present(ac, animated: true)
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
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
            navigationVC.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func onAddLocationClicked(_ sender: UIButton) {
        if !self.isAddressChangeAllowed {
            return
        }
        let locationVC : LocationVC = storyboard?.instantiateViewController(withIdentifier: "locationVC") as! LocationVC
        locationVC.delegate = self
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
}

extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForProviderLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProviderLanguageCell
        cell.setCellData(data: arrForProviderLanguage[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrForProviderLanguage[indexPath.row].isSelected = !arrForProviderLanguage[indexPath.row].isSelected
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

extension SettingVC {
    func wsGetLanguage() {
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_LANGUAGE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data,error) -> (Void) in
            
            if (error != nil) {
            }else {
                if Parser.isSuccess(response: response,data: data,withSuccessToast: false,andErrorToast: false) {
                    self.arrForProviderLanguage.removeAll()
                    
                    let jsonDecoder = JSONDecoder()
                    do {
                        let languageResponse:LanguageResponse = try jsonDecoder.decode(LanguageResponse.self, from: data!)
                        let languages = languageResponse.languages
                        for language in languages {
                            var newLanguage:Language = language
                            newLanguage.isSelected =  ProviderSingleton.shared.provider.languages.contains(language.id)
                            self.arrForProviderLanguage.append(newLanguage)
                        }
                    }catch {
                        
                    }
                }else{}
                //self.tblProviderLanguage.reloadData()
                //self.tableViewHeight.constant = self.tblProviderLanguage.contentSize.height + 10
                
                self.tblProviderLanguage.reloadData(hToFit: self.tableViewHeight) { [weak self] in 
                    guard let self = self else { return }
                    self.tableViewHeight.constant += 10.0
                }
            }
        }
    }
    
    func wsupdateSettingForLocation() {
        if self.arrLocation[0] == 0.0 {
            return
        }
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        var newArray:[String] = []
        for language in arrForProviderLanguage {
            if language.isSelected {
                newArray.append(language.id)
            }
        }
//        dictParam[PARAMS.PROVIDER_LANGUAGES] = newArray
        dictParam[PARAMS.ADDRESS] = self.txtAddress.text
        dictParam[PARAMS.ADDRESS_LOCATION] = self.arrLocation
        
        Utility.showLoading()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        afh.getResponseFromURL(url: WebService.UPDATE_PROVIDER_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                
            } else {
                
            }
        }
    }
    
    func wsupdateSetting() {
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        var newArray:[String] = []
        for language in arrForProviderLanguage {
            if language.isSelected {
                newArray.append(language.id)
            }
        }
        dictParam[PARAMS.PROVIDER_LANGUAGES] = newArray
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        afh.getResponseFromURL(url: WebService.UPDATE_PROVIDER_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                ProviderSingleton.shared.provider.languages = newArray
                self.navigationController?.popViewController(animated: true)
            } else {
                
            }
        }
    }
}

class ProviderLanguageCell: TblVwCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        languageName.setSimpleIconButton()
        languageName.titleLabel?.font = FontHelper.assetFont(size: 25)
        // Initialization code
    }
    
    @IBOutlet weak var languageName:UIButton!
    @IBOutlet weak var lblLanguageName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCellData(data:Language) {
//        languageName.setTitle(FontAsset.icon_check_box_normal, for: .normal)
//        languageName.setTitle(FontAsset.icon_check_box_selected, for: .selected)
        languageName.setImage(UIImage(named: "asset-checkbox-normal"), for: .normal)
        languageName.setImage(UIImage(named: "asset-checkbox-selected"), for: .selected)
        languageName.isSelected = data.isSelected
        lblLanguageName.text = " " + data.name
    }
}

extension SettingVC: LocationHandlerDelegate
{
    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        self.txtAddress.text = address
        self.arrLocation = [latitude, longitude]
        self.wsupdateSettingForLocation()
    }
}
