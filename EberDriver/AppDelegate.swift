//
//  AppDelegate.swift
//  EberDriver
//
//  Created by Elluminati  on 22.12.18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManager
import GoogleMaps
import UserNotifications
import GooglePlaces
import IQKeyboardManager
import GoogleSignIn
import FirebaseCrashlytics
import Firebase
import FBSDKLoginKit
import Alamofire
import Sentry
 
extension UIViewController {
    public func removeFromParentAndNCObserver() {
        for childVC in self.children {
            childVC.removeFromParentAndNCObserver()
        }

        if self.isKind(of: UINavigationController.classForCoder()) {
            (self as! UINavigationController).viewControllers = []
        }

        self.dismiss(animated: false, completion: nil)        
        self.view.removeFromSuperviewAndNCObserver()
        NotificationCenter.default.removeObserver(self)
        self.removeFromParent()
    }
}

extension UIView {
    public func removeFromSuperviewAndNCObserver() {
        for subvw in self.subviews {
            subvw.removeFromSuperviewAndNCObserver()
        }

        NotificationCenter.default.removeObserver(self)
        //self.removeFromSuperview()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability: Reachability?;
    var dialogForNetwork:CustomAlertDialog?;
    var nearTripDetail : TripsRespons?
    var is_app_in_review : Bool?
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    fileprivate static let instance = UIApplication.shared.delegate as! AppDelegate
    static func SharedApplication() -> AppDelegate {
        return instance
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Localizer.doTheMagic()
        setupNetworkReachability()
        application.isIdleTimerDisabled = true
        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let lhs = Utility.currentAppVersion()
        let rhs = Utility.getLatestVersion()
        if lhs.compare(rhs, options: .numeric) == .orderedDescending
        {
            is_app_in_review = true
        }
        
        SentrySDK.start { options in
                    options.dsn = "  https://2d5965bcfed1651d5d0ffbe1082e4aa3@o4509287234273280.ingest.de.sentry.io/6473368647"
                    options.debug = true // Useful for development
                    options.tracesSampleRate = 1.0 // 100% performance tracing (adjust in prod)
                }
        return true
    }
    func BiometricAuthentication(){

        AppLockManager.shared.BiometricAuth { result in
                    switch result {
                    case .success:
                        // Authentication successful
                        //self.loginSuccessed()
                        print("successed")

                    case .failure:
                        // Authentication failed or was canceled
                        print("not identified")
                        self.notIdentify()
                    }
                }
    }
    func notIdentify(){
        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "try again!", style: .default) { [weak self] (_) in self?.BiometricAuthentication() }
        ac.addAction(okAction)
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    rootViewController.present(ac, animated: true, completion: nil)
                }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if preferenceHelper.getAllowBiomatricVerification() && preferenceHelper.getBiomatricVerification()
        {
                self.BiometricAuthentication()
        }
        NotificationCenter.default.post(name: .applicationWillEnterForeground, object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let _:Bool = GIDSignIn.sharedInstance.handle(url)
        let _:Bool = FBSDKCoreKit.ApplicationDelegate.shared.application(app, open: url, options: options)
        return true
    }

    //MARK: - Core Data stack
    func addLocationToDb() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LocationData", in: context)
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        newLocation.setValue(ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6), forKey: "latitude")
        newLocation.setValue(ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6), forKey: "longitude")
        let time = (Date().timeIntervalSince1970 * 1000).toString()
        newLocation.setValue(time, forKey: "time")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }

    func fetchLocationFromDB() -> [[String]] {
        var locationArray:[[String]] = [[]]
        locationArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let latitude = (data.value(forKey:"latitude") as? String) ?? ""
                let longitude = (data.value(forKey:"longitude") as? String) ?? ""
                let time = (data.value(forKey:"time") as? String) ?? ""
                locationArray.append([latitude,longitude,time])
            }
        } catch {
            print("Failed")
        }

        if locationArray.isEmpty {
            locationArray = [[ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6),(Date().timeIntervalSince1970 * 1000).toString()
                ]]
        }
        return locationArray
    }

    func clearEntity() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in  error : \(error) \(error.userInfo)")
        }
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EberDriver")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    //MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: - Keyboard Setting
    func setupIQKeyboard() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        UITextField.appearance().tintColor = UIColor.black;
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }

    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x: 0, y: size.height-lineSize.height, width: lineSize.width, height: lineSize.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        image.resizableImage(withCapInsets: UIEdgeInsets.zero)
        return image
    }
}

//MARK: - Navigations
extension AppDelegate {
    func gotoLogin() {
        LocationCenter.default.stopUpdatingLocation()
        SocketHelper.shared.disConnectSocket()
        MessageHandler.Instace.delegate = nil
        Utility.hideLoading()
        Alamofire.Session.default.session.cancelTasks {
            ProviderSingleton.shared.clear()
            ProviderSingleton.shared.clearTripData()
            ProviderSingleton.shared.timerUpdateLocation?.invalidate()
            ProviderSingleton.shared.timerUpdateLocation = nil
            ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
            ProviderSingleton.shared.timerForAcceptRejectTrip = nil
            Utility.hideLoading()
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window!.rootViewController = AppStoryboard.PreLogin.instance.instantiateInitialViewController() as! UINavigationController
            self.window?.makeKeyAndVisible();
        }        
    }

    func gotoMap() {
        LocationCenter.default.stopUpdatingLocation()
        MessageHandler.Instace.delegate = nil
        Alamofire.Session.default.session.cancelTasks {
            ProviderSingleton.shared.clearTripData()
            ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
            ProviderSingleton.shared.timerForAcceptRejectTrip = nil
            ProviderSingleton.shared.timerUpdateLocation?.invalidate()
            Utility.hideLoading()
            let pbrController = AppStoryboard.Map.instance.instantiateInitialViewController() as! PBRevealViewController
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window!.rootViewController = pbrController
            self.window?.makeKeyAndVisible();
            self.registerForPushNotifications()
        }
    }

    func gotoDocument() {
        LocationCenter.default.stopUpdatingLocation()
        MessageHandler.Instace.delegate = nil
        Alamofire.Session.default.session.cancelTasks {
            Utility.hideLoading()
            let mainViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "documentVC")
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window!.rootViewController = mainViewController
            self.window?.makeKeyAndVisible();
            self.registerForPushNotifications()
        }
    }

    func gotoTrip() {
        LocationCenter.default.stopUpdatingLocation()
        MessageHandler.Instace.delegate = nil
        SocketHelper.shared.disConnectSocket()
        CustomAlertDialog.removeCustomAlertDialog()
        Alamofire.Session.default.session.cancelTasks {
            Utility.hideLoading()
            let mainViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "MainNavController")
            let leftViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "LeftMenuController")
            let tripViewController = AppStoryboard.Trip.instance.instantiateInitialViewController()!
            (mainViewController as! UINavigationController).viewControllers = [tripViewController]
            let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: mainViewController)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = revealViewController
            self.window?.makeKeyAndVisible()
            self.registerForPushNotifications()
        }
    }

    func gotoInvoice() {
        LocationCenter.default.stopUpdatingLocation()
        MessageHandler.Instace.delegate = nil
        SocketHelper.shared.disConnectSocket()
        Alamofire.Session.default.session.cancelTasks {
            Utility.hideLoading()
            Utility.hideMessageLoading()            
            let mainViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "MainNavController")
            let leftViewController = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "LeftMenuController")
            let invoiceVC = AppStoryboard.Trip.instance.instantiateViewController(withIdentifier: "invoiceVC")
            (mainViewController as! UINavigationController).viewControllers = [invoiceVC]
            let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: mainViewController)
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window?.rootViewController = revealViewController
            self.window?.makeKeyAndVisible()
            self.registerForPushNotifications()
        }
    }
    
    func goToSplash() {
        LocationCenter.default.stopUpdatingLocation()
        SocketHelper.shared.disConnectSocket()
        MessageHandler.Instace.delegate = nil
        Alamofire.Session.default.session.cancelTasks {
            ProviderSingleton.shared.clear()
            ProviderSingleton.shared.clearTripData()
            ProviderSingleton.shared.timerUpdateLocation?.invalidate()
            ProviderSingleton.shared.timerUpdateLocation = nil
            ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
            ProviderSingleton.shared.timerForAcceptRejectTrip = nil
            Utility.hideLoading()
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window!.rootViewController = AppStoryboard.Splash.instance.instantiateInitialViewController()
            self.window?.makeKeyAndVisible();
        }
    }
    
    func goToFaceId() {
        LocationCenter.default.stopUpdatingLocation()
        SocketHelper.shared.disConnectSocket()
        MessageHandler.Instace.delegate = nil
        Alamofire.Session.default.session.cancelTasks {
            ProviderSingleton.shared.clear()
            ProviderSingleton.shared.clearTripData()
            ProviderSingleton.shared.timerUpdateLocation?.invalidate()
            ProviderSingleton.shared.timerUpdateLocation = nil
            ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
            ProviderSingleton.shared.timerForAcceptRejectTrip = nil
            Utility.hideLoading()
            self.window?.removeFromSuperviewAndNCObserver()
            self.window?.rootViewController?.removeFromParentAndNCObserver()
            self.window!.rootViewController = AppStoryboard.Splash.instance.instantiateInitialViewController()
            self.window?.makeKeyAndVisible();
        }
    }

    func setupTabbar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:FontHelper.font(size: FontSize.regular, type: FontType.Regular), NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal);
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:FontHelper.font(size: FontSize.large, type: FontType.Regular), NSAttributedString.Key.foregroundColor: UIColor.themeTextColor], for: .selected);
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }
}

//MARK: - Network Handling
extension AppDelegate {
    func setupNetworkReachability() {
        self.reachability = Reachability.init();
        do {
            try self.reachability?.startNotifier()
        }catch {
            print(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
    }
    
    func  openNetworkDialog () {
        dialogForNetwork  = CustomAlertDialog.showCustomAlertDialog(title: "TXT_INTERNET".localized, message: "MSG_INTERNET_ENABLE".localized, titleLeftButton: "TXT_EXIT".localized, titleRightButton: "TXT_OK".localized)
        
        self.dialogForNetwork!.onClickLeftButton = { [unowned self, weak dialogForNetwork = self.dialogForNetwork] in
            self.dialogForNetwork!.removeFromSuperview();
            dialogForNetwork?.removeFromSuperview()
            exit(0)
        }
        
        self.dialogForNetwork!.onClickRightButton = { [unowned self, weak dialogForNetwork = self.dialogForNetwork] in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        
                    })
                }else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
            self.dialogForNetwork?.removeFromSuperview();
            dialogForNetwork?.removeFromSuperview()
        }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        DispatchQueue.main.async {
            if reachability.isReachable {
                if (APPDELEGATE.window?.viewWithTag(DialogTags.networkDialog)) != nil {
                    self.dialogForNetwork?.removeFromSuperview()
                }
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                }else {
                    print("Reachable via Cellular")
                }
            }else {
                print("Network not reachable")
                self.openNetworkDialog()
            }
        }

    }
}




