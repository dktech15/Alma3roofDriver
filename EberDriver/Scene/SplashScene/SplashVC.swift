//
//  SplashVC.swift
//  Store
//
//  Created by Elluminati on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import LocalAuthentication
import AVFoundation

class SplashVC: BaseVC {

    @IBOutlet weak var splash: UIImageView!
    var player: AVPlayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ws_get_all_country_details()
//        wsGetAppSetting()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        if let videoURL = Bundle.main.url(forResource: "Comp 1", withExtension: "mp4") {
                   let asset = AVAsset(url: videoURL)
                   player = AVPlayer(playerItem: AVPlayerItem(asset: asset))

                   // Add an observer for the AVPlayerItemDidPlayToEndTime notification
                   NotificationCenter.default.addObserver(self,
                                                          selector: #selector(videoDidFinish),
                                                          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                          object: player?.currentItem)

                   // Set up AVPlayerLayer to display video
                   let playerLayer = AVPlayerLayer(player: player)
                   playerLayer.frame = view.bounds
                   view.layer.addSublayer(playerLayer)

                   // Start playing the video
                  
               }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appWillEnterForground), name: .applicationWillEnterForeground, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        APPDELEGATE.setupIQKeyboard()
        APPDELEGATE.setupTabbar()
        UISwitch.appearance().tintColor = UIColor.themeSwitchTintColor
        UISwitch.appearance().onTintColor = UIColor.themeSwitchTintColor
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            GMSServices.provideAPIKey(Google.MAP_KEY)
            if preferenceHelper.getGooglePlacesAutocompleteKey().isEmpty {
                DispatchQueue.main.async
                {
                    GMSPlacesClient.provideAPIKey(Google.MAP_KEY)
                }
            } else {
                DispatchQueue.main.async {
                    GMSPlacesClient.provideAPIKey(preferenceHelper.getGooglePlacesAutocompleteKey())
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func appWillEnterForground() {
//        wsGetAppSetting()
        ws_get_all_country_details()
    }
    
    @objc func videoDidFinish(notification: Notification) {
        self.checkLogin()
    }



    deinit {
        // Remove the observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
  
    func checkLogin() {
        if preferenceHelper.getSessionToken().isEmpty() {
            APPDELEGATE.gotoLogin()
        }else{
            if preferenceHelper.getAllowBiomatricVerification() && preferenceHelper.getBiomatricVerification()
            {
                    self.BiometricAuthentication()
            }
            else
            {loginSuccessed()}
        }
//        } else {
//            if !(ProviderSingleton.shared.provider.isReferral == TRUE) && ProviderSingleton.shared.provider.countryDetail.isReferral {
//                if let referralVC: ReferralVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "ReferralVC") as? ReferralVC {
//                    self.present(referralVC, animated: true, completion: {
//                    });
//                }
//            } else if (ProviderSingleton.shared.provider.isDocumentUploaded == FALSE) {
//                APPDELEGATE.gotoDocument()
//            } else {
//                if ProviderSingleton.shared.tripId.isEmpty() {
//                    APPDELEGATE.gotoMap()
//                } else {
//                    if ProviderSingleton.shared.isProviderStatus == TripStatus.Completed.rawValue {
//                        APPDELEGATE.gotoInvoice()
//                    } else {
//                        //APPDELEGATE.gotoTrip()
//                        APPDELEGATE.gotoMap()
//                    }
//                }
//            }
//        }
    }
    
    func BiometricAuthentication(){
        AppLockManager.shared.BiometricAuth { result in
                switch result {
                    case .success:
                        // Authentication successful
                        self.loginSuccessed()

                    case .failure:
                        // Authentication failed or was canceled
                        self.notIdentify()
                }
        }
    }
    
    func loginSuccessed(){
        if !(ProviderSingleton.shared.provider.isReferral == TRUE) && ProviderSingleton.shared.provider.countryDetail.isReferral {
            if let referralVC: ReferralVC =  AppStoryboard.PreLogin.instance.instantiateViewController(withIdentifier: "ReferralVC") as? ReferralVC {
                self.present(referralVC, animated: true, completion: {
                });
            }
        } else if (ProviderSingleton.shared.provider.isDocumentUploaded == FALSE) {
            APPDELEGATE.gotoDocument()
        } else {
            if ProviderSingleton.shared.tripId.isEmpty() {
                APPDELEGATE.gotoMap()
            } else {
                if ProviderSingleton.shared.isProviderStatus == TripStatus.Completed.rawValue {
                    APPDELEGATE.gotoInvoice()
                } else {
                    //APPDELEGATE.gotoTrip()
                    APPDELEGATE.gotoMap()
                }
            }
        }
    }
    func notIdentify(){
        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "try again!", style: .default) { [weak self] (_) in self?.BiometricAuthentication() }
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
    
    func generateThumbnail(for videoURL: URL) {
           let asset = AVAsset(url: videoURL)
           let imageGenerator = AVAssetImageGenerator(asset: asset)

           do {
               let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
               let thumbnail = UIImage(cgImage: cgImage)
               splash.image = thumbnail
           } catch let error {
               print("Error generating thumbnail: \(error.localizedDescription)")
           }
       }
}

//MARK: - Web Service Calls
extension SplashVC {
    
    func ws_get_all_country_details() {
        let afh:AlamofireHelper = AlamofireHelper()

        afh.getResponseFromURL(url: WebService.get_all_country_details, methodName: AlamofireHelper.GET_METHOD, paramData: nil) { (response, data, error) -> (Void) in
            if (error != nil) {
                self.wsGetAppSetting()
            }
            else {
                var arrList: [CountryList] = []
                
                    if let countryListArray = response["country_list"] as? [[String:Any]]{
                        for dic in countryListArray
                        {
                            let value = CountryList(dictionary: dic)!
                            arrList.append(value)
                        }
                        ProviderSingleton.shared.arrForCountries = arrList

                    }
                self.wsGetAppSetting()
            }
        }
    }
    
    
    func  wsGetAppSetting() {
        let afh:AlamofireHelper = AlamofireHelper.init()
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.DEVICE_TYPE : CONSTANT.IOS,
              PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
              PARAMS.APP_VERSION: currentAppVersion,
              PARAMS.TYPE: CONSTANT.TYPE_PROVIDER]

        afh.getResponseFromURL(url: WebService.GET_SETTING_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            if (error != nil) {
                self.openServerErrorDialog()
            } else {
                if Parser.parseAppSettingDetail(response: response, data: data) {
                    if Utility.isUpdateAvailable(Utility.getLatestVersion()) {
                        self.openUpdateAppDialog(isForceUpdate: preferenceHelper.getIsRequiredForceUpdate())
                    } else {
                        self.player?.play()
                    }
                }
            }
        }
    }
}

//MARK: - Dialogs
extension SplashVC {
    func openUpdateAppDialog(isForceUpdate: Bool) {
        if isForceUpdate {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_UPDATE".localized)
            dialogForUpdateApp.onClickLeftButton = { [unowned dialogForUpdateApp] in
                dialogForUpdateApp.removeFromSuperview();
                exit(0)
            }
            dialogForUpdateApp.onClickRightButton = { [unowned dialogForUpdateApp] in
                if let url = URL(string: CONSTANT.UPDATE_URL), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                dialogForUpdateApp.removeFromSuperview()
            }
        } else {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_UPDATE".localized)
            dialogForUpdateApp.onClickLeftButton = { [unowned self, unowned dialogForUpdateApp] in
                dialogForUpdateApp.removeFromSuperview();
                self.checkLogin()
            }
            dialogForUpdateApp.onClickRightButton = { [/*unowned self,*/ unowned dialogForUpdateApp] in
                if let url = URL(string: CONSTANT.UPDATE_URL), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                dialogForUpdateApp.removeFromSuperview()
            }
        }
    }

    func openServerErrorDialog() {
        let dialogForServerError = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_SERVER_ERROR".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_RETRY".localized)
        dialogForServerError.onClickLeftButton = { [unowned dialogForServerError] in
            dialogForServerError.removeFromSuperview();
            exit(0)
        }
        dialogForServerError.onClickRightButton = { [unowned self, unowned dialogForServerError] in
            dialogForServerError.removeFromSuperview();
            self.wsGetAppSetting()
//            self.ws_get_all_country_details()
        }
    }

    func openPushNotificationDialog() {
        let dialogForPushNotification = CustomAlertDialog.showCustomAlertDialog(title: "TXT_PUSH_ENABLE".localized, message: "MSG_PUSH_ENABLE".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "".localized)
        dialogForPushNotification.onClickLeftButton = { [unowned dialogForPushNotification] in
            dialogForPushNotification.removeFromSuperview();
            exit(0)
        }
        dialogForPushNotification.onClickRightButton = { [unowned dialogForPushNotification] in
            dialogForPushNotification.removeFromSuperview();
        }
    }
}
