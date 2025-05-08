//
//  Utility.swift
//  tableViewDemo
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit
import SDWebImage

class Utility: NSObject
{
    class func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString()
    }

    static func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }

    static func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }

    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var overlayView = UIView();
    static var mainView = UIView();

    static var messageActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var messageOverlayView = UIView();
    static var messageLoaingView = UIView();

    override init() {}

    static func dateToString(date: Date, withFormat:String, withTimezone:TimeZone = TimeZone.ReferenceType.default, isForceEnglish: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        if isForceEnglish {
            dateFormatter.locale = Locale.init(identifier: "en_GB")
        } else {
            dateFormatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        }
        dateFormatter.timeZone = withTimezone
        dateFormatter.dateFormat = withFormat
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }

    static func showLoading(color: UIColor = UIColor.white) {
        DispatchQueue.main.async {
            if(!activityIndicator.isAnimating) {
                self.mainView = UIView()
                self.mainView.frame = UIScreen.main.bounds
                self.mainView.backgroundColor = UIColor.clear
                self.overlayView = UIView()
                self.activityIndicator = UIActivityIndicatorView()

                overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                overlayView.clipsToBounds = true
                overlayView.layer.cornerRadius = 10
                overlayView.layer.zPosition = 1

                activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                activityIndicator.style = .whiteLarge
                overlayView.addSubview(activityIndicator)
                self.mainView.addSubview(overlayView)

                if APPDELEGATE.window?.viewWithTag(701) != nil {
                    UIApplication.shared.keyWindow?.bringSubviewToFront(mainView)
                } else {
                    overlayView.center = CGPoint(x: Common.screenRect.size.width/2, y: Common.screenRect.size.height/2)
                    mainView.tag = 701
                    UIApplication.shared.keyWindow?.addSubview(mainView)
                    activityIndicator.startAnimating()
                }
                
                if Bundle.main.bundleIdentifier == bundleId {
                    let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Utility.userSwipedFromEdge(sender:)))
                    edgeGestureRecognizer.edges = .right
                    Utility.mainView.addGestureRecognizer(edgeGestureRecognizer)
                }
            }
        }
    }
    
    @objc static func userSwipedFromEdge(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.edges == UIRectEdge.right {
            let dialog = DialogForApplicationMode.showCustomAppModeDialog()
            
            dialog.onClickLeftButton = { [unowned dialog] in
                dialog.removeFromSuperview()
            }
            
            dialog.onClickRightButton = { [unowned dialog] in
                dialog.removeFromSuperview()
            }
        }
    }

    static func showMessageLoading(color:UIColor = UIColor.white, message:String) {
        DispatchQueue.main.async {
            Utility.hideLoading()
            print("utility message show")
            if(!messageActivityIndicator.isAnimating) {
                self.messageLoaingView = UIView()
                self.messageLoaingView.frame = UIScreen.main.bounds
                self.messageLoaingView.backgroundColor = UIColor.clear
                self.messageOverlayView = UIView()
                self.messageActivityIndicator = UIActivityIndicatorView()
                messageLoaingView.tag = 702
                let messageLabel:UILabel = UILabel.init()
                messageLabel.text = message
                messageLabel.frame = CGRect(x: 80, y: messageOverlayView.bounds.height / 2, width: UIScreen.main.bounds.width * 0.4, height: 80)
                messageLabel.textAlignment = .center
                messageLabel.textColor = UIColor.themeTextColor
                messageLabel.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
                messageLabel.numberOfLines = 2
                messageOverlayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 80)
                
                
                messageOverlayView.backgroundColor = UIColor(white: 1, alpha: 1.0)
                messageOverlayView.clipsToBounds = true
                messageOverlayView.layer.cornerRadius = 10
                messageOverlayView.layer.zPosition = 1
                
                messageActivityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                messageActivityIndicator.center = CGPoint(x: 30, y: messageOverlayView.bounds.height / 2)
                
                messageLabel.center = messageOverlayView.center
                
                messageOverlayView.setShadow()
                
                messageActivityIndicator.style = UIActivityIndicatorView.Style.gray
                messageOverlayView.addSubview(messageLabel)
                messageOverlayView.addSubview(messageActivityIndicator)
                self.messageLoaingView.addSubview(messageOverlayView)
                
                if APPDELEGATE.window?.viewWithTag(702) != nil
                {
                    messageOverlayView.center = (UIApplication.shared.keyWindow?.center)!
                    
                    
                    UIApplication.shared.keyWindow?.bringSubviewToFront(messageLoaingView)
                    messageActivityIndicator.startAnimating()
                }
                else
                {
                    messageOverlayView.center = (UIApplication.shared.keyWindow?.center)!
                    UIApplication.shared.keyWindow?.addSubview(messageLoaingView)
                    messageActivityIndicator.startAnimating()
                }
            }
            else
            {
                
            }
            
        }
        
    }
    static func hideMessageLoading(){
        DispatchQueue.main.async {
            messageActivityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.viewWithTag(702)?.removeFromSuperview()
            messageLoaingView.removeFromSuperview()
            print("utility message hide")
            
        }
    }
    
    static func hideLoading(){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.viewWithTag(701)?.removeFromSuperview()
        }
    }
    static func showToast( message:String, backgroundColor:UIColor = UIColor.themeButtonBackgroundColor, textColor:UIColor = UIColor.white, sameContainer: Bool = false) {

        if !message.isEmpty {
            DispatchQueue.main.async {
                
                let labelTag = 14856
                
                var window: UIWindow?
                if let keyWindow = UIApplication.shared.keyWindow {
                    window = keyWindow
                } else
                {
                    window = UIApplication.shared.windows.last
                }
                
                if sameContainer {
                    if let lbl = window?.viewWithTag(labelTag) as? UILabel {
                        return
                    }
                }
                
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
                let label = UILabel(frame: CGRect.zero);
                label.textAlignment = NSTextAlignment.center;
                label.text = message;
                label.adjustsFontSizeToFitWidth = true;
                label.tag = labelTag

                label.backgroundColor =  backgroundColor; //UIColor.whiteColor()
                label.textColor = textColor; //TEXT COLOR
                label.sizeToFit()
                label.numberOfLines = 4
                label.layer.shadowColor = UIColor.gray.cgColor;
                label.layer.shadowOffset = CGSize.init(width: 4, height: 3)
                label.layer.shadowOpacity = 0.3;
                label.frame = CGRect.init(x: 0, y: (appDelegate.window?.frame.maxY)!, width:  appDelegate.window!.frame.size.width, height: 44);

                label.alpha = 1
                UIApplication.shared.keyWindow?.endEditing(true)
                UIApplication.shared.windows.last?.endEditing(true)
                

                
                window?.addSubview(label)


                var basketTopFrame: CGRect = label.frame;
                basketTopFrame.origin.x = 0;
                basketTopFrame.origin.y = (appDelegate.window?.frame.maxY)! - label.frame.height;

                UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                    label.frame = basketTopFrame
                },  completion: {
                    (value: Bool) in
                    UIView.animate(withDuration: 3.0, delay: 3.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                        label.alpha = 0
                    },  completion: {
                        (value: Bool) in
                        label.removeFromSuperview()
                    })
                })
            }
        }
    }

    static func convertDictToJson(dict:Dictionary<String, Any>) -> Void{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
    }

    //MARK: - Date Handler
    static func stringToString(strDate:String, fromFormat:String, toFormat:String, isForceEnglish: Bool = false)->String{
        let dateFormatter = DateFormatter()
        if isForceEnglish {
            dateFormatter.locale = Locale.init(identifier: "en_GB")
        } else {
            dateFormatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        }
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates
    }

    static func relativeDateStringForDate(strDate: String) -> NSString{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.string(from:NSDate() as Date)
        
        let calender : NSCalendar = NSCalendar.init(identifier:.gregorian)!
        
        let dayComponent = NSDateComponents()
        
        dayComponent.day = -1
        
        let date:Date = calender.date(byAdding:dayComponent as DateComponents, to: NSDate() as Date, options: NSCalendar.Options(rawValue: 0))!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strYesterdatDate = dateFormatter.string(from:date as Date)
        
        if(strDate == currentDate)
        {
            return "Today"
        }
        else if(strDate == strYesterdatDate)
        {
            return "Yesterday"
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: strDate)
            let myCurrentDate = Utility.convertDateFormate(date: date!)
            return myCurrentDate as NSString
        }
    }
    
    static func secondsToHoursMinutes(seconds : Int64) -> String{
        return "\(seconds / 3600) hr \((seconds % 3600) / 60) min"
    }
    static func minutToHoursMinutes(minut : Double) -> String {
        
        let seconds =  Int64.init(minut * 60)
        return "\(seconds / 3600) : \((seconds % 3600) / 60)"
    }

    static func hmsFrom(seconds: Int, completion: @escaping (_ hours: Double, _ minutes: Double, _ seconds: Double)->()) {
        completion(Double(seconds / 3600), Double((seconds % 3600) / 60), Double((seconds % 3600) % 60))
    }

    static func distanceFrom(meters: Double, unit:Int,  completion: @escaping (_ distance: String)->()) {
        if unit == TRUE {
            completion((meters * 0.001).toString(places: 2) + " " + MeasureUnit.KM)
        } else {
            completion((meters * 0.000621371).toString(places: 2) + " " + MeasureUnit.MILE)
        }
    }
    
    static func convertDateFormate(date : Date, isForceEnglish: Bool = false) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        if isForceEnglish {
            dateFormate.locale = Locale.init(identifier: "en_GB")
        } else {
            dateFormate.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        }
        dateFormate.timeZone = TimeZone.ReferenceType.default
        
        dateFormate.dateFormat = "MMMM, yyyy"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
    static func convertSelectedDateToMilliSecond(serverDate:Date,strTimeZone:String)-> Int64{
        let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.ReferenceType.default
        
        
        let offSetMiliSecond = Int64(timezone.secondsFromGMT() * 1000)
        let timeSince1970 = Int64(serverDate.timeIntervalSince1970)
        let finalSelectedDateMilli =   Int64(  Int64(timeSince1970 * 1000) +  offSetMiliSecond)
        return finalSelectedDateMilli
    }
    static func stringToDate(strDate: String, withFormat:String, timeZone: TimeZone = TimeZone.ReferenceType.default) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        dateFormatter.timeZone = timeZone
        
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: strDate) ?? Date()
    }
    
    class func isUpdateAvailable(_ latestVersion: String) -> Bool {
        if !latestVersion.isEmpty {
            let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
            let myCurrentVersion: [String] = currentAppVersion.components(separatedBy: ".")
            let myLatestVersion: [String] = latestVersion.components(separatedBy: ".")
            let legthOfLatestVersion: Int = myLatestVersion.count
            let legthOfCurrentVersion: Int = myCurrentVersion.count
            if legthOfLatestVersion == legthOfCurrentVersion {
                for i in 0..<myLatestVersion.count {
                    if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                        return true
                    }else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                        continue
                    }else {
                        return false
                    }
                }
                return false
            } else {
                let count: Int = legthOfCurrentVersion > legthOfLatestVersion ? legthOfLatestVersion : legthOfCurrentVersion
                for i in 0..<count {
                    if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                        return true
                    }else if CInt(myCurrentVersion[i])! > CInt(myLatestVersion[i])! {
                        return false
                    }else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                        continue
                    }
                }
                if legthOfCurrentVersion < legthOfLatestVersion {
                    for i in legthOfCurrentVersion..<legthOfLatestVersion {
                        if CInt(myLatestVersion[i]) != 0 {
                            return true
                        }
                    }
                    return false
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }
    
    class func wsGetAppSetting(_ block:@escaping () -> ()) {
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
            if Parser.parseAppSettingDetail(response: response, data: data) {
            }
            block()
        }
    }
    
    class func getLatestVersion() -> String {
        guard
            let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let versionString = results[0]["version"] as? String
            else {
                return ""
        }
        print("Latest Version:- \(versionString)")
        return versionString
    }
    
   //MARK:
    //MARK: - Gesture Handler
    static func getListFromYear(year:Int) -> [(Date,Date)]{
        let cal = Calendar.current
        
        var myDateSelectionArray = Array<(Date,Date)>()
        
        let startDateComponents = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: 1, hour: 12, minute: 00, second: 00, nanosecond: 00, weekday: 1, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: year)
        
        let stopDateComponents = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: nil, month: 12, day: 31, hour: 12, minute: 00, second: 00, nanosecond: 00, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: year)
        
        let startDate = cal.date(from: startDateComponents)!
        var stopDate = cal.date(from: stopDateComponents)!
        
        if stopDate > Date()
        {
            stopDate = Date()
        }
        
        var comps = DateComponents()
        comps.weekday = 1
        // Sunday
        
        cal.enumerateDates(startingAfter: startDate, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .forward)
        { (date, match, stop) in
            if let sundayDate = date
            {
                if sundayDate > stopDate
                {
                    stop = true
                }
                else
                {
                    let d:DateFormatter = DateFormatter()
                    d.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
                    d.dateFormat = "dd MMM yyyy"
                    let nextSaturday = cal.date(byAdding: .day, value: 6, to: sundayDate)!
                    myDateSelectionArray.append((sundayDate,nextSaturday))
                }
            }
            
        }
        myDateSelectionArray.reverse()
        if myDateSelectionArray.isEmpty {
            let date1 = Utility.getDate(myDate: Date(),day: 1)
            let date2 = Utility.getDate(myDate: Date(),day: 7)
            myDateSelectionArray.append((date1,date2))
        }
        return myDateSelectionArray
    }
    static func getDistanceUnit(unit: Int) -> String{
        if unit == TRUE {
            return MeasureUnit.KM
        }
        return MeasureUnit.MILE
    }

    static func getDate(myDate: Date, day: Int) -> Date {
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        comps.weekday = day
        let dayInWeek = cal.date(from: comps)!
        return dayInWeek
    }
    static func addGestureForRemoveViewOnTouch(view:UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        view.addGestureRecognizer(tap)
    }
    @objc static func hideView(sender:UITapGestureRecognizer){
        let view:UIView = sender.view!
        view.removeFromSuperview()
        view.endEditing(true)
    }
    
    static func downloadImageFrom(link:String, placeholder:String = "asset-driver-pin-placeholder", completion: @escaping (_ result: UIImage) -> Void){
        if link.isEmpty()
        {
            return  completion(UIImage.init(named: placeholder)!)
        }
        else
        {
            let urlStr = WebService.BASE_URL +  link
            let shared = SDWebImageDownloader.shared
            guard let url = URL(string: urlStr) else {
                return
            }
            
            shared.downloadImage(with: url,
                                 options: SDWebImageDownloaderOptions.ignoreCachedResponse,
                                 progress: nil,
                                 completed: { /*[weak self]*/ (image, data, error, result) in
                if error != nil {
                    //debugPrint("\(self ?? UIImageView()) \(err)")
                }
                
                if let downloadedImage = image
                {
                    let width = (UIScreen.main.bounds.width * 0.1)
                    let height = width
                    let size = CGSize.init(width: width, height: height)
                    let newImage = downloadedImage.jd_imageAspectScaled(toFit: size)
                    completion(newImage)
                }
            })
        }
        
    }
    
    static func currentAppVersion() -> String {
        if let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return currentAppVersion
        }
        return ""
    }
    
    static func getCancellationReasons(block:@escaping (_ response:[String]) -> ()) {
        
        Utility.showLoading()
        
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.user_type] = 2 //provider
        dictParam[PARAMS.lang] = preferenceHelper.getLanguageCode()

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.get_cancellation_reason, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            Utility.hideLoading()
            if let arrReason = response["reasons"] as? [String] {
                block(arrReason)
            } else {
                block(["TXT_CANCEL_TRIP_REASON".localized, "TXT_CANCEL_TRIP_REASON1".localized, "TXT_CANCEL_TRIP_REASON2".localized,"TXT_CANCEL_TRIP_REASON3".localized])
            }
        }
    }
}

extension UIStoryboard {

    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func tripStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Trip", bundle: nil)
    }

}

extension Notification.Name {
    static let didChangeCustomLocation = Notification.Name(rawValue: "didChangeCustomLocation")
    static let applicationWillEnterForeground = Notification.Name(rawValue: "applicationWillEnterForeground")
}

