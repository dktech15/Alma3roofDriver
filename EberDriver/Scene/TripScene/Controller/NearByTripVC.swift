//
//  NearByTripVC.swift
//  EberDriver
//
//  Created by Maulik Desai on 08/07/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AVFoundation
import FirebaseAuth

private struct MapPath : Decodable{
    var routes : [Route]?
}

private struct Route : Decodable{
    var overview_polyline : OverView?
}

private struct OverView : Decodable {
    var points : String?
}

class NearByTripVC: BaseVC, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    class func viewController(tripID: String) -> NearByTripVC {
        
        let vc = UIStoryboard.tripStoryboard().instantiateViewController(withIdentifier: "NearByTripVC") as! NearByTripVC
        vc.nearByTripID = tripID
        return vc
    }
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet var lblIconInfo: UILabel!
    @IBOutlet var imgFavourite: UIImageView!
    @IBOutlet var stkvwNavigationRightButtons: UIStackView!
    //@IBOutlet var stkvwNavigationRightButtonsWidth: NSLayoutConstraint!
    @IBOutlet weak var viewNavigationButton: UIView!

    @IBOutlet var btnCurrentLocation: UIButton!
    @IBOutlet var lblIconLocation: UILabel!
    @IBOutlet var imgIconLocation: UIImageView!
    @IBOutlet var lblCurrentAddress: UILabel!
    @IBOutlet var viewForCurrentAddress: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var imgMenu : UIImageView!
    @IBOutlet var btnUserRate: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnTimer: UIButton!
    var player: AVAudioPlayer?

    //Address View
    @IBOutlet var viewForPickupDestinationAddress: UIView!
    @IBOutlet var viewForPickupAddress: UIView!

    @IBOutlet var lblPickupAddress: UILabel!
    @IBOutlet var viewForDestinationAddress: UIView!
    @IBOutlet var lblDestinationAddress: UILabel!
    @IBOutlet var imgLocation: UIImageView!

    @IBOutlet var btnRentalInfo: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var imgChat: UIImageView!
    @IBOutlet weak var viewChat: UIView!

    //User Detail View
    @IBOutlet var viewForUser: UIView!
    @IBOutlet var viewForUserContact: UIView!
    @IBOutlet var imgUserPic: UIImageView!
    @IBOutlet var lblUserName: UILabel!

    @IBOutlet var btnCancelTrip: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var imgCall: UIImageView!

    @IBOutlet var stkEtaAndPayment: UIStackView!

    @IBOutlet var lblEtaOrTotalTime: UILabel!
    @IBOutlet var lblEtaOrTotalTimeValue: UILabel!

    @IBOutlet var lblEtaDistanceOrTotalDistance: UILabel!
    @IBOutlet var lblEtaDistanceOrTotalDistanceValue: UILabel!

    @IBOutlet var stkEarning: UIStackView!
    //Trip and Earning Value
    @IBOutlet var lblTripNo: UILabel!
    @IBOutlet var lblTripNoValue: UILabel!
    @IBOutlet var lblEarning: UILabel!
    @IBOutlet var lblEarningValue: UILabel!

    @IBOutlet var stkWaitTime: UIStackView!
    @IBOutlet var lblWaitingTimeValue: UILabel!
    @IBOutlet var lblWaitingTime: UILabel!

    @IBOutlet weak var stkTime: UIStackView!
    @IBOutlet weak var stkDistance: UIStackView!
    @IBOutlet weak var vwDivider1: UIView!
    @IBOutlet weak var vwDivider2: UIView!

    var tollAmount:Double = 0.0
    var isUpdateLocation: Bool = true
    var isSoundPlay: Bool = false
    var stUserId:String = ""
    var isEtaCalculated: Bool = false

    var nearByTripID = ""
    
    @IBOutlet var btnNavigation: UIButton!
    @IBOutlet var imgNavigation: UIImageView!

    //Action Buttons
    //Accept Reject View
    //Rental Trip View
    @IBOutlet var viewForRentalTrip: UIView!
    @IBOutlet var lblRentalTrip: UILabel!

    @IBOutlet var acceptRejectActionView: UIView!
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var btnReject: UIButton!

    @IBOutlet var tripStatusActionView: UIView!
    @IBOutlet var btnStatus: UIButton!

    @IBOutlet var tripEndStatusActionView: UIView!
    @IBOutlet var btnEndTrip: UIButton!

    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblPaymentValue: UILabel!

    @IBOutlet var lblWaitingTimePayment: UILabel!
    @IBOutlet var lblWaitingTimePaymentValue: UILabel!
    @IBOutlet var imgChatNotification: UIImageView!

    var alertDialog:UIAlertController? = nil;

    var providerMarker:GMSMarker!
    var pickupMarker:GMSMarker!
    var destinationMarker:GMSMarker!
    var onGoingTrip:Trip = Trip.init()

    var providerCurrentStatus:TripStatus = TripStatus.Unknown
    var providerNextStatus:TripStatus = TripStatus.Unknown
    var polyLinePath:GMSPolyline!
    var polyLineCurrentProviderPath:GMSPolyline!;
    var currentProviderPath:GMSMutablePath!
    var previousDriverLatLong:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var isMapFocus: Bool = false
    var isPathCurrentPathDraw: Bool = false
    var soundFile: AVAudioPlayer?
    var isCameraBearingChange: Bool = false
    var mapBearing:Double = 0.0
    var currentWaitingTime:Int = 0
    var totalTripTime:Double = 0.0
    var socketHelper:SocketHelper = SocketHelper.shared
    var isDirectionApiCalled:Bool = false
    var arrTrips: [TripsRespons] = []

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSound()
        imgFavourite.isHidden = true
        socketHelper.connectSocket()
        stkEarning.isHidden = true
        setMap()
        polyLineCurrentProviderPath = GMSPolyline.init()
        polyLinePath = GMSPolyline.init()
        currentProviderPath = GMSMutablePath.init()
        mapView.padding = UIEdgeInsets.init(top:0, left: 20, bottom: 0, right: 20)
        viewForUser.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.revealViewController()?.delegate = self;
        btnEndTrip.addTarget(self, action: #selector(doubleTapToEndTrip(_:event:)), for: UIControl.Event.touchDownRepeat)
        viewForCurrentAddress.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        if ProviderSingleton.shared.tripStaus.trip.id.isEmpty == false { // != nil
            onGoingTrip = ProviderSingleton.shared.tripStaus.trip
        }
        if !ProviderSingleton.shared.nearTripUser.userId.isEmpty {
            self.setUerData()
        }
        mapView.animate(toZoom: 17)
        mapView.animate(toLocation: ProviderSingleton.shared.pickupCoordinate)
        self.stkWaitTime.isHidden = true
        setupRevealViewController()
        initialViewSetup()

        preferenceHelper.setChatName(self.nearByTripID)
        
        MessageHandler.Instace.delegate = self
        MessageHandler.Instace.removeObserver()
        MessageHandler.Instace.observeMessage()
        
        imgChatNotification.isHidden = true
        
//        if self.nearByTripID != "" {
//            self.wsGetTripStatus()
//        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MessageHandler.Instace.delegate = self
        LocationCenter.default.addObserver(self, [#selector(self.locationUpdate(_:)),
                                                  #selector(self.locationFail(_:))])

        //self.addLocationObserver()
        LocationCenter.default.startUpdatingLocation()
        self.animateToCurrentLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.wsGetTripStatus()
            self.startLocationListner()
        }
    }

    //MARK:- Location Methods
    @objc override func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        super.locationUpdate(ntf)

        guard let userInfo = ntf.userInfo else { return }
        guard let location = userInfo["location"] as? CLLocation else { return }
        if self.view.subviews.count > 0 {
            Common.bearing = Common.currentCoordinate.calculateBearing(to: location.coordinate)
            Common.currentCoordinate = location.coordinate
            ProviderSingleton.shared.bearing = Common.currentCoordinate.calculateBearing(to: location.coordinate)
            ProviderSingleton.shared.currentCoordinate = location.coordinate

            self.providerMarker.map = self.mapView
            self.providerMarker.position = ProviderSingleton.shared.currentCoordinate
            self.mapView.animate(toLocation: ProviderSingleton.shared.currentCoordinate)
            self.animateToCurrentLocation()
            self.checkPickupSound()
            self.updateLocation()
        }
    }

    @objc override func locationFail(_ ntf: Notification = Common.defaultNtf) {
        super.locationFail(ntf)
    }

    @objc private func doSomething() {
        MessageHandler.Instace.delegate = self
        print("\(self) \(#function)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.wsGetTripStatus()
            self.startLocationListner()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTripStatusTimer()
        self.stopLocationListner()
    }

    override func networkEstablishAgain() {
        self.wsGetTripStatus()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func startLocationListner() {
        let myTripid = "'\(self.nearByTripID)'"
        self.socketHelper.socket?.off(myTripid)
        self.socketHelper.socket?.on(myTripid) {
            [weak self] (data, ack) in
            guard let `self` = self else { return }
            guard let response = data.first as? [String:Any] else { return }
            let isTripUpdate = (response[PARAMS.IS_TRIP_UPDATED] as? Bool) ?? false
            if isTripUpdate {
                if let newReq = response[PARAMS.NEAR_DESTINATION_TRIP_ID] as? String {
                    if ProviderSingleton.shared.nearTripId != newReq {
                        
                    }
                }
//                self.wsGetTripStatus()
            } else {
                let location = (response["location"] as? [Double]) ?? [0.0,0.0]
                if location[0] != 0.0 && location[1] != 0.0 {
                    //self.onGoingTrip.totalTime = (response["total_time"] as? Double) ?? 0.0
                    //self.totalTripTime = self.onGoingTrip.totalTime.toInt()
                    self.onGoingTrip.totalDistance = (response["total_distance"] as? Double) ?? 0.0
                    let bearing = (response["bearing"] as? Double) ?? 0.0
                    self.onGoingTrip.bearing = bearing
                    self.updateEtaAndTotalDistance()
                }
            }
        }
    }

    func stopLocationListner() {
        let myTripid = "'\(self.nearByTripID)'"
        self.socketHelper.socket?.off(myTripid)
        self.stopTotalTripTimer()
        self.stopWaitingTripTimer()
    }

    func setUerData() {
        lblUserName.text = ProviderSingleton.shared.nearTripUser.firstName + " " + ProviderSingleton.shared.nearTripUser.lastName
        imgUserPic.downloadedFrom(link: ProviderSingleton.shared.nearTripUser.picture)
        let url = ProviderSingleton.shared.tripStaus.mapPinImageUrl
        Utility.downloadImageFrom(link: url, completion: { [weak self](image) in
            self?.providerMarker.icon = image
        })
        btnUserRate.setTitle(ProviderSingleton.shared.nearTripUser.rate.toString(places: 1), for: .normal)
    }

    @IBAction func onClikcBtnRentalInfo(_ sender: Any) {
        self.openRentalTripDialog()
    }

    func updatePaymentView(paymentMode:Int) {
        if onGoingTrip.providerServiceFees > 0.0 && !onGoingTrip.is_trip_bidding {
            lblEarningValue.text = onGoingTrip.providerServiceFees.toCurrencyString()
            stkEarning.isHidden = false
        } else {
            stkEarning.isHidden = true
        }

        if paymentMode == PaymentMode.CARD {
            lblPaymentValue.text = "TXT_CARD".localized
            lblWaitingTimePaymentValue.text = "TXT_CARD".localized
        } else if paymentMode == PaymentMode.CASH {
            lblPaymentValue.text = "TXT_CASH".localized
            lblWaitingTimePaymentValue.text = "TXT_CASH".localized
        } else if paymentMode == PaymentMode.APPLE_PAY {
            lblPaymentValue.text = "TXT_APPLE_PAY".localized
            lblWaitingTimePaymentValue.text = "TXT_APPLE_PAY".localized
        } else {
            lblPaymentValue.text = "TXT_PAYMENT".localized
            lblWaitingTimePaymentValue.text = "TXT_PAYMENT".localized
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    func initialViewSetup() {
        viewForUser.backgroundColor = UIColor.themeViewBackgroundColor.withAlphaComponent(0.95)

        lblPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        lblPickupAddress.textColor = UIColor.themeTextColor
        lblPickupAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)

        lblRentalTrip.text = "TXT_RENTAL_TRIP".localized
        lblRentalTrip.textColor = UIColor.themeWalletDeductedColor
        lblRentalTrip.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        lblTitle.text = "TXT_CAPTION".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor

        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)

        btnCall.setTitle("", for: .normal)
        btnCall.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnCall.backgroundColor = UIColor.themeButtonBackgroundColor
        btnCall.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

//        btnChat.setTitle("", for: .normal)
//        btnChat.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
//        btnChat.backgroundColor = UIColor.themeButtonBackgroundColor
//        btnChat.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

        btnAccept.setTitle("  " + "TXT_ACCEPT".localizedCapitalized + "  ", for: .normal)
        btnAccept.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnAccept.backgroundColor = UIColor.themeButtonBackgroundColor
        btnAccept.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

        btnReject.setTitle("  " + "TXT_REJECT".localizedCapitalized + "  ", for: .normal)
        btnReject.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnReject.backgroundColor = UIColor.themeButtonBackgroundColor
        btnReject.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

        btnEndTrip.setTitle(TripStatus.End.text(), for: .normal)
        btnEndTrip.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnEndTrip.backgroundColor = UIColor.themeButtonBackgroundColor
        btnEndTrip.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

        btnStatus.setTitle("  " + "TXT_ACCEPT".localizedCapitalized + "  ", for: .normal)
        btnStatus.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnStatus.backgroundColor = UIColor.themeButtonBackgroundColor
        btnStatus.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

        if UIScreen.main.bounds.height <= 600 {
            btnTimer.titleLabel?.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        } else {
            btnTimer.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        }
        btnTimer.setTitleColor(UIColor.themeErrorTextColor, for: .normal)
        btnTimer.titleLabel?.adjustsFontSizeToFitWidth = true

        btnCancelTrip.backgroundColor = UIColor.themeButtonBackgroundColor
        btnCancelTrip.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)

        btnUserRate.setTitle("0.0".localized, for: .normal)
        btnUserRate.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnUserRate.setTitleColor(UIColor.themeTextColor, for: .normal)

        lblEtaOrTotalTime.text = "TXT_ESTIMATE_TIME".localized
        lblEtaOrTotalTime.textColor = UIColor.themeLightTextColor
        lblEtaOrTotalTime.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblEtaOrTotalTimeValue.text = "TXT_DEFAULT".localized
        lblEtaOrTotalTimeValue.textColor = UIColor.themeTextColor
        lblEtaOrTotalTimeValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblUserName.text = "TXT_DEFAULT".localized
        lblUserName.textColor = UIColor.themeTextColor
        lblUserName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblEtaDistanceOrTotalDistance.text = "TXT_ESTIMATE_DISTANCE".localized
        lblEtaDistanceOrTotalDistance.textColor = UIColor.themeLightTextColor
        lblEtaDistanceOrTotalDistance.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblEtaDistanceOrTotalDistanceValue.text = "TXT_DEFAULT".localized
        lblEtaDistanceOrTotalDistanceValue.textColor = UIColor.themeTextColor
        lblEtaDistanceOrTotalDistanceValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblPayment.text = "TXT_PAYMENT_IN".localized
        lblPayment.textColor = UIColor.themeLightTextColor
        lblPayment.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblPaymentValue.text = "TXT_DEFAULT".localized
        lblPaymentValue.textColor = UIColor.themeTextColor
        lblPaymentValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblWaitingTimePayment.text = "TXT_PAYMENT_IN".localized
        lblWaitingTimePayment.textColor = UIColor.themeLightTextColor
        lblWaitingTimePayment.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblWaitingTimePaymentValue.text = "TXT_DEFAULT".localized
        lblWaitingTimePaymentValue.textColor = UIColor.themeTextColor
        lblWaitingTimePaymentValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblTripNo.text = "TXT_TRIP_NO".localized
        lblTripNo.textColor = UIColor.themeLightTextColor
        lblTripNo.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblWaitingTime.text = "TXT_WAITING_TIME_START_AFTER".localized
        lblWaitingTime.text = "TXT_TOTAL_WAITING_TIME".localized
        lblWaitingTime.textColor = UIColor.themeTextColor
        lblWaitingTime.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)

        lblWaitingTimeValue.text = "--".localized
        lblWaitingTimeValue.textColor = UIColor.themeTextColor
        lblWaitingTimeValue.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)

        lblTripNoValue.text = "TXT_TRIP_NO".localized
        lblTripNoValue.textColor = UIColor.themeTextColor
        lblTripNoValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblEarning.text = "TXT_EARN".localized
        lblEarning.textColor = UIColor.themeLightTextColor
        lblEarning.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblEarningValue.text = "TXT_DEFAULT".localized
        lblEarningValue.textColor = UIColor.themeTextColor
        lblEarningValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

//        self.btnChat.setTitle(FontAsset.icon_chat, for: .normal)
//        self.btnChat.setRoundIconButton()

//        self.btnCall.setTitle(FontAsset.icon_call, for: .normal)
//        self.btnCall.setRoundIconButton()
//        btnCurrentLocation.setTitle(FontAsset.icon_btn_current_location, for: .normal)
//        btnCurrentLocation.setSimpleIconButton()
//        btnCurrentLocation.titleLabel?.font = FontHelper.assetFont(size:30)
        btnCurrentLocation.setImage(UIImage(named: "asset-pin-current-location"), for: .normal)
//        btnMenu.setTitle(FontAsset.icon_menu, for: .normal)
//        btnMenu.setUpTopBarButton()
        imgMenu.tintColor = UIColor.themeImageColor
//        lblIconInfo.text = FontAsset.icon_info
//        lblIconInfo.setForIcon(color: UIColor.white)
//        lblIconInfo.backgroundColor = UIColor.themeImageColor
//        lblIconInfo.layer.cornerRadius = lblIconInfo.frame.height/2
//        lblIconInfo.clipsToBounds = true

//        lblIconLocation.text = FontAsset.icon_location
//        lblIconLocation.setForIcon()
        imgIconLocation.tintColor = UIColor.themeImageColor
//        btnNavigation.setTitle(FontAsset.icon_navigation, for: .normal)
//        btnNavigation.setUpTopBarButton()
        imgNavigation.tintColor = UIColor.themeImageColor
    }

    func setMap() {
        mapView.clear()
        mapView.delegate = self
        mapView.delegate=self;
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;
        mapView.settings.rotateGestures = false;
        mapView.settings.myLocationButton=false;
        mapView.isMyLocationEnabled=false;
        providerMarker = GMSMarker.init()
        providerMarker.icon = UIImage(named: "asset-driver-pin-placeholder")
        providerMarker.map = mapView
        
        pickupMarker = GMSMarker.init()
        destinationMarker = GMSMarker.init()
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "styleable_map", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
    }

    func setupLayout() {
        btnCancelTrip.setRound()
        
        /*btnCall.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnCall.frame.height/2, borderWidth: 1.0)
         btnChat.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnCall.frame.height/2, borderWidth: 1.0)*/
        
        btnAccept.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnAccept.frame.height/2, borderWidth: 1.0)
        btnReject.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnReject.frame.height/2, borderWidth: 1.0)
        btnStatus.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnStatus.frame.height/2, borderWidth: 1.0)
        btnEndTrip.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnEndTrip.frame.height/2, borderWidth: 1.0)
        viewForCurrentAddress.navigationShadow()
        viewForPickupDestinationAddress.navigationShadow()
        imgUserPic.setRound()
    }
    
    @IBAction func onClickBtnAccept(_ sender: Any) {
        if onGoingTrip.is_trip_bidding {
            openTripBiddingDialog(price: onGoingTrip.bid_price)
        } else {
            self.wsAcceptTrip()
        }
    }
    @IBAction func onClickBtnReject(_ sender: Any) {
        self.wsRejectTrip()
    }
    
    @IBAction func onClickBtnNavigation(_ sender: Any) {
        let alertVC: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        if alertDialog == nil {
            alertDialog = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let googleMap = UIAlertAction(title: NSLocalizedString("TXT_GOOGLE_MAP".localized, comment: ""), style: .default, handler: { [unowned self] action in
                self.gotoGoogleMap()
            })
            let WazeMap = UIAlertAction(title: NSLocalizedString("TXT_WAZE_MAP".localized, comment: ""), style: .default, handler: { [unowned self] action in
                self.gotoWazeMap()
            })
            let cancel = UIAlertAction(title: NSLocalizedString("TXT_CANCEL".localized, comment: ""), style: .destructive, handler: { [unowned self] action in
                self.alertDialog = nil
            })
            self.alertDialog!.addAction(googleMap)
            self.alertDialog!.addAction(WazeMap)
            self.alertDialog!.addAction(cancel)
            alertVC?.present(alertDialog!, animated: true) {
                self.alertDialog = nil
            }
        }
    }
    
    func gotoGoogleMap() {
        var strUrl = ""
        if (onGoingTrip.isProviderStatus < TripStatus.Arrived.rawValue) {
            strUrl = "daddr=\(onGoingTrip.sourceAddress)&directionsmode=driving"
        } else {
            if (onGoingTrip.destinationAddresses.count == 0) {
                Utility.showToast(message: "VALIDATION_MSG_DEST_ADDRESS_NOT_AVAILABLE".localized)
            } else {
                let tempArr = self.onGoingTrip.destinationAddresses.last
                strUrl = "daddr=\(tempArr?.address ?? "")&directionsmode=driving"
            }
        }

        if !strUrl.isEmpty {
            let escapedString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            strUrl = escapedString?.replacingOccurrences(of: "%20", with: "+") ?? ""
            
            if let url = URL(string: "comgooglemaps://") {
                if UIApplication.shared.canOpenURL(url) {
                    if let url = URL(string: "comgooglemaps://?" + (strUrl)) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                    Utility.showToast(message: "VALIDATION_MSG_GOOGLE_MAP_NOT_AVAILABLE".localized)
                }
            }
        }
    }
    
    func gotoWazeMap() {
        if let url = URL(string: "waze://") {
            if UIApplication.shared.canOpenURL(url) {
                var wazeLat = ""
                var wazeLong = ""
                var strUrl = ""
                if (onGoingTrip.isProviderStatus < TripStatus.Arrived.rawValue) {
                    wazeLat = onGoingTrip.sourceLocation[0].toString(places: 6)
                    wazeLong = onGoingTrip.sourceLocation[1].toString(places: 6)
                    strUrl = "waze://?ll=\(Double(wazeLat) ?? 0.0),\(Double(wazeLong) ?? 0.0)&navigate=yes"
                }else {
                    if (onGoingTrip.destinationAddresses.count == 0) {
                        Utility.showToast(message: "VALIDATION_MSG_DEST_ADDRESS_NOT_AVAILABLE".localized)
                    } else {
                        let tempArr = self.onGoingTrip.destinationAddresses.last
                        wazeLat = (tempArr?.location[0].toString(places: 6))!
                        wazeLong = (tempArr?.location[1].toString(places: 6))!
                        strUrl = "waze://?ll=\(wazeLat),\(wazeLong)&navigate=yes"
                    }
                }
                if !strUrl.isEmpty {
                    if let url = URL(string: strUrl) {
                        UIApplication.shared.open(url, completionHandler: { [unowned self] (success) in
                            
                        })
                    }
                }
            } else {
                Utility.showToast(message: "VALIDATION_MSG_WAZE_MAP_NOT_AVAILABLE".localized)
            }
        }
    }

    @IBAction func onClickBtnSetTripStatus(_ sender: Any) {
        self.wsSetTripStatus()
    }

    @IBAction func onClickBtnCancelTrip(_ sender: Any) {
        Utility.getCancellationReasons { [weak self] response in
            self?.openCanceTripDialog(arrReason: response)
        }
    }

    @IBAction func onClickBtnFocusTrip(_ sender: Any) {
        isCameraBearingChange = false
        focusMap()
    }

    @IBAction func onClickBtnCall(_ sender: Any) {
        if preferenceHelper.getIsTwillioEnable() {
            btnCall.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] (time) in
                self?.btnCall.isEnabled = true
            }
            wsTwilioVoiceCall()
        } else {
            ProviderSingleton.shared.nearTripUser.phone.toCall()
        }
    }

    func updateAddress() {
        let trip = ProviderSingleton.shared.tripStaus.trip
        lblPickupAddress.text = trip.sourceAddress
        let tempArr = self.onGoingTrip.destinationAddresses.last
        lblDestinationAddress.text  = tempArr?.address
    }

    func updateMarkers() {
        if onGoingTrip.destinationAddresses.count > 0 {
            let tempArr = self.onGoingTrip.destinationAddresses.last
            if tempArr?.location[0] != 0.0 && tempArr?.location[1] != 0.0 {
                destinationMarker.position = CLLocationCoordinate2D.init(latitude: (tempArr?.location[0])!, longitude: (tempArr?.location[1])!)
                destinationMarker.icon = UIImage.init(named: "asset-pin-destination-location")
                if destinationMarker.map == nil {
                    destinationMarker.map = mapView
                }
            }
        }
        if !onGoingTrip.sourceLocation.isEmpty {
            if onGoingTrip.sourceLocation[0] != 0.0 && onGoingTrip.sourceLocation[1] != 0.0 {
                pickupMarker.position = CLLocationCoordinate2D.init(latitude: onGoingTrip.sourceLocation[0], longitude: onGoingTrip.sourceLocation[1])
                pickupMarker.icon = UIImage.init(named: "asset-pin-pickup-location")
                if pickupMarker.map == nil {
                    pickupMarker.map = mapView
                }
            }
        }
        if ProviderSingleton.shared.currentCoordinate.latitude != 0.0 && ProviderSingleton.shared.currentCoordinate.longitude != 0.0 {
            let providerPrevioustLocation = providerMarker.position
            
            providerMarker.position = ProviderSingleton.shared.currentCoordinate
            
            if providerMarker.map == nil {
                providerMarker.map = mapView
                mapView.animate(toLocation: providerMarker.position)
                mapView.animate(toZoom: 17)
            }
            
            if providerCurrentStatus == TripStatus.Coming || providerCurrentStatus == TripStatus.Accepted {
                isCameraBearingChange = true;
                mapBearing = self.calculateBearing(source: providerPrevioustLocation, to: providerMarker.position)
            }else if providerCurrentStatus == TripStatus.Arrived || providerCurrentStatus == TripStatus.Started {
                isCameraBearingChange = true;
                mapBearing = self.calculateBearing(source: providerPrevioustLocation, to: providerMarker.position)
            }else {
                isCameraBearingChange = false;
            }
            if (isCameraBearingChange) {
                CATransaction.begin()
                CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock {
                    self.drawCurrentPath(driverCoordinate:  self.providerMarker.position)
                }
                mapView.animate(toBearing: mapBearing)
                mapView.animate(toLocation: providerMarker.position)
                mapView.animate(toZoom: 17)
                CATransaction.commit()
            }
        }
    }

    func calculateBearing(source:CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
        let lat1 = Double.pi * source.latitude / 180.0
        let long1 = Double.pi * source.longitude / 180.0
        let lat2 = Double.pi * destination.latitude / 180.0
        let long2 = Double.pi * destination.longitude / 180.0
        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }

    func showPathFrom(source:CLLocationCoordinate2D, toDestination destination:CLLocationCoordinate2D) {
        if preferenceHelper.getIsPathdraw() {
            let saddr = "\(source.latitude),\(source.longitude)"
            let daddr = "\(destination.latitude),\(destination.longitude)"
            let apiUrlStr = Google.DIRECTION_URL + "\(saddr)&destination=\(daddr)&key=\(preferenceHelper.getGoogleKey())"
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            guard let url =  URL(string: apiUrlStr) else {
                return
            }
            do {
                DispatchQueue.main.async {
                    session.dataTask(with: url) { [unowned self] (data, response, error) in
                        guard data != nil else {
                            return
                        }
                        do {
                            let route = try JSONDecoder().decode(MapPath.self, from: data!)
                            if let points = route.routes?.first?.overview_polyline?.points {
                                switch(self.onGoingTrip.isProviderStatus)
                                {
                                case TripStatus.Started.rawValue, TripStatus.Arrived.rawValue :
                                    self.wsSetGooglePathPickupToDestination(route: String.init(data: data!, encoding: .utf8) ?? "")
                                    break;
                                default:
                                    break;
                                }
                                self.drawPath(with: points)
                            }
                        } catch let error {
                            print("Failed to draw",error.localizedDescription)
                        }
                    }.resume()
                }
            }
        }
    }

    private func drawPath(with points : String) {
        DispatchQueue.main.async {
            if self.polyLinePath.map != nil {
                self.polyLinePath.map = nil
            }
            let path = GMSPath(fromEncodedPath: points)
            self.polyLinePath = GMSPolyline(path: path)
            self.polyLinePath.strokeColor = UIColor.themeGooglePathColor
            self.polyLinePath.strokeWidth = 5.0
            self.polyLinePath.geodesic = true
            self.polyLinePath.map = self.mapView
        }
    }

    func drawCurrentPath(driverCoordinate:CLLocationCoordinate2D) {
        if (/*isPathCurrentPathDraw && */providerCurrentStatus == TripStatus.Started) {
            let previousLocation = CLLocation.init(latitude: self.previousDriverLatLong.latitude, longitude: self.previousDriverLatLong.longitude)
            let currentLocation = CLLocation.init(latitude:driverCoordinate.latitude, longitude: driverCoordinate.longitude)

            let distance:Float = Float(previousLocation.distance(from:currentLocation ))

            let tempPath:GMSMutablePath = GMSMutablePath.init()

            if (previousDriverLatLong.latitude != 0.0 && previousDriverLatLong.longitude != 0.0) {
                tempPath.add(previousDriverLatLong)
            }
            tempPath.add(driverCoordinate)
            DispatchQueue.main.async {
                self.polyLineCurrentProviderPath = GMSPolyline.init(path: tempPath)
                self.polyLineCurrentProviderPath.strokeWidth = 5.0;
                self.polyLineCurrentProviderPath.strokeColor = UIColor.themeButtonBackgroundColor
                self.polyLineCurrentProviderPath.map = self.mapView;
                self.polyLineCurrentProviderPath.zIndex = Int32.max
                self.previousDriverLatLong = driverCoordinate;
            }
        }
    }

    @IBAction func onClickBtnChat(_ sender: Any) {
        if let chatVc:MyCustomChatVC =  AppStoryboard.Trip.instance.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC {
            imgChatNotification.isHidden = true
            self.navigationController?.pushViewController(chatVc, animated: true)
        }
    }

    func updateUIForNewTrip() {
        btnNavigation.isHidden = true
        btnTimer.isHidden = false
        //stkvwNavigationRightButtonsWidth.constant = 100
        tripStatusActionView.isHidden = true
        tripEndStatusActionView.isHidden = true
        acceptRejectActionView.isHidden = false

        self.startTimerForAcceptReject()
        if onGoingTrip.sourceLocation[0] != 0.0 && ProviderSingleton.shared.currentCoordinate.latitude != 0.0 {
            calculateEta()
        }
    }
    
    func updateUIForTripStatus() {
        tripStatusActionView.isHidden = false
        tripEndStatusActionView.isHidden = true
        acceptRejectActionView.isHidden = true
    }
    
    func updatatUIForEndTrip() {
        tripEndStatusActionView.isHidden = false
        tripStatusActionView.isHidden = true
        acceptRejectActionView.isHidden = true
    }

    func updateUIForWaitingTime() {
        if ProviderSingleton.shared.tripStaus.priceForWaitingTime > 0.0 && (onGoingTrip.isFixedFare == false) {
            if(self.onGoingTrip.isProviderStatus == TripStatus.Arrived.rawValue) {
                startWaitingTripTimer()
            } else {
                stopWaitingTripTimer()
            }
        }
    }

    func updateTripDetail() {
        lblTripNoValue.text = onGoingTrip.uniqueId.toString()
        viewForRentalTrip.isHidden = onGoingTrip.carRentalId.isEmpty()

        if (onGoingTrip.isProviderAccepted != ProviderStatus.Accepted.rawValue) {
            imgLocation.isHighlighted = false
//            lblIconLocation.text = FontAsset.icon_pickup_location
            imgIconLocation.image = UIImage(named: "asset-pin-pickup-location")
            lblTitle.text = "TXT_CAPTION".localizedCapitalized
            lblCurrentAddress.text = onGoingTrip.sourceAddress
            viewForPickupDestinationAddress.isHidden = false
            viewForCurrentAddress.isHidden = true
        } else if (onGoingTrip.isProviderStatus == TripStatus.Accepted.rawValue || onGoingTrip.isProviderStatus == TripStatus.Coming.rawValue) {
            lblTitle.text = "TXT_PICKUP_ADDRESS".localized
            lblCurrentAddress.text = onGoingTrip.sourceAddress
            imgLocation.isHighlighted = false
//            lblIconLocation.text = FontAsset.icon_pickup_location
            imgIconLocation.image = UIImage(named: "asset-pin-pickup-location")
            viewForCurrentAddress.isHidden = false
            viewForPickupDestinationAddress.isHidden = true
        } else {
            imgLocation.isHighlighted = true
            lblTitle.text = "TXT_DESTINATION_ADDRESS".localized
//            lblIconLocation.text = FontAsset.icon_destination
            imgIconLocation.image = UIImage(named: "asset-pin-destination-location")
            if onGoingTrip.destinationAddresses.count == 0 {
                lblCurrentAddress.text = "VALIDATION_MSG_DEST_ADDRESS_NOT_AVAILABLE".localized
            } else {
                let tempArr = self.onGoingTrip.destinationAddresses.last
                lblCurrentAddress.text = tempArr?.address
            }
            viewForCurrentAddress.isHidden = false
            viewForPickupDestinationAddress.isHidden = true
        }
        updateEtaAndTotalTime()
    }

    func startTripStatusTimer() {
        ProviderSingleton.shared.timerUpdateLocation?.invalidate()
        ProviderSingleton.shared.timerUpdateLocation = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(watchTimer), userInfo: nil, repeats: true)
    }

    func stopTripStatusTimer() {
        ProviderSingleton.shared.timerUpdateLocation?.invalidate()
    }

    @objc func watchTimer() {
        self.wsGetTripStatus()
    }

    fileprivate func calculateEta() {
        if preferenceHelper.getIsShowEta() {
            if isEtaCalculated == false {
                LocationCenter.default.getTimeAndDistance(sourceCoordinate: ProviderSingleton.shared.currentCoordinate, destCoordinate: CLLocationCoordinate2DMake(onGoingTrip.sourceLocation[0], onGoingTrip.sourceLocation[1]), unit: "") { [weak self] (time, distance) in
                    guard let self = self else { return }
                    self.lblEtaOrTotalTimeValue.text = (time.toDouble() / 60).toString(places: 2) + MeasureUnit.MINUTES

                    self.lblEtaOrTotalTime.text = "TXT_ESTIMATE_TIME".localized
                    self.lblEtaDistanceOrTotalDistance.text = "TXT_ESTIMATE_DISTANCE".localized

                    Utility.distanceFrom(meters:distance.toDouble(), unit: self.onGoingTrip.unit) { [weak self] (distance) in
                        guard let self = self else { return }
                        self.lblEtaDistanceOrTotalDistanceValue.text = distance
                    }
                }
            }
            isEtaCalculated = true
            self.stkEtaAndPayment.isHidden = false
            self.stkWaitTime.isHidden = true
        } else {
            updateUIForEta(isHideEta: true)
            self.stkWaitTime.isHidden = true
        }
    }

    func checkPickupSound() {
         if providerCurrentStatus == TripStatus.Coming {
            let currentLocation: CLLocation = CLLocation.init(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude)
            let pickupLocation: CLLocation = CLLocation.init(latitude: onGoingTrip.sourceLocation[0], longitude: onGoingTrip.sourceLocation[1])
            let distance:Float = Float(pickupLocation.distance(from: currentLocation))
            if distance <= 300 && self.providerCurrentStatus == TripStatus.Coming {
                if self.isSoundPlay == false && preferenceHelper.getIsPickupAlertSoundOn() == true {
                    self.isSoundPlay = true
                    self.setUpSound()
                    self.playSound()
                }
            } else {
                self.isSoundPlay = false
            }
        }
    }

    func updateUIForEta(isHideEta:Bool) {
        stkTime.isHidden = isHideEta
        stkDistance.isHidden = isHideEta
        vwDivider1.isHidden = isHideEta
        vwDivider2.isHidden = isHideEta
    }

    func updateEtaAndTotalTime() {
        if onGoingTrip.isProviderAccepted == TRUE {
            btnNavigation.isHidden = false
            btnTimer.isHidden = true
            //stkvwNavigationRightButtonsWidth.constant = 44
            if providerCurrentStatus == TripStatus.Accepted || providerCurrentStatus == TripStatus.Coming {
                lblEtaOrTotalTime.text = "TXT_ESTIMATE_TIME".localized
                lblEtaDistanceOrTotalDistance.text = "TXT_ESTIMATE_DISTANCE".localized
                btnCancelTrip.isHidden = false
                if onGoingTrip.sourceLocation[0] != 0.0 && ProviderSingleton.shared.currentCoordinate.latitude != 0.0 {
                    calculateEta()
                }
            } else if (providerCurrentStatus == TripStatus.Arrived ) {
                self.updateUIForWaitingTime()
            } else {
                totalTripTime = onGoingTrip.totalTime
                lblEtaOrTotalTime.text = "TXT_TOTAL_TIME".localized
                lblEtaDistanceOrTotalDistance.text = "TXT_TOTAL_DISTANCE".localized
                lblEtaOrTotalTimeValue.text = totalTripTime.toString(places: 2) + MeasureUnit.MINUTES
                startTotalTripTimer()

                lblEtaDistanceOrTotalDistanceValue.text = onGoingTrip.totalDistance.toString(places: 2   ) + Utility.getDistanceUnit(unit: onGoingTrip.unit)
                btnCancelTrip.isHidden = true
                stkWaitTime.isHidden = true
                updateUIForEta(isHideEta: false)
                stkEtaAndPayment.isHidden = false
            }
        }
    }

    func updateEtaAndTotalDistance() {
        if onGoingTrip.isProviderAccepted == TRUE {
            btnNavigation.isHidden = false
            btnTimer.isHidden = true
            //stkvwNavigationRightButtonsWidth.constant = 44
            if providerCurrentStatus == TripStatus.Accepted || providerCurrentStatus == TripStatus.Coming {
                lblEtaOrTotalTime.text = "TXT_ESTIMATE_TIME".localized
                lblEtaDistanceOrTotalDistance.text = "TXT_ESTIMATE_DISTANCE".localized
                btnCancelTrip.isHidden = false
                if onGoingTrip.sourceLocation[0] != 0.0 && ProviderSingleton.shared.currentCoordinate.latitude != 0.0 {
                    calculateEta()
                }
            } else if (providerCurrentStatus == TripStatus.Arrived ) {
                self.updateUIForWaitingTime()
            } else {
                lblEtaOrTotalTime.text = "TXT_TOTAL_TIME".localized
                lblEtaDistanceOrTotalDistance.text = "TXT_TOTAL_DISTANCE".localized
                lblEtaOrTotalTimeValue.text = totalTripTime.toString(places: 2) + MeasureUnit.MINUTES
                lblEtaDistanceOrTotalDistanceValue.text = onGoingTrip.totalDistance.toString(places: 2) + Utility.getDistanceUnit(unit: onGoingTrip.unit)
                btnCancelTrip.isHidden = true
                stkEtaAndPayment.isHidden = false
                updateUIForEta(isHideEta: false)
            }
        }
    }
}

//MARK: - RevealViewController Delegate Methods
extension NearByTripVC:PBRevealViewControllerDelegate {

    @IBAction func onClickBtnMenu(_ sender: Any) {
    }
    
    func setupRevealViewController() {
        self.revealViewController()?.panGestureRecognizer?.isEnabled = true
        btnMenu.addTarget(self.revealViewController(), action: #selector(PBRevealViewController.revealLeftView), for: .touchUpInside)
    }

    func revealController(_ revealController: PBRevealViewController, willShowLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = false;
    }

    func revealController(_ revealController: PBRevealViewController, willHideLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = true;
    }
}

//MARK: - Dialogs
extension NearByTripVC {
    func openTwillioNotificationDialog() {
        let dialogForTwillioCall = CustomStatusDialog.showCustomStatusDialog(message: "TXT_CALL_MESSAGE".localized, titletButton: "TXT_CLOSE".localized)
        dialogForTwillioCall.onClickOkButton = { [unowned dialogForTwillioCall] in
            dialogForTwillioCall.removeFromSuperview();
        }
    }

    func openRentalTripDialog() {
        let dialogForSelectRentPackage = CustomRentCarDialog.showCustomRentCarDialog(title: "TXT_PACKAGES".localized, message: "", titleRightButton: "TXT_OK".localized)
        dialogForSelectRentPackage.onClickRightButton = { [unowned dialogForSelectRentPackage] in
            dialogForSelectRentPackage.removeFromSuperview()
        }
    }

    func openCanceTripDialog(arrReason: [String]) {
        let dialogForTripStatus = CustomCancelTripDialog.showCustomCancelTripDialog(title: "TXT_CANCEL_TRIP".localized, message: "TXT_CANCELLATION_CHARGE_MESSAGE".localized, cancelationCharge: "0", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        if onGoingTrip.isProviderStatus == TripStatus.Arrived.rawValue {}
        dialogForTripStatus.arrReason = arrReason
        dialogForTripStatus.onClickLeftButton = { [unowned dialogForTripStatus] in
            dialogForTripStatus.removeFromSuperview();
        }

        dialogForTripStatus.onClickRightButton = { [unowned self, unowned dialogForTripStatus] (reason) in
            self.wsCancelTrip(dialog: dialogForTripStatus,reason: reason)
        }
    }

    func openSosDialog() {
        let dialogForSos = CustomSosDialog.showCustomSosDialog(title: "TXT_SOS".localized, message: "10", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SEND".localized)
        dialogForSos.onClickLeftButton = { [unowned dialogForSos] in
            dialogForSos.stopTimer()
            dialogForSos.removeFromSuperview();
        }
        dialogForSos.onClickRightButton = { [unowned dialogForSos] in
            dialogForSos.stopTimer()
            dialogForSos.removeFromSuperview();
        }
    }

    func openTollDialog() {
        self.view.endEditing(true)

        let dialogForToll = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_TOTAL_TOLL".localized, message: "".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_APPLY".localized, editTextHint: "TXT_TOLL_AMOUNT".localized,  editTextInputType: false)
        dialogForToll.editText.keyboardType = .decimalPad
        _ = dialogForToll.editText.becomeFirstResponder()

        dialogForToll.onClickLeftButton = { [weak self] in
            LocationCenter.default.getAddressFromLatitudeLongitude(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude, completion: { (address, locations) in
                dialogForToll.removeFromSuperview();
                self?.wsCheckDestinationAddress(address:address, latitude: locations[0], longitude: locations[1])
            })
        }

        dialogForToll.onClickRightButton = { [weak self] (text:String) in
            if text.toDouble() != 0.0 {
                self?.tollAmount = text.toDouble()
                LocationCenter.default.getAddressFromLatitudeLongitude(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude, completion: { [unowned self] (address, locations) in
                    dialogForToll.removeFromSuperview()
                    self?.wsCheckDestinationAddress(address:address, latitude: locations[0], longitude: locations[1])
                })
            } else {
                Utility.showToast(message: "VALIDATION_MSG_INVALID_AMOUNT".localized)
            }
        }
    }
    
    func openTripBiddingDialog(price: Double) {
        let dialog = TripBiddingDialog.showDialog(price: price)
        dialog.onClickLeftButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
        dialog.onClickRightButton = { [weak self] dialog in
            guard let self = self else { return }
            self.wsAcceptTrip(dialog: dialog)
        }
        dialog.onClickBtnChange = { [weak self] dialog in
            guard let self = self else { return }
            self.wsAcceptTrip(bidPrice: Double(dialog.editText.text!)!,dialog: dialog)
        }
    }
}

extension NearByTripVC {
    func updateLocation() {
        if ProviderSingleton.shared.currentCoordinate.latitude != 0.0 && ProviderSingleton.shared.currentCoordinate.longitude != 0.0 {
            let dictParam:[String:Any] =
                [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                 PARAMS.TOKEN : preferenceHelper.getSessionToken(),
                 PARAMS.TRIP_ID : self.nearByTripID,
                 PARAMS.LATITUDE : ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),
                 PARAMS.LONGITUDE : ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6),
                 PARAMS.BEARING :ProviderSingleton.shared.bearing,
                 Google.LOCATION : APPDELEGATE.fetchLocationFromDB()]
            if Connectivity.isConnectedToInternet {
                if self.socketHelper.socket?.status == .connected {
                    if self.isUpdateLocation {
                        self.isUpdateLocation = false
                        self.socketHelper.socket?.emitWithAck(self.socketHelper.locationEmit, dictParam).timingOut(after: 0) { [weak self] data in
                            guard let self = self else { return }
                            guard let response = data.first as? [String:Any] else { return }
                            let jsonData = try? JSONSerialization.data(withJSONObject:response)
                            if Parser.isSuccess(response: response, data: jsonData) {
                                if let totalTime = (response["total_time"] as? Double) {
                                    self.onGoingTrip.totalTime = totalTime
                                }
                                if let totalDistance = (response["total_distance"] as? Double) {
                                    self.onGoingTrip.totalDistance = totalDistance
                                }

                                self.isUpdateLocation = true
                                APPDELEGATE.clearEntity()
                            }
                        }
                    }
                } else {
                    self.socketHelper.socket?.connect()
                    self.isUpdateLocation = true
                }
            } else {
                APPDELEGATE.addLocationToDb()
            }
        }
    }

    func animateToCurrentLocation() {
        let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17.0, bearing: ProviderSingleton.shared.bearing, viewingAngle: 0.0)
        self.mapView.animate(to: camera)
        mapView.animate(toBearing: Common.bearing)
        self.providerMarker.position = position
        if (self.providerCurrentStatus == TripStatus.Started) {
            drawCurrentPath(driverCoordinate: position)
        }
    }

    func focusMap() {
        let pickupLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: onGoingTrip.sourceLocation[0], longitude: onGoingTrip.sourceLocation[1])
        
        let tempArr = self.onGoingTrip.destinationAddresses.last
        let destinationLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: (tempArr?.location[0])!, longitude: (tempArr?.location[1])!)
        let driverLocation:CLLocationCoordinate2D = ProviderSingleton.shared.currentCoordinate

        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(driverLocation)
        if self.providerCurrentStatus == .Accepted || self.providerCurrentStatus == .Coming {
            bounds = bounds.includingCoordinate(pickupLocation)
            mapBearing = self.calculateBearing(source: driverLocation, to: pickupLocation)
        } else {
            if destinationLocation.latitude != 0.0 && destinationLocation.longitude != 0.0 {
                bounds = bounds.includingCoordinate(destinationLocation)
                mapBearing = self.calculateBearing(source: providerMarker.position, to: destinationLocation)
            } else {
                mapBearing = self.calculateBearing(source: driverLocation, to: driverLocation)
            }
        }

        isCameraBearingChange = true;
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {
            self.drawCurrentPath(driverCoordinate: driverLocation)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
        mapView.animate(toBearing: mapBearing)
        isCameraBearingChange = false
        CATransaction.commit()
    }
}

//MARK: - Web Service Calls
extension NearByTripVC {
    func wsUpdateLocation() {
        if preferenceHelper.getSessionToken().isEmpty {
            return;
        } else {
            if ProviderSingleton.shared.currentCoordinate.latitude != 0.0 && ProviderSingleton.shared.currentCoordinate.longitude != 0.0 {
                let dictParam:[String:Any] =
                    [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                     PARAMS.TOKEN : preferenceHelper.getSessionToken(),
                     PARAMS.TRIP_ID : self.nearByTripID,
                     PARAMS.LATITUDE : ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),
                     PARAMS.LONGITUDE : ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6),
                     PARAMS.BEARING :ProviderSingleton.shared.bearing,
                     Google.LOCATION : APPDELEGATE.fetchLocationFromDB()]

                if Connectivity.isConnectedToInternet {
                    let afh:AlamofireHelper = AlamofireHelper.init()
                    afh.getResponseFromURL(url: WebService.UPDATE_LOCATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
                        if Parser.isSuccess(response: response, data: data) {
                            APPDELEGATE.clearEntity()
                        } else {}
                    }
                } else {
                    APPDELEGATE.addLocationToDb()
                }
            }
        }
    }

    func wsGetGooglePath() {
        
        let tempArr = self.onGoingTrip.destinationAddresses.last
        
        if tempArr?.location[0] != 0.0 && tempArr?.location[1] != 0.0 && preferenceHelper.getIsPathdraw() {
            Utility.showLoading()

            var dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = onGoingTrip.id

            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.GET_GOOGLE_PATH_FROM_SERVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data,error) -> (Void) in
                if (error != nil) {
                    Utility.hideLoading()
                } else {
                    if Parser.isSuccess(response: response,data: data) {
                        let googleResponse:GooglePathResponse = GooglePathResponse.init(fromDictionary: response)
                        var path = ""
                        let tripLocations = googleResponse.triplocation

                        if self.providerCurrentStatus == TripStatus.Arrived || self.providerCurrentStatus == TripStatus.Started {
                            path = (tripLocations?.googlePickUpLocationToDestinationLocation) ?? ""
                            let data: Data? = path.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                            if data != nil && !path.isEmpty() {
                                do {
                                    let route = try JSONDecoder().decode(MapPath.self, from: data!)
                                    if let points = route.routes?.first?.overview_polyline?.points {
                                        self.drawPath(with: points)
                                    }
                                } catch {
                                    print("error in JSONSerialization")
                                }
                            } else {
                                if tempArr?.location[0] != 0.0 && tempArr?.location[1] != 0.0 && !self.isDirectionApiCalled {
                                    self.isDirectionApiCalled = true
                                    self.showPathFrom(source: self.pickupMarker.position, toDestination: self.destinationMarker.position)
                                }
                            }
                            
                            if (self.providerCurrentStatus == TripStatus.Started) {
                                let startToEndTripLocation = googleResponse.triplocation.startTripToEndTripLocations
                                if (self.isPathCurrentPathDraw) {} else {
                                    if ((startToEndTripLocation?.count ?? 0) > 0) {
                                        self.currentProviderPath = GMSMutablePath.init()
                                        for currentLocation in startToEndTripLocation ?? [] {
                                            if let location = currentLocation as? [Any] {
                                                let currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: (location[0] as? Double) ?? 0.0, longitude: (location[1] as? Double) ?? 0.0)
                                                self.currentProviderPath.add(currentCoordinate)
                                                self.previousDriverLatLong = currentCoordinate
                                            }
                                        }
                                        self.polyLineCurrentProviderPath = GMSPolyline.init(path: self.currentProviderPath)
                                        self.polyLineCurrentProviderPath.strokeWidth = 5.0;
                                        self.polyLineCurrentProviderPath.strokeColor = UIColor.themeButtonBackgroundColor;
                                        self.polyLineCurrentProviderPath.map = self.mapView;
                                        self.isPathCurrentPathDraw = true;
                                    }
                                }
                            }
                        } else if self.providerCurrentStatus == TripStatus.Coming {
                            path = (tripLocations?.googlePathStartLocationToPickUpLocation) ?? ""
                            let _: Data? = path.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        }
                        Utility.hideLoading()
                    }
                }
            }
        }
    }

    func wsSetGooglePathStartToPickup(route:String = "") {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.GOOGLE_PATH_START_LOCATION_TO_PICKUP_LOCATION] = route
        dictParam[PARAMS.GOOGLE_PICKUP_LOCATION_TO_DESTINATION_LOCATION] = ""

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SET_GOOGLE_PATH_FROM_SERVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data,error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data) {
                    Utility.hideLoading()
                }
            }
        }
    }

    func wsSetGooglePathPickupToDestination(route:String = "") {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.GOOGLE_PATH_START_LOCATION_TO_PICKUP_LOCATION] = ""
        dictParam[PARAMS.GOOGLE_PICKUP_LOCATION_TO_DESTINATION_LOCATION] = route

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SET_GOOGLE_PATH_FROM_SERVER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data,error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data,andErrorToast: false) {}
                Utility.hideLoading()
            }
        }
    }

    func wsTwilioVoiceCall() {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TYPE] = 2
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.TWILIO_CALL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                Utility.hideLoading()
                if Parser.isSuccess(response:response, data:data, andErrorToast:true) {
                    self.openTwillioNotificationDialog()
                }
            }
        }
    }
    
    func wsGetTripsDetail() {
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        print("wsGetTripsDetail = \(dictParam)")
        
        Utility.showLoading()

        if APPDELEGATE.reachability?.isReachable ?? false {
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.WS_GET_TRIPS_DETAILS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {[weak self] (response,data, error) -> (Void) in
                Utility.hideLoading()
                
                guard let self = self else { return }
                
                print("wsGetTripsDetail responce = \(response)")
                if Parser.isSuccess(response:response, data:data, withSuccessToast:false, andErrorToast:false) {
                    if let value = response["trip_detail"] as? [[String:Any]] {
                        self.arrTrips.removeAll()
                        for obj in value {
                            self.arrTrips.append(TripsRespons(dics: obj))
                        }
                    }
                }
                self.setShareRides()
            }
        } else {
            Utility.hideLoading()
            let actYes = UIAlertAction(title: "Retry", style: UIAlertAction.Style.destructive) { (act: UIAlertAction) in
                self.wsGetTripsDetail()
            }
            let actNo = UIAlertAction(title: "Exit", style: UIAlertAction.Style.cancel) { (act: UIAlertAction) in
                exit(0)
            }
            Common.alert("Network Not Reachable", "Retry the process",  [actYes,actNo])
        }
    }
    
    func setShareRides() {
        ProviderSingleton.shared.timeLeftToRespondTrip = 0
        for obj in arrTrips {
            if obj.tripId == self.nearByTripID {
                ProviderSingleton.shared.nearTimeLeftToRespondTrip2 = obj.timeLeftToRespondsTrip
                break
            }
        }

        wsGetTripStatus()
    }

    func wsAcceptTrip(bidPrice: Double = 0, dialog: TripBiddingDialog? = nil) {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.IS_PROVIDER_ACCEPTED] = ProviderStatus.Accepted.rawValue
        
        if bidPrice > 0 {
            dictParam[PARAMS.bid_price] = bidPrice
        }

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.RESPOND_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data) {
                    self.stopAccetpRejectTimer()
                    self.wsGetTripStatus()
                    return;
                } else {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let dataResponse :ResponseModel = try jsonDecoder.decode(ResponseModel.self, from: data!)
                        if dataResponse.errorCode == TRIP_IS_ALREADY_ACCEPTED || dataResponse.errorCode == TRIP_IS_ALREADY_CANCELLED {
                            self.stopAccetpRejectTimer()
                            self.stopLocationListner()
                            APPDELEGATE.gotoTrip()
                            return;
                        }
                    } catch {
                        self.stopAccetpRejectTimer()
                        self.stopLocationListner()
                        APPDELEGATE.gotoTrip()
                        return;
                    }
                }
            }
        }
    }

    func wsRejectTrip(isRequestTimeout: Bool = false) {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.IS_PROVIDER_ACCEPTED] = ProviderStatus.Rejected.rawValue
        dictParam[PARAMS.IS_REQUEST_TIMEOUT] = isRequestTimeout

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.RESPOND_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                ProviderSingleton.shared.nearTripId = ""
                
                self.stopTripStatusTimer()
                if Parser.isSuccess(response: response,data: data) {
                    self.stopAccetpRejectTimer()
                    self.stopLocationListner()
                    APPDELEGATE.gotoTrip()
                    return;
                } else {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let dataResponse :ResponseModel = try jsonDecoder.decode(ResponseModel.self, from: data!)
                        if dataResponse.errorCode == TRIP_IS_ALREADY_ACCEPTED || dataResponse.errorCode == TRIP_IS_ALREADY_CANCELLED {
                            self.stopAccetpRejectTimer()
                            self.stopLocationListner()
                            APPDELEGATE.gotoTrip()
                            return;
                        }
                    } catch {
                        self.stopAccetpRejectTimer()
                        self.stopLocationListner()
                        APPDELEGATE.gotoTrip()
                        return;
                    }
                }
            }
        }
    }

    func wsGetUserDetail(id:String) {
        if !id.isEmpty() {
            Utility.showLoading()
            var dictParam : [String : Any] = [:]
            dictParam[PARAMS.USER_ID] = id
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.GET_USER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
                if (error != nil) {
                    Utility.hideLoading()
                } else {
                    if Parser.isSuccess(response: response,data: data) {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let userDataResponse : UserDetail = try jsonDecoder.decode(UserDetail.self, from: data!)
                            ProviderSingleton.shared.nearTripUser = userDataResponse
                            self.updateTripDetail()
                            self.setUerData()
                        } catch {}
                        Utility.hideLoading()
                    }
                }
            }
        }
    }

    func wsSetTripStatus() {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = onGoingTrip.id
        dictParam[PARAMS.PROVIDER_STATUS] = self.providerNextStatus.rawValue
        dictParam[PARAMS.LATITUDE] = ProviderSingleton.shared.currentCoordinate.latitude
        dictParam[PARAMS.LONGITUDE] = ProviderSingleton.shared.currentCoordinate.longitude
        dictParam[PARAMS.BEARING] = ProviderSingleton.shared.bearing
        dictParam[Google.LOCATION] = [[ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6),Date().timeIntervalSince1970 * 1000
            ]]
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SET_TRIP_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            }else {
                if Parser.isSuccess(response: response,data: data) {
                    self.emitTripNotification()
                    self.handleTripStatusResponse(data)
                }
            }
        }
    }
    
    fileprivate func emitTripNotification() {
        let dictParam:[String:Any] =
            [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.TRIP_ID : self.nearByTripID]
       // self.socketHelper.socket?.emitWithAck(self.socketHelper.tripDetailNotify, dictParam).timingOut(after: 0) {data in}
    }

    fileprivate func handleTripStatusResponse(_ data: Data?) {
        guard let data = data else { return }
        let jsonDecoder = JSONDecoder()
        guard let responseModel:TripStatusResponse = try? jsonDecoder.decode(TripStatusResponse.self, from: data) else { return }
        
        ProviderSingleton.shared.tripStaus = responseModel
        Utility.hideLoading()
        
        if ProviderSingleton.shared.tripStaus.trip.id.isEmpty == false { // != nil
            self.onGoingTrip = ProviderSingleton.shared.tripStaus.trip
            if onGoingTrip.is_trip_bidding {
                btnAccept.setTitle("  " + "TXT_ACCEPT_BID".localizedCapitalized + "  ", for: .normal)
            } else {
                btnAccept.setTitle("  " + "TXT_ACCEPT".localizedCapitalized + "  ", for: .normal)
            }
        }
        self.nearByTripID = self.onGoingTrip.id
        self.updateAddress()
        self.updatePaymentView(paymentMode: self.onGoingTrip.paymentMode)
        self.providerCurrentStatus = TripStatus(rawValue: self.onGoingTrip.isProviderStatus) ?? TripStatus.Unknown

        if self.providerCurrentStatus.rawValue > TripStatus.Accepted.rawValue || self.providerCurrentStatus.rawValue < TripStatus.Completed.rawValue {
            LocationCenter.default.requestAuthorization()
        }

        if ProviderSingleton.shared.nearTripUser.userId.isEmpty {
            self.wsGetUserDetail(id: ProviderSingleton.shared.tripStaus.trip.userId)
            self.providerNextStatus = self.providerCurrentStatus
        }
        self.updateMarkers()

        if self.onGoingTrip.isProviderAccepted == ProviderStatus.Pending.rawValue || self.onGoingTrip.isProviderAccepted == ProviderStatus.Rejected.rawValue {
            if self.viewChat != nil {
                self.viewChat.isHidden = true
                self.updateUIForNewTrip()
                self.startTripStatusTimer()
            }
        }
        imgFavourite.isHidden = !self.onGoingTrip.isFavouriteProvider
        viewForUser.isHidden = false
    }

    @objc func doubleTapToEndTrip(_ sender: UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            getAddressBeforeCompleteTrip()
        }
    }

    @objc func wsGetTripStatus() {
        if preferenceHelper.getUserId().isEmpty {
            self.stopLocationListner()
            APPDELEGATE.gotoLogin()
            Utility.hideLoading()
            return
        } else {
            var dictParam : [String : Any] = [:]
//            dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
//            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = self.nearByTripID
            print("get trip status param = \(dictParam)")

            if APPDELEGATE.reachability?.isReachable ?? false {
                let afh:AlamofireHelper = AlamofireHelper.init()
                afh.getResponseFromURL(url: WebService.CHECK_TRIP_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {[weak self] (response,data, error) -> (Void) in
                    Utility.hideLoading()
                    print("get trip status response = \(response)")
                    guard let self = self else { return }
                    if (error != nil) {
                        Utility.hideLoading()
                        if let errorE = error as NSError? {
                            if errorE.code == -1005 {
                                self.wsGetTripStatus()
                            }
                        }
                    } else {
                        if Parser.isSuccess(response:response, data:data, withSuccessToast:false, andErrorToast:false) {
                            self.handleTripStatusResponse(data)
                        } else {
                            self.stopAccetpRejectTimer()
                            self.stopLocationListner()
                        }
                    }
                }
            } else {
                Utility.hideLoading()
                let actYes = UIAlertAction(title: "Retry", style: UIAlertAction.Style.destructive) { (act: UIAlertAction) in
                    self.wsGetTripStatus()
                }
                let actNo = UIAlertAction(title: "Exit", style: UIAlertAction.Style.cancel) { (act: UIAlertAction) in
                    exit(0)
                }
                Common.alert("Network Not Reachable", "Retry the process",  [actYes,actNo])
            }
        }
    }

    func getAddressBeforeCompleteTrip() {
        if onGoingTrip.isToll && onGoingTrip.isTripEnd == FALSE {
            self.openTollDialog()
        } else {
            LocationCenter.default.getAddressFromLatitudeLongitude(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude, completion: { [weak self](address, locations) in
                guard let self = self else {return}
                self.wsCheckDestinationAddress(address: address, latitude: locations[0], longitude: locations[1])
            })
        }
    }

    func wsCheckDestinationAddress(address:String,latitude:Double,longitude:Double) {
        if onGoingTrip.isFixedFare || !onGoingTrip.carRentalId.isEmpty() {
            self.wsCompleteTrip()
        } else {
            if !ProviderSingleton.shared.tripStaus.trip.id.isEmpty() {
                Utility.showLoading()
                var dictParam : [String : Any] = [:]
                dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
                dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
                dictParam[PARAMS.TRIP_ID] = ProviderSingleton.shared.tripStaus.trip.id
                dictParam[PARAMS.LATITUDE] = latitude
                dictParam[PARAMS.LONGITUDE] = longitude

                let afh:AlamofireHelper = AlamofireHelper.init()
                afh.getResponseFromURL(url: WebService.CHECK_DESTINATION_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
                    Utility.hideLoading()
                    if (error != nil) {Utility.hideLoading()}else {
                        if Parser.isSuccess(response: response,data: data,withSuccessToast: false,andErrorToast: false) {
                            self.wsCompleteTrip()
                        }
                    }
                }
            }
        }
    }

    func wsCompleteTrip() {
        if !ProviderSingleton.shared.tripStaus.trip.id.isEmpty() {
            Utility.showLoading()
            var dictParam : [String : Any] = [:]
            dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = ProviderSingleton.shared.tripStaus.trip.id
            let tempArr = self.onGoingTrip.destinationAddresses.last
            dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = tempArr?.address
            dictParam[PARAMS.LATITUDE] = ProviderSingleton.shared.currentCoordinate.latitude
            dictParam[PARAMS.LONGITUDE] = ProviderSingleton.shared.currentCoordinate.longitude
            dictParam[PARAMS.PROVIDER_STATUS] = TripStatus.Completed.rawValue

            if (ProviderSingleton.shared.tripStaus.trip.isToll) {
                dictParam[PARAMS.TOLL_AMOUNT] = tollAmount
            }

            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.COMPLETE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
                print("response complete trip \(response)")
                Utility.hideLoading()
                if (error != nil) {
                    Utility.hideLoading()
                } else {
                    if Parser.isSuccess(response: response,data: data,withSuccessToast: false,andErrorToast: false) {
                        self.emitTripNotification()
                        if self.onGoingTrip.paymentMode == PaymentMode.APPLE_PAY {
                            self.wsPayPayment()
                        } else {
                            APPDELEGATE.gotoInvoice()
                        }
                    }
                }
            }
        }
    }

    func wsCancelTrip(dialog:CustomCancelTripDialog,reason:String = "") {
        if !ProviderSingleton.shared.tripStaus.trip.id.isEmpty() {
            Utility.showLoading()
            var dictParam : [String : Any] = [:]
            dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = ProviderSingleton.shared.tripStaus.trip.id
            dictParam[PARAMS.CANCEL_TRIP_REASON] = reason

            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.CANCEL_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
                if (error != nil) {Utility.hideLoading()}else {
                    if Parser.isSuccess(response: response,data: data,withSuccessToast: false,andErrorToast: true) {
                        dialog.removeFromSuperview()
                        self.stopLocationListner()
                        self.emitTripNotification()
                        Utility.hideLoading()
                    } else {
                        Utility.hideLoading()
                    }
                }
            }
        } else {
            dialog.removeFromSuperview()
        }
    }

    func wsPayPayment() {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = self.nearByTripID

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.PAY_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                OperationQueue.main.addOperation({
                    Utility.hideLoading()
                    if Parser.isSuccess(response:response, data:data, andErrorToast:false) {}
                    APPDELEGATE.gotoInvoice()
                })
            }
        }
    }
}

//MARK: - Timers
extension NearByTripVC {
    @objc func timerForAcceptReject() {
        ProviderSingleton.shared.nearTimeLeftToRespondTrip2 -= 1
        if ProviderSingleton.shared.nearTimeLeftToRespondTrip2 <= 0 {
            self.stopAccetpRejectTimer()
            wsRejectTrip(isRequestTimeout: true)
        } else {
            if preferenceHelper.getIsRequsetAlertSoundOn() {
                self.playSound()
            }
            DispatchQueue.main.async {
                self.btnTimer.setTitle(ProviderSingleton.shared.nearTimeLeftToRespondTrip2.toString() + "TXT_REMAINING_SECONDS".localized, for: .normal)
            }
        }
    }

    func stopAccetpRejectTimer() {
        AppDelegate.SharedApplication().nearTripDetail = nil
        ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
        ProviderSingleton.shared.timerForAcceptRejectTrip = nil
        self.btnTimer.isHidden = true
        self.btnNavigation.isHidden = false
        //self.stkvwNavigationRightButtonsWidth.constant = 44
        if let last = self.navigationController?.viewControllers.last as? NearByTripVC {
            self.navigationController?.popViewController(animated: true)
        }

        if player != nil {
            if (player?.isPlaying)! {
                player?.stop()
            }
        }
    }

    func startTimerForAcceptReject() {
        DispatchQueue.main.async {
            ProviderSingleton.shared.timerForAcceptRejectTrip?.invalidate()
            ProviderSingleton.shared.timerForAcceptRejectTrip = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TripVC.timerForAcceptReject), userInfo: nil, repeats: true)
        }
    }

    func setUpSound() {
        var sound:URL? = nil
        if providerCurrentStatus == TripStatus.Coming {
            sound = Bundle.main.url(forResource: "pickUpSound", withExtension: "mp3")!
        } else if self.onGoingTrip.isProviderAccepted == ProviderStatus.Pending.rawValue || self.onGoingTrip.isProviderAccepted == ProviderStatus.Rejected.rawValue {
            sound = Bundle.main.url(forResource: "beep", withExtension: "mp3")!
        }

        if sound != nil {
            do {
                player = try AVAudioPlayer(contentsOf: sound!)
                guard player != nil else { return }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {}
    }

    func playSound() {
        player?.stop()
        player?.play()
    }

    func startWaitingTripTimer() {
        ProviderSingleton.shared.timerForWaitingTime?.invalidate()
        ProviderSingleton.shared.timerForWaitingTime = nil
        ProviderSingleton.shared.timerForWaitingTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(waitTimeWatcher), userInfo: nil, repeats: true)
    }

    func stopWaitingTripTimer() {
        ProviderSingleton.shared.timerForWaitingTime?.invalidate()
    }

    func startTotalTripTimer() {
        ProviderSingleton.shared.timerForTotalTripTime?.invalidate()
        ProviderSingleton.shared.timerForTotalTripTime = nil
        ProviderSingleton.shared.timerForTotalTripTime =    Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(totalTimeWatcher), userInfo: nil, repeats: true)
    }

    func stopTotalTripTimer() {
        ProviderSingleton.shared.timerForTotalTripTime?.invalidate()
        ProviderSingleton.shared.timerForTotalTripTime = nil
    }

    @objc func totalTimeWatcher() {
        totalTripTime = totalTripTime + 1;
        DispatchQueue.main.async {
            self.lblEtaOrTotalTimeValue.text = self.totalTripTime.toString(places: 2) + MeasureUnit.MINUTES
        }
    }

    @objc func waitTimeWatcher() {
        currentWaitingTime = currentWaitingTime + 1;
        if (currentWaitingTime < 0) {
            lblWaitingTime.text = "TXT_WAITING_TIME_START_AFTER".localized
            lblWaitingTimeValue.text = abs(currentWaitingTime).toString() + " s"
        } else {
            lblWaitingTime.text = "TXT_TOTAL_WAITING_TIME".localized
            lblWaitingTimeValue.text = abs(currentWaitingTime).toString() + " s"
        }

        if providerCurrentStatus == TripStatus.Arrived {
            stkWaitTime.isHidden = false
            stkEtaAndPayment.isHidden = true
        } else {
            stkWaitTime.isHidden = true
            stkEtaAndPayment.isHidden = false
            stopWaitingTripTimer()
        }
    }
}

//MARK: - Message Received Delegate
extension NearByTripVC: MessageRecivedDelegate {
    func messageRecived(data: FirebaseMessage, tripId: String) {
        imgChatNotification.isHidden = !(data.isRead == false && data.type != CONSTANT.TYPE_PROVIDER)
    }

    func messageUpdated(data: FirebaseMessage, tripId: String) {
        imgChatNotification.isHidden = !(data.isRead == false && data.type != CONSTANT.TYPE_PROVIDER)
    }
}
