//
//  PushNotificationManager.swift
//  FirebaseStarterKit
//
//  Created by Florian Marcu on 1/28/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications

fileprivate struct PUSH {
    static let Approved = "207"
    static let Declined = "208"
    static let ProviderNewTrip = "201"
    static let UserCancelTrip = "205"
    static let UserSetDestinaiton = "210"
    static let UserChangePaymentModeCash = "211"
    static let UserChangePaymentModeCard = "212"
    static let UserChangePaymentModeApplePay = "213"
    static let LoginAtAnother = "230"
    static let WaitingForTip = "241"
    static let TripAlreadyAccepted = "232"
    static let ProviderIsOffline = "242"
    static let AdminCancelled = "218"
    static let ProviderSecondNewTrip = "235"
    static let ReceviedMessage = "244"
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(grant, error)  in
                DispatchQueue.main.async {
                    if error == nil {
                        if grant {
                            UIApplication.shared.registerForRemoteNotifications()
                        } else {
                            //User didn't grant permission
                        }
                    }
                }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
             UIApplication.shared.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
    }

    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token)")
            preferenceHelper.setDeviceToken(token)
            self.wsUpdateDeviceToken()
             /*let usersRef = Firestore.firestore().collection("users_table").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)*/
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo:[AnyHashable:Any] =  response.notification.request.content.userInfo
        print("FCM remoteMessage \(userInfo)")
        if preferenceHelper.getAllowBiomatricVerification() && preferenceHelper.getBiomatricVerification()
        {
                self.BiometricAuthentication()
        }
    }

    /*func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("FCM remoteMessage \(remoteMessage.appData)") // or do whatever
        self.manageAllPush(data: remoteMessage.appData, isClick: false
    }*/

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("FCM Error\(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString \(deviceTokenString)")
        //preferenceHelper.setDeviceToken(deviceTokenString)
        //self.wsUpdateDeviceToken()
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /*let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        print("FCM remoteMessage Will Present \(userInfo)")
        self.manageAllPush(data: userInfo, isClick: false)
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])*/
                          
        let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        print("FCM remoteMessage Will Present userInfo \(userInfo)")
        let aps:[AnyHashable:Any] =  userInfo["aps"] as! [AnyHashable : Any]
        let alert:[AnyHashable:Any] = aps["alert"] as! [AnyHashable : Any]
        self.manageAllPush(data: userInfo, isClick: false)
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    func showUpdate() {
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
    }

    func manageAllPush(data:[AnyHashable: Any],isClick: Bool = true) {
        Utility.wsGetAppSetting {
            if preferenceHelper.getIsRequiredForceUpdate() {
                if Utility.isUpdateAvailable(Utility.getLatestVersion()) {
                    self.showUpdate()
                    return
                }
            }
        }
        if let id = (data["id"] as? String) ?? (data["id"] as? Int)?.toString() {
            switch id {
            case PUSH.LoginAtAnother:
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                self.gotoLogin()
                break;
            case PUSH.Approved:
                ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
                ProviderSingleton.shared.timerForAcceptRejectTrip = nil
                self.gotoMap()
                break;
            case PUSH.Declined:
                self.gotoMap()
                break;
            case PUSH.UserCancelTrip, PUSH.AdminCancelled:
                self.gotoMap()
                break;
            case PUSH.TripAlreadyAccepted:
                self.gotoMap()
                break;
            case PUSH.ProviderIsOffline:
                self.gotoMap()
                break;
            case PUSH.ProviderSecondNewTrip:
                self.gotoTrip()
                break
            case PUSH.ProviderNewTrip,PUSH.UserSetDestinaiton,PUSH.UserChangePaymentModeCash,PUSH.UserChangePaymentModeCard,PUSH.UserChangePaymentModeApplePay,PUSH.WaitingForTip:
                if let wd = self.window {
                    var viewController = wd.rootViewController
                    if(viewController is PBRevealViewController) {
                        viewController = (viewController as! PBRevealViewController).mainViewController
                        if(viewController is UINavigationController) {
                            viewController = (viewController as! UINavigationController).visibleViewController
                            if viewController is TripVC {
                                if let tripVC:TripVC =  viewController as? TripVC {
                                    if id == PUSH.UserSetDestinaiton {
                                        print("\(self) \(#function)")
                                        tripVC.wsGetTripStatus()
                                    }
                                }
                            } else {
                                print("else ma jay che")
                            }
                        } else {
                            print("UINavigationController false")
                        }
                    } else {
                        print("PBRevealViewController false")
                    }
                } else {
                    print("mainWindow false")
                }
                
                break;
            default:
                break;
            }
        }
    }
}

//MARK:- Push notification Handler
extension AppDelegate {
    func wsUpdateDeviceToken() {
        if !preferenceHelper.getUserId().isEmpty {
            let afh:AlamofireHelper = AlamofireHelper.init()
            let dictParam : [String : Any] =
                [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
                  PARAMS.TOKEN : preferenceHelper.getSessionToken(),
                  PARAMS.DEVICE_TOKEN : preferenceHelper.getDeviceToken()];

            afh.getResponseFromURL(url: WebService.UPDATE_DEVICE_TOKEN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {  (response,data,error) -> (Void) in
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("FCM token from delegate: \(fcmToken)")
        preferenceHelper.setDeviceToken(fcmToken)
        self.wsUpdateDeviceToken()
    }
}
