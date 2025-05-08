//
//  LocationCenter.swift
//  HyrydeDriver
//
//  Created by Mac Pro5 on 01/10/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

typealias TimeDistanceAPICompletion = ((_ time: String, _ Distance: String) -> Void)

class LocationCenter: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var jobCompletion: Completion?
    var country: String = ""
    var countryISOcode: String = ""
    static var alertVC: UIAlertController?

    class var isServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled() 
    }
    
    class var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus() 
    }
    
    class var isAlways_OR_WhenInUse: Bool {
        let status = LocationCenter.authorizationStatus
        return (status == CLAuthorizationStatus.authorizedAlways) || 
            (status == CLAuthorizationStatus.authorizedWhenInUse)
    }
    
    class var isDenied: Bool {
        let status = LocationCenter.authorizationStatus
        return status == CLAuthorizationStatus.denied
    }
    
    var lastLocation: CLLocation? { 
        return self.manager.location
    }
    
    static let `default`: LocationCenter = {
        let instance: LocationCenter = LocationCenter()    
        return instance
    }()
    
    // MARK: - 
    
    override init() {
        super.init()
        
        self.manager.delegate = self
        self.manager.activityType = CLActivityType.other
        self.manager.distanceFilter = 10.0
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.pausesLocationUpdatesAutomatically = false
        self.manager.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            self.manager.showsBackgroundLocationIndicator = false
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeCustomNotification), name: .didChangeCustomLocation, object: nil)
    }
    
    // MARK: - 
    
    class func allowAlert() {
        if preferenceHelper.getUserId().isEmpty {
            return
        }
        /*
        OperationQueue.main.addOperation { 
            let msg = String(format: "%@", "\nPlease enable location services from the Settings app.\n\n1. Go to Settings > Privacy > Location Services.\n\n2. Make sure that location services is on.")
            
            LocationCenter.alertVC = UIAlertController(title: "Allow location",
                                       message: msg, 
                                       preferredStyle: UIAlertController.Style.alert)
            
            let act = UIAlertAction(title: "OK", 
                                    style: UIAlertAction.Style.default, 
                                    handler: { (act: UIAlertAction) in
                                        Common.openSettingsApp()
            })
            
            if let vc = LocationCenter.alertVC {
                vc.addAction(act)
                Common.appDelegate.window?.rootViewController?.present(vc, animated: true, completion: {
                    print(#function)
                })
            }
        }*/
        
        OperationQueue.main.addOperation {
            let dialogForStripeError:CustomAlertDialog = CustomAlertDialog.showCustomAlertDialog(title: "Allow location", message: "Please enable location services from the Settings app.\n\n1. Go to Settings > Privacy > Location Services.\n\n2. Make sure that location services is on.", titleLeftButton: "", titleRightButton: "OK", tag: DialogTags.locationPermision)
            dialogForStripeError.onClickRightButton = {
                Common.openSettingsApp()
            }
        }
    }
    
    class func removeAlert() {
        if let vw = APPDELEGATE.window?.viewWithTag(DialogTags.locationPermision) as? CustomAlertDialog {
            vw.removeFromSuperview()
        }
    }
    
    func addObserver(_ observer: Any, _ selectors: [Selector]) {
        Common.nCd.removeObserver(observer, 
                                  name: Common.locationUpdateNtfNm, 
                                  object: LocationCenter.default)
        
        Common.nCd.removeObserver(observer, 
                                  name: Common.locationFailNtfNm, 
                                  object: LocationCenter.default)
        
        Common.nCd.addObserver(observer, 
                               selector: selectors[0], 
                               name: Common.locationUpdateNtfNm, 
                               object: LocationCenter.default)
        
        Common.nCd.addObserver(observer, 
                               selector: selectors[1], 
                               name: Common.locationFailNtfNm, 
                               object: LocationCenter.default)
    }
    
    func requestAuthorization() {
        if LocationCenter.isServicesEnabled && (!LocationCenter.isDenied) {
            self.manager.requestAlwaysAuthorization()
        } 
        else {
            Utility.hideLoading()
            if APPDELEGATE.is_app_in_review != true
            {
                LocationCenter.allowAlert()
            }
        }
    }
    
    func requestLocationOnce() {
        if LocationCenter.isAlways_OR_WhenInUse {
            self.manager.requestLocation()
        } 
        else {
            self.requestAuthorization()
            self.jobCompletion = { [weak self] in
                self?.manager.requestLocation()
            }
        }
    }
    
    func startUpdatingLocation() {
        if LocationCenter.isAlways_OR_WhenInUse {
            self.manager.startUpdatingLocation()
        } 
        else {
            self.requestAuthorization()
            self.jobCompletion = { [weak self] in
                self?.manager.startUpdatingLocation()
            }
        }
    }
    
    func stopUpdatingLocation() {
        self.manager.stopUpdatingLocation()
    }

    func fetchCityAndCountry(location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        
        self.geocoder.reverseGeocodeLocation(location) {
            [weak self] (placemarks: [CLPlacemark]?, error: Error?) in
            guard let self = self else { return }

            if let placemark = placemarks?.first {
                print("\(self) \(#function) \(placemark)")
                self.country = placemark.country ?? ""
                self.countryISOcode = placemark.isoCountryCode ?? ""

                if ProviderSingleton.shared.currentCountryCode.isEmpty() {
                    ProviderSingleton.shared.currentCountryCode = (placemark.isoCountryCode) ?? ""
                }
                completion(placemark.locality, placemark.country, error)

            }
            else {
                print("\(self) \(#function) \(error?.localizedDescription ?? "")")

                let gmsGeocoder: GMSGeocoder = GMSGeocoder()
                gmsGeocoder.reverseGeocodeCoordinate(location.coordinate)
                { [weak self] (response: GMSReverseGeocodeResponse?, error: Error?) in
                    if error == nil {
                        if let r = response {
                            if let first = r.firstResult() {
                                self?.country = first.country ?? ""
                                completion(""  , first.country ?? "", error)
                            }
                        }
                    }
                    else {
                        self?.country = ""
                        self?.countryISOcode = ""
                    }
                     completion("", "", error)
                }
            }
        }

        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "en_US_POSIX")) { placemarks, error in
                if ProviderSingleton.shared.currentCountryCode.isEmpty() {
                    ProviderSingleton.shared.currentCountryCode = (placemarks?.first?.isoCountryCode) ?? ""
                }
                completion(placemarks?.first?.locality, placemarks?.first?.country, error)
            }
        } else {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if ProviderSingleton.shared.currentCountryCode.isEmpty() {
                    ProviderSingleton.shared.currentCountryCode = (placemarks?.first?.isoCountryCode) ?? ""
                }
                completion(placemarks?.first?.locality, placemarks?.first?.country, error)
            }
        }
    }

    func getAddressFromLatitudeLongitude(latitude:Double,longitude:Double, completion: @escaping (String,[Double])->Void)  {
        print("JD GEO CODE API CALLED - location to address")
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        if coordinate.isValidCoordinate() {
            let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
            aGMSGeocoder.reverseGeocodeCoordinate(coordinate) { (gmsReverseGeocodeResponse, error) in
                if error == nil {
                    if let gmsAddress: GMSAddress = gmsReverseGeocodeResponse?.firstResult() {
                        let latitude = gmsAddress.coordinate.latitude
                        let longitude = gmsAddress.coordinate.longitude
                        var address: String = ""
                        for line in  gmsAddress.lines ?? [] {
                            address += line + " "
                        }
                        completion(address,[latitude,longitude])
                    } else {
                        completion("",[0.0,0.0])
                    }
                } else {
                    completion("",[0.0,0.0])
                }
            }
        } else {
            completion("",[0.0,0.0])
        }
    }

    func googlePlacesResult(input: String, completion: @escaping (_ result: [(title:String,subTitle:String,address:String, placeid:String)]) -> Void) {
        if !input.isEmpty() {
            var token: GMSAutocompleteSessionToken!
            if let currentToken = GoogleAutoCompleteToken.shared.token {
                if GoogleAutoCompleteToken.shared.isExpired() {
                    GoogleAutoCompleteToken.shared.token = GMSAutocompleteSessionToken.init()
                    GoogleAutoCompleteToken.shared.milliseconds = Date().millisecondsSince1970
                    token = GoogleAutoCompleteToken.shared.token!
                } else {
                    token = currentToken
                }
            } else {
                GoogleAutoCompleteToken.shared.token = GMSAutocompleteSessionToken.init()
                GoogleAutoCompleteToken.shared.milliseconds = Date().millisecondsSince1970
                token = GoogleAutoCompleteToken.shared.token!
            }
            let filter = GMSAutocompleteFilter()
            filter.country = ProviderSingleton.shared.currentCountryCode
            //filter.type = .noFilter

            let placeClient = GMSPlacesClient.shared()
            placeClient.findAutocompletePredictions(fromQuery: input, filter: filter, sessionToken: token, callback: { (results, error) in
                var myAddressArray :[(title:String,subTitle:String,address:String,placeid:String)] = []
                if let error = error {
                    print("Autocomplete error: \(error)")
                    completion(myAddressArray)
                    return
                }
                if let results = results {
                    myAddressArray = []
                    for result in results {
                        let mainString = (result.attributedPrimaryText.string)
                        let subString = (result.attributedSecondaryText?.string) ?? ""
                        let detailString = result.attributedFullText.string
                        let placeId = result.placeID
                        let myAddress:(title:String,subTitle:String,address:String,placeid:String) = (mainString,subString,detailString,placeId)
                        myAddressArray.append(myAddress)
                    }
                    completion(myAddressArray)
                }
                completion(myAddressArray)
            })
        }
    }

    //MARK:- LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.notDetermined:
            if APPDELEGATE.is_app_in_review != true
            {
                LocationCenter.allowAlert()
            }
            print("\(self) \(#function) notDetermined")
        case CLAuthorizationStatus.restricted:
            if APPDELEGATE.is_app_in_review != true
            {
                LocationCenter.allowAlert()
            }
            print("\(self) \(#function) restricted")
        case CLAuthorizationStatus.denied:
            if APPDELEGATE.is_app_in_review != true
            {
                LocationCenter.allowAlert()
            }
            print("\(self) \(#function) denied")
        case CLAuthorizationStatus.authorizedAlways:
            print("\(self) \(#function) authorizedAlways")
            LocationCenter.removeAlert()
            self.jobCompletion?()
        case CLAuthorizationStatus.authorizedWhenInUse:
            print("\(self) \(#function) authorizedWhenInUse")
            LocationCenter.removeAlert()
            self.jobCompletion?()
        default:
            break
        }
        
        Common.nCd.post(name: Common.locationPermisionChanged,
                        object: LocationCenter.default,
                        userInfo: [Common.locationKey: status])
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let distance = location.distance(from: Common.location)
        let t1 = location.timestamp.timeIntervalSince1970
        let t2 = Common.location.timestamp.timeIntervalSince1970
        let time = t1-t2
        let speed = fabs(distance/time)
        Common.location = location
        
        if (speed > 166.7) || 
            (location.horizontalAccuracy < 0.0) || 
            (location.horizontalAccuracy > 1000.0) {
            self.stopUpdatingLocation()
            //print("Invalid location speed: \(speed/1000.0) kilometers/seconds")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) { [weak self] in 
                guard let self = self else { return }
                self.startUpdatingLocation()
                //print("Retry location update due to occurrence of invalid speed")
            }
            
            return
        }
        
        if location.coordinate.isValidCoordinate() {
           /* if !Common.currentCoordinate.isEqual(location.coordinate) {
                Common.bearing = location.course
            }*/
            //Common.currentCoordinate = location.coordinate
        }
        
        if !preferenceHelper.getIsFakeGpsOn() {
            Common.nCd.post(name: Common.locationUpdateNtfNm,
                            object: LocationCenter.default,
                            userInfo: [Common.locationKey: location])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, 
                         didFailWithError error: Error) {
        Common.nCd.post(name: Common.locationFailNtfNm, 
                        object: LocationCenter.default, 
                        userInfo: [Common.locationErrorKey: error])
    }
    
    func locationManager(_ manager: CLLocationManager, 
                         didFinishDeferredUpdatesWithError error: Error?) {
        print("\(self) \(#function)")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("\(self) \(#function)")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("\(self) \(#function)")
    }
    
    func sendLocationPermisionFalse() {
        Common.nCd.post(name: Common.locationPermisionChanged,
                        object: LocationCenter.default,
                        userInfo: nil)
    }

    func getTimeAndDistance(sourceCoordinate:CLLocationCoordinate2D,destCoordinate:CLLocationCoordinate2D, unit:String, _ completion: @escaping TimeDistanceAPICompletion)
    {
        var time: String = "0"
        var distance:String = "0";



        if sourceCoordinate.isValidCoordinate() && destCoordinate.isValidCoordinate() {

            if sourceCoordinate.isEqual(destCoordinate) {
                completion(time,distance)
            }
            else {
                let pickup_latitude:String = sourceCoordinate.latitude.toString(places: 6)
                let pickup_longitude:String = sourceCoordinate.longitude.toString(places: 6)
                let destination_latitude:String = destCoordinate.latitude.toString(places: 6)
                let destination_longitude:String = destCoordinate.longitude.toString(places: 6)
                let strUrl:String =  Google.TIME_DISTANCE_URL + "\(pickup_latitude),\(pickup_longitude)&destinations=\(destination_latitude),\(destination_longitude)&key=\(preferenceHelper.getGoogleKey())"

                if let url:URL = URL.init(string: strUrl)
                {
                    let parseData = parseJSON(inputData: getJSON(urlToRequest: url))
                    let googleRsponse: GoogleDistanceMatrixResponse = GoogleDistanceMatrixResponse(dictionary:parseData)!
                    if ((googleRsponse.status?.compare("OK")) == ComparisonResult.orderedSame)
                    {
                        time = ((googleRsponse.rows?[0].elements?[0].duration?.value) ?? 0).toString()
                        let doubleDistance = ((googleRsponse.rows?[0].elements?[0].distance?.value) ?? Int(0.0))
                        distance = (doubleDistance).toString()
                        completion(time,distance)
                    } else {
                        completion(time,distance)
                    }
                } else {
                    completion(time,distance)
                }
            }
        }
    }

    func getJSON(urlToRequest:URL) -> Data {
        var content:Data?
        do {
            content = try Data(contentsOf:urlToRequest)
        }
        catch let error {
            print(error)
        }
        return content ?? Data.init()
    }

    func parseJSON(inputData:Data) -> NSDictionary{
        var dictData: NSDictionary = NSDictionary.init()
        if inputData.count > 0 {
            do {
                if let data = (try JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as? NSDictionary  {
                    dictData = data
                }
            }
            catch {
                print("Response not proper")
            }
        }
        return dictData
    }
    
    func reverseGeocoder(location: CLLocation, _ completion: @escaping Completion) {

        self.geocoder.reverseGeocodeLocation(location) {
            [weak self] (placemarks: [CLPlacemark]?, error: Error?) in
            guard let self = self else { return }

            if let placemark = placemarks?.first {
                self.country = placemark.country ?? ""
                self.countryISOcode = placemark.isoCountryCode ?? ""
            } else {
                let gmsGeocoder: GMSGeocoder = GMSGeocoder()
                gmsGeocoder.reverseGeocodeCoordinate(location.coordinate)
                { [weak self] (response: GMSReverseGeocodeResponse?, error: Error?) in
                    if error == nil {
                        if let r = response {
                            if let first = r.firstResult() {
                                self?.country = first.country ?? ""
                            }
                        }
                    } else {
                        self?.country = ""
                        self?.countryISOcode = ""
                    }
                    completion()
                }
            }
            completion()
        }
    }
    
    @objc func didChangeCustomNotification() {
        if preferenceHelper.getIsFakeGpsOn() {
            if preferenceHelper.getCustomLocation().count >= 2 {
                let clLocation = CLLocation(latitude: preferenceHelper.getCustomLocation()[0], longitude: preferenceHelper.getCustomLocation()[1])
                Common.nCd.post(name: Common.locationUpdateNtfNm,
                                object: LocationCenter.default,
                                userInfo: [Common.locationKey: clLocation])
            }
        }
    }
}

extension CLLocationCoordinate2D {
    func isValidCoordinate() -> Bool {
        if self.latitude == 0.0 && self.longitude == 0.0 {
            return false
        }
        return CLLocationCoordinate2DIsValid(self)
    }

    func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
        return self.latitude == coord.latitude && self.longitude == coord.longitude
    }

    func calculateBearing(to destination: CLLocationCoordinate2D) -> Double {
        let lat1 = Double.pi * self.latitude / 180.0
        let long1 = Double.pi * self.longitude / 180.0
        let lat2 = Double.pi * destination.latitude / 180.0
        let long2 = Double.pi * destination.longitude / 180.0
        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
}

public class GoogleAutoCompleteToken
{
    static let shared = GoogleAutoCompleteToken()
    var token:GMSAutocompleteSessionToken? = nil
    var milliseconds: Double = 0

    private init() {}

    func isExpired() -> Bool {
        let difference = (Date().millisecondsSince1970 - self.milliseconds)
        return difference > (180000)
    }
}
