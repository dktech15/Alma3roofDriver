//
//  MapVC.swift
//  Cabtown Provider
//
//  Created by Elluminati iMac on 19/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapVC: BaseVC {

    struct AdminAlert {
        static let ContactUs:Int = 0
        static let AddVehicle:Int = 1
        static let EditVehicle:Int = 2
        static let DocumentExpire:Int = 3
        static let ProvderDecline:Int = 4
        static let PicKVehicle:Int = 5
        static let UNKNOWN:Int = -1
    }

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu : UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnNewTrip: UIButton!
    @IBOutlet weak var imgNotificationAlert: UIImageView!
    //Offline View
    @IBOutlet weak var lblGoOnline: UILabel!
    @IBOutlet weak var viewForOffline: UIView!
    @IBOutlet weak var btnGoOnline: UIButton!
    @IBOutlet weak var btnDropOff: UIButton!

    //Admin Alert View
    @IBOutlet weak var viewForAdminAlert: UIView!
   
    @IBOutlet weak var lblAdminAlert: UILabel!
    @IBOutlet weak var btnAdminAlertAction: UIButton!

    //Wallet Alert View
    @IBOutlet weak var viewForAdminWalletAlert: UIView!
    @IBOutlet weak var lblAdminWalletAlert: UILabel!

    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var lblIconGoOffline: UILabel!
    @IBOutlet weak var imgIconGoOffline: UIImageView!
    @IBOutlet weak var btnCloseProviderTrip: UIButton!
    @IBOutlet weak var imgCloseProviderTrip: UIImageView!

    @IBOutlet weak var lblIconDestination: UILabel!
    @IBOutlet weak var imgIconDestination: UIImageView!
    @IBOutlet weak var lblIconSource: UILabel!
    @IBOutlet weak var imgIconSource: UIImageView!
    
    @IBOutlet weak var btnBidTrips: UIButton!
    
    @IBOutlet weak var btnOffline: UIButton!
    
    let bottomSheetVC = ScrollableBottomSheetViewController()
    var providerDetailResponse: ProviderDetailResponse = ProviderDetailResponse.init()

    var currentMarker = GMSMarker()
    weak var timerUpdateLocation : Timer?
    var isUpdateLocation: Bool = true
    var serviceTypeId:String = ""

    var providerCityType:Citytype = Citytype.init()
    var strCountry:String = ""
    var strCurrentCity:String = ""
    let socketHelper:SocketHelper = SocketHelper.shared
    var strCountryCode = ""
    private var heatmapLayer: GMUHeatmapTileLayer!

    //Provider Trip Alert View
    @IBOutlet weak var viewForProviderTripOverlay: UIView!
    @IBOutlet weak var dialogForProviderTrip: UIView!
    @IBOutlet weak var viewForSourceAddress: UIView!
    @IBOutlet weak var txtPickupAddress: UITextField!
    @IBOutlet weak var viewForDestination: UIView!
    @IBOutlet weak var txtDestinationAddress: UITextField!
    @IBOutlet weak var btnRideNow: UIButton!

    @IBOutlet weak var txtFirstName: ACFloatingTextfield!
    @IBOutlet weak var txtLastName: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtCountryPhoneCode: ACFloatingTextfield!
    @IBOutlet weak var txtPhoneNumber: ACFloatingTextfield!

    @IBOutlet weak var lblFareEstimate: UILabel!
    @IBOutlet weak var lblFareEstimateValue: UILabel!

    @IBOutlet weak var autoCompleteHeight: NSLayoutConstraint!
    @IBOutlet weak var autoCompleteTop: NSLayoutConstraint!
    @IBOutlet weak var tblForAutoComplete: UITableView!
    
    @IBOutlet weak var viewLocationButton: UIView!
    @IBOutlet weak var viewZoneFull: UIView!
    @IBOutlet weak var viewZone: UIView!
    @IBOutlet weak var lblZone: UILabel!
    
    
    var arrForAutoCompleteAddress:[(title: String, subTitle: String, address: String, placeid: String)] = []
    let cellHeight: CGFloat = 100

    @IBOutlet weak var viewForRideNow: UIView!

    var destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var destinationAddress:String = ""
    var pickupCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var pickupAddress:String = ""
    let toolBar = UIToolbar()
    var dialogForCountry:CustomCountryDialog? = nil
    var isCallCountryCity = false
    var zoneId = ""
    var arrBid = [Bids]() {
        didSet {
            
        }
    }
  
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        socketHelper.connectSocket()
        self.viewForAdminWalletAlert.isHidden = true
        self.btnNewTrip.isHidden = true
        self.btnBidTrips.isHidden = true
        
        setMap()
        setupHeatMap()
        mapView.settings.compassButton = false
        currentMarker.icon = UIImage(named: "asset-driver-pin-placeholder")
        currentMarker.map = mapView
        self.navigationController?.isNavigationBarHidden = true
        self.initialViewSetup()
        self.revealViewController()?.delegate = self;
        setupRevealViewController()
        addBottomSheetView()
    }

    func setupHeatMap() {
        if preferenceHelper.getIsHeatMapOn() {
            let gradientColors = [UIColor.green, UIColor.red]
            let gradientStartPoints = [0.2, 1.0] as [NSNumber]
            if heatmapLayer == nil {
                heatmapLayer = GMUHeatmapTileLayer()
            }
            heatmapLayer.gradient = GMUGradient(colors: gradientColors, startPoints: gradientStartPoints, colorMapSize: 256)
            wsGetHeatMapLocations()
        } else {
            if heatmapLayer != nil {
                heatmapLayer.weightedData = []
                heatmapLayer.map = nil
            }
        }
    }

    //MARK: - Location Methods
    override func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        super.locationUpdate(ntf)
        guard let userInfo = ntf.userInfo else { return }
        guard let location = userInfo["location"] as? CLLocation else { return }
        if self.view.subviews.count > 0 {
            Common.bearing = Common.currentCoordinate.calculateBearing(to: location.coordinate)
            Common.currentCoordinate = location.coordinate
            ProviderSingleton.shared.bearing = Common.bearing
            ProviderSingleton.shared.currentCoordinate = location.coordinate
            strCountryCode = ProviderSingleton.shared.currentCountryCode
            self.animateToCurrentLocation()
            self.updateLocation()
            if !self.isCallCountryCity {
                self.isCallCountryCity = true
                self.wsGetProviderDetail(isCallCountyCity: true)
            }
        }
    }
    
    override func changeLocationPermision(_ ntf: Notification) {
        super.changeLocationPermision(ntf)
        
    }

    override func locationFail(_ ntf: Notification = Common.defaultNtf) {
        super.locationFail(ntf)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if bottomSheetVC.arrForVehicleList.isEmpty {
            bottomSheetVC.wsGetVehicleList()
        }
        LocationCenter.default.addObserver(self, [#selector(self.locationUpdate(_:)),
                                                  #selector(self.locationFail(_:))])

        //self.addLocationObserver()
        LocationCenter.default.startUpdatingLocation()
        self.animateToCurrentLocation()
       

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.wsGetProviderDetail()
            self.setupHeatMap()
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.updateLocation()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                self.wsGoOnline()
//            }
//        }
        wsGetTrips()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    //MARK: - Create Toolbar
    func createToolbar(textview : ACFloatingTextfield) {

        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "TXT_DONE".localized,
            style: .plain,
            target: self,
            action: #selector(doneTxtCountryCode(sender:))
        )
        doneButton.tag = textview.tag
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textview.inputAccessoryView = toolBar
    }

    @objc func doneTxtCountryCode(sender : UIBarButtonItem) {
        if txtCountryPhoneCode.isFirstResponder {
            _ = txtPhoneNumber.becomeFirstResponder()
        } else if txtPhoneNumber.isFirstResponder {
            _ = txtPhoneNumber.resignFirstResponder()
        }
    }

    //MARK: - Set localized
    func initialViewSetup() {
        viewForOffline.isHidden = true
        viewForAdminAlert.isHidden = true
        btnNewTrip.isHidden = true
        viewZoneFull.isHidden = true
        
        viewZone.setRound(withBorderColor: UIColor.clear, andCornerRadious: 5, borderWidth: 1.0)
        viewZone.backgroundColor = UIColor.themeButtonBackgroundColor
        lblZone.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblZone.textColor = UIColor.white
        
        
        
        imgNotificationAlert.isHidden = true
        lblTitle.text = "TXT_CAPTION".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblGoOnline.text = "TXT_GO_ONLINE_MESSAGE".localized
        lblGoOnline.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblGoOnline.textColor = UIColor.themeTextColor
        
        lblAdminWalletAlert.text = "TXT_DEFAULT".localized
        lblAdminWalletAlert.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblAdminWalletAlert.textColor = UIColor.themeErrorTextColor
        
        viewForOffline.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
        btnGoOnline.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnGoOnline.setTitle("TXT_GO_ONLINE".localizedCapitalized, for: .normal)
        btnGoOnline.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnGoOnline.backgroundColor = UIColor.themeButtonBackgroundColor
        btnGoOnline.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnGoOnline.frame.height/2, borderWidth: 1.0)
        
        btnDropOff.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnDropOff.setTitle("txt_drop_off".localizedCapitalized, for: .normal)
        btnDropOff.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnDropOff.backgroundColor = UIColor.themeButtonBackgroundColor
        btnDropOff.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnGoOnline.frame.height/2, borderWidth: 1.0)
        btnDropOff.isHidden = true
        
        btnAdminAlertAction.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnAdminAlertAction.setTitle("TXT_CONTACT_US".localizedCapitalized, for: .normal)
        btnAdminAlertAction.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnAdminAlertAction.backgroundColor = UIColor.themeButtonBackgroundColor
        btnAdminAlertAction.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnAdminAlertAction.frame.height/2, borderWidth: 1.0)
        
        btnRideNow.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnRideNow.setTitle("  " + "TXT_RIDE_NOW".localizedCapitalized, for: .normal)
        btnRideNow.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        
        btnOffline.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnOffline.setTitle("TXT_GO_OFFLINE".localizedCapitalized, for: .normal)
        btnOffline.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnOffline.backgroundColor = UIColor.themeWalletDeductedColor
        btnOffline.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnGoOnline.frame.height/2, borderWidth: 1.0)
        
        viewForRideNow.backgroundColor = UIColor.themeButtonBackgroundColor
        
        txtPickupAddress.placeholder = "TXT_SOURCE_ADDRESS".localized
        
        txtDestinationAddress.placeholder = "TXT_DESTINATION_ADDRESS".localized
        txtFirstName.placeholder = "TXT_FIRST_NAME".localized
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtPhoneNumber.placeholder = "TXT_PHONE_NO".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        viewForSourceAddress.backgroundColor = UIColor.themeViewBackgroundColor
        viewForDestination.backgroundColor = UIColor.themeViewBackgroundColor
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openCountryDialog))
        txtCountryPhoneCode.addGestureRecognizer(tap)
        
        txtPickupAddress.delegate = self
        txtDestinationAddress.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPhoneNumber.delegate = self
        txtPhoneNumber.keyboardType = .numberPad
        txtCountryPhoneCode.delegate = self
        createToolbar(textview: txtCountryPhoneCode)
        createToolbar(textview: txtPhoneNumber)

        txtPickupAddress.addTarget(self, action: #selector(searching(_:)), for: .editingChanged)
        
        txtDestinationAddress.addTarget(self, action: #selector(searching(_:)), for: .editingChanged)
        
        tblForAutoComplete.delegate = self
        tblForAutoComplete.dataSource = self
        
        lblFareEstimate.text = "TXT_FARE_ESTIMATE".localized
        lblFareEstimate.font = FontHelper.font(size: FontSize.regular , type: FontType.Regular)
        lblFareEstimate.textColor = UIColor.themeButtonTitleColor
        
        self.lblFareEstimateValue.text = 0.0.toCurrencyString()
        
        lblFareEstimateValue.font = FontHelper.font(size: FontSize.regular , type: FontType.Regular)
        lblFareEstimateValue.textColor = UIColor.themeButtonTitleColor
        imgIconGoOffline.tintColor = UIColor.themeImageColor
        imgMenu.tintColor = UIColor.themeImageColor
        btnCurrentLocation.setImage(UIImage(named: "asset-my-location_u"), for: .normal)
        btnCurrentLocation.tintColor = UIColor.themeImageColor
        
        imgCloseProviderTrip.tintColor = UIColor.themeImageColor
        btnNewTrip.setImage(UIImage(named: "asset-new-trip"), for: .normal)
        
        viewLocationButton.backgroundColor = .themeViewBackgroundColor
        viewLocationButton.applyShadowToView(viewLocationButton.frame.size.height/2)
        
        btnBidTrips.setRound()
        btnBidTrips.backgroundColor = UIColor.themeButtonBackgroundColor
        btnBidTrips.setTitle("", for: .normal)
        btnBidTrips.titleLabel?.font = FontHelper.assetFont(size: 30)
    }
    
    func addBottomSheetView() {
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        var height:CGFloat = CGFloat.leastNonzeroMagnitude

        if #available(iOS 11.0, *) {
            height = view.frame.height - (self.navigationView.frame.height + self.view.safeAreaInsets.top + 5)
        } else {
            height = view.frame.height - (self.navigationView.frame.height + 5)
        }

        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }

    func setupLayout() {
        navigationView.navigationShadow()
        dialogForProviderTrip.setShadow()
        dialogForProviderTrip.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }

    //MARK: - Get Current Location
    func setMap() {
        mapView.clear()
        currentMarker.map = mapView
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;
        mapView.settings.rotateGestures = false;
        mapView.settings.myLocationButton = false;
        mapView.isMyLocationEnabled = false;
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if let styleURL = Bundle.main.url(forResource: "styleable_map", withExtension: "json") {
                //mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
    }

    func updateUiForOnlineOffline() {
        viewForAdminAlert.isHidden = true
        if ProviderSingleton.shared.provider.isActive == TRUE {
            viewForOffline.isHidden = true
            self.socketTripListner()
            if preferenceHelper.getIsProviderInitiateTrip() == true  && viewForAdminWalletAlert.isHidden{
                self.btnNewTrip.isHidden = false
            } else {
                self.btnNewTrip.isHidden = true
            }
            btnOffline.isHidden = false
            viewZoneFull.isHidden = true
        } else {
            viewForOffline.isHidden = false
            self.stopSocketTripListner()
            self.btnNewTrip.isHidden = true
            btnOffline.isHidden = true
            
            //viewZoneFull.isHidden = false
        }
//        if !self.btnBidTrips.isHidden{
//            self.btnOffline.isHidden = true
//        }
    }

    func updateUiForAdminAlert(alert:Int) {
        switch alert {
        case AdminAlert.ProvderDecline:
            self.lblAdminAlert.text = "ADMIN_MSG_PROVIDER_DECLINED".localized
            self.btnAdminAlertAction.setTitle("TXT_CONTACT_US".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = false
            bottomSheetVC.imgVehiclePending.isHidden = false
            self.btnAdminAlertAction.tag = alert
        case AdminAlert.AddVehicle:
            self.lblAdminAlert.text = "ADMIN_MSG_ADD_VEHICLE".localized
            self.btnAdminAlertAction.setTitle("TXT_ADD_VEHICLE".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = false
            bottomSheetVC.imgVehiclePending.isHidden = false
            self.btnAdminAlertAction.tag = alert
        case AdminAlert.EditVehicle:
            self.lblAdminAlert.text = "ADMIN_MSG_UPLOAD_VEHICLE_DOCUMENT".localized
            self.btnAdminAlertAction.setTitle("TXT_EDIT_VEHICLE".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = false
            bottomSheetVC.imgVehiclePending.isHidden = false
            self.btnAdminAlertAction.tag = alert
        case AdminAlert.DocumentExpire:
            self.lblAdminAlert.text = "ADMIN_MSG_PROVIDER_DOCUMENT_EXPIRE".localized
            self.btnAdminAlertAction.setTitle("TXT_EDIT_DOCUMENT".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = false
            bottomSheetVC.imgVehiclePending.isHidden = false
            self.btnAdminAlertAction.tag = alert
        case AdminAlert.ContactUs:
            self.lblAdminAlert.text = "ADMIN_MSG_VEHICLE_PROCESSING".localized
            self.btnAdminAlertAction.setTitle("TXT_CONTACT_US".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = false
            bottomSheetVC.imgVehiclePending.isHidden = false
            self.btnAdminAlertAction.tag = alert
        case AdminAlert.PicKVehicle:
            self.lblAdminAlert.text = "txt_pickup_vehicle_alert".localized
            self.btnAdminAlertAction.setTitle("txt_pickup_vehicle".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = false
            
            viewForAdminAlert.backgroundColor = UIColor.transfrentBackground
            bottomSheetVC.imgVehiclePending.isHidden = false
            self.btnAdminAlertAction.tag = alert
        default:
            self.lblAdminAlert.text = "ADMIN_MSG_UPLOAD_VEHICLE_DOCUMENT".localized
            self.btnAdminAlertAction.setTitle("TXT_CONTACT_US".localizedCapitalized, for: .normal)
            self.viewForAdminAlert.isHidden = true
            bottomSheetVC.imgVehiclePending.isHidden = true
            self.btnAdminAlertAction.tag = alert
        }
    }
    
    //MARK: - User Define Functions
    func startTripBidsListner() {
        self.stopTripBidsListner()
        for bid in arrBid {
            let id = "'\((bid.trip_id ?? ""))'"
            self.socketHelper.socket?.emit("room", id)
            self.socketHelper.socket?.on(id, callback: {  [weak self] (data, ack) in
                print("socket trip bid : \(id)")
                guard let self = self else { return }
                guard let response = (data.first as? [String:Any]) else { return }
                print(response)
                self.wsGetTrips()
            })
        }
    }
    
    func stopTripBidsListner() {
        for bid in arrBid {
            self.socketHelper.socket?.off("'\(bid.trip_id ?? "")'")
        }
    }

    //MARK: - Action Methods
    @IBAction func actionNotification(_ sender: Any) {
        let massNotificationVC = MassNotificationVC(nibName: "MassNotificationVC", bundle: nil)
        massNotificationVC.modalPresentationStyle = .fullScreen
        self.present(massNotificationVC, animated: true, completion: nil)
    }
    @IBAction func onClickBtnGoOnline(_ sender: Any) {
        self.wsGoOnline()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
//            self.wsGetProviderDetail()
        }
    }
    
    @IBAction func onClickBtnAcceptedTrip(_ sender: Any) {
        openAcceptedTrips(arrBid: self.arrBid)
    }

    @IBAction func onClickBtnAdminAlertAction(_ sender: Any) {
        let tag = btnAdminAlertAction.tag
        switch tag {
        case AdminAlert.ProvderDecline:
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
            }
        case AdminAlert.AddVehicle:
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                if let mainViewController:VehicleDetailVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "vehicleDetailVC") as? VehicleDetailVC {
                    navigationVC.pushViewController(mainViewController, animated: true)
                }
            }
        case AdminAlert.EditVehicle:
            bottomSheetVC.openBottomSheet()
        case AdminAlert.DocumentExpire:
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_DOCUMENTS, sender: self)
            }
        case AdminAlert.ContactUs:
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
            }
        case AdminAlert.PicKVehicle:
            wsGetHubVehicleList()
        default:
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
            }
        }
    }
    
    @IBAction func onClickBtnNewTrip(_ sender: Any) {
        if arrBid.count > 0 {
            Utility.showToast(message: "txt_bidding_request_is_pending".localized)
        } else {
            self.fillCurrentLocation()
        }
    }

    @IBAction func onClickBtnCloseProviderTripView(_ sender: Any) {
        viewForProviderTripOverlay.isHidden = true
        self.arrForAutoCompleteAddress.removeAll()
        self.tblForAutoComplete.isHidden = true
    }

    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
//                let massNotificationVC = MassNotificationVC(nibName: "MassNotificationVC", bundle: nil)
//            massNotificationVC.modalPresentationStyle = .fullScreen
//                self.present(massNotificationVC, animated: true, completion: nil)
//        PushNotificationSender().sendPushNotification(to: "esdKaC_IXUOmi76IHd_NBQ:APA91bEt8fHFb3uWNT1eMGQm_XgU_ucgpwfjOpQl8jVmKJ1z5Sjg8kTQajzktVpFzlOaKmIXQUCbo8iW-Y6RqmJXrYLgKOJv6FmvQniLssPDgJTvDtITySd3sBasjt3BKZTRT--9C6yM", title: "test", body: "test")
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.restricted {
            self.animateToCurrentLocation()
        }
    }

    @IBAction func onClickBtnRideNow(_ sender: Any) {
        self.view.endEditing(true)
        let validEmail = txtEmail.text!.checkEmailValidation(isEmailVerficationNeedToCheck: false)
        let validPhoneNumber = txtPhoneNumber.text!.isValidMobileNumber()

        if txtFirstName.text?.isEmpty() ?? true {
            txtFirstName.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_FIRST_NAME".localized)
        } else if txtCountryPhoneCode.text?.isEmpty() ?? true {
            Utility.showToast(message:"VALIDATION_MSG_INVALID_PHONE_NUMBER_CODE".localized)
        } else if validPhoneNumber.0 == false {
            txtPhoneNumber.showErrorWithText(errorText: validPhoneNumber.1)
        } else if pickupAddress.isEmpty() {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_SOURCE_ADDRESS".localized)
        } else if destinationAddress.isEmpty() {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_SOURCE_ADDRESS".localized)
        } else {
            self.wsProviderCreateTrip()
        }
    }
    
    @IBAction func onClickOffline(_ sender: UIButton) {
        if !self.btnBidTrips.isHidden{
            Utility.showToast(message: "txt_bidding_request_asked".localized)
//            self.btnOffline.isHidden = true
        }else{
            
            
            let dialog = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "txt_are_you_sure_you_want_to_go_offline".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized)
            dialog.onClickRightButton = { [weak self] in
                guard let self = self else { return }
                self.wsGoOfline()
                dialog.removeFromSuperview()
            }
            dialog.onClickLeftButton = {
                dialog.removeFromSuperview()
            }
        }
    }
    
    @IBAction func onClickDropOff(_ sender: UIButton) {
        wsDropOff()
    }
    
    func showContactUs() {
    }
}

//MARK: - RevealViewController Delegate Methods
extension MapVC:PBRevealViewControllerDelegate {

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

//MARK: - Webservice Calls
extension MapVC {

    func wsGetFareEstimate() {
        if !pickupAddress.isEmpty() && !destinationAddress.isEmpty() {
            Utility.showLoading()
            var dictParam : [String : Any] = [:]

            LocationCenter.default.getTimeAndDistance(sourceCoordinate: pickupCoordinate, destCoordinate: destinationCoordinate, unit: "") { (time, distance) in
                dictParam [PARAMS.IS_SURGE_HOURS] = self.checkSurgeTime(startHour: self.providerDetailResponse.typeDetails.surgeStartHour.toString(), endHour: self.providerDetailResponse.typeDetails.surgeEndHour.toString(), serverTime: self.providerDetailResponse.typeDetails.serverTime)

                dictParam[PARAMS.SURGE_MULTIPLIER] = self.providerCityType.surgeMultiplier
                dictParam[PARAMS.TIME] = (time.toInt()).toString()
                dictParam[PARAMS.DISTANCE] = distance
                dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
                dictParam[PARAMS.SERVICE_TYPE_ID] = ProviderSingleton.shared.provider.serviceType
                dictParam[PARAMS.DESTINATION_LATITUDE] = self.destinationCoordinate.latitude.toString(places: 6)
                dictParam[PARAMS.DESTINATION_LONGITUDE] = self.destinationCoordinate.longitude.toString(places: 6)
                dictParam[PARAMS.PICKUP_LATITUDE] = self.pickupCoordinate.latitude.toString(places: 6)
                dictParam[PARAMS.PICKUP_LONGITUDE] = self.pickupCoordinate.longitude.toString(places: 6)

                let afh:AlamofireHelper = AlamofireHelper.init()
                afh.getResponseFromURL(url: WebService.GET_FARE_ESTIMATE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data,error) -> (Void) in
                    if (error != nil) {
                        Utility.hideLoading()
                    } else {
                        Utility.hideLoading()
                        if Parser.isSuccess(response: response, data: data) {
                            print(response)
                            let jsonDecoder = JSONDecoder()
                            do{
                                let fareEstimateResposne:FareEstimateResponse =  try jsonDecoder.decode(FareEstimateResponse.self, from: data!)
                                self.lblFareEstimateValue.text = fareEstimateResposne.estimatedFare.toCurrencyString()
                            } catch {
                                self.lblFareEstimateValue.text = 0.0.toCurrencyString()
                            }
                        } else {
                            self.lblFareEstimateValue.text = 0.0.toCurrencyString()
                        }
                    }
                }
            }
        } else {
            Utility.showToast(message: "MSG_ENTER_ADDRESS_FIRST".localized)
        }
    }

    func wsGetProviderDetail(isCallCountyCity: Bool = false) {
        Utility.showLoading()
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.DEVICE_TYPE : CONSTANT.IOS,
              PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
              PARAMS.APP_VERSION: currentAppVersion,
              PARAMS.TYPE: CONSTANT.TYPE_PROVIDER]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_PROVIDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
//get_provider_detail
//Zone // 3 Param
//zone_queue_id != empty
            //zone_name != empty
            //Socket (zone_que_id) register
            //is_new_added (in socket ) is false call wsGetProviderDetail()
            // if not get socket un register
            
            //Update location
            //same get in all that three param
            
            
            Utility.hideLoading()
            if (self.view?.subviews.count ?? 0)  > 0 {
                self.bottomSheetVC.view.isHidden = false
                self.viewForAdminWalletAlert.isHidden = true
                if Parser.parseProviderDetail(response: response, data: data) {
                    let jsonDecoder = JSONDecoder()
                    do {
                        self.providerDetailResponse = try jsonDecoder.decode(ProviderDetailResponse.self, from: data!)
                        self.lblTitle.text = self.providerDetailResponse.typeDetails.description
                        if self.providerDetailResponse.provider.zone_queue_id != "" && self.providerDetailResponse.provider.zone_name != ""{
                            self.viewZoneFull.isHidden = false
                            self.zoneId = self.providerDetailResponse.provider.zone_queue_id
                            self.lblZone.text = "\(self.providerDetailResponse.provider.zone_name) - \(self.providerDetailResponse.provider.zone_queue_number)"
                            self.socketZoneListner(zoneId: self.zoneId)
                        }else{
                            self.socketHelper.socket?.off("'\(self.zoneId)'")
                            self.viewZoneFull.isHidden = true
                            self.zoneId = ""
                        }
                        
                        
                        if ProviderSingleton.shared.provider.isDocumentsExpired {
                            self.updateUiForAdminAlert(alert: AdminAlert.DocumentExpire)
                            return;
                        } else if self.providerDetailResponse.provider.vehicleDetail.isEmpty {
                            ProviderSingleton.shared.currentVehicle = VehicleDetail.init()
                            if (self.providerDetailResponse.provider.providerType == ProviderType.ADMIN) {
                                self.updateUiForAdminAlert(alert: AdminAlert.PicKVehicle)
                                self.bottomSheetVC.view.isHidden = true
                            } else if (self.providerDetailResponse.provider.providerType != ProviderType.PARTNER) {
                                self.updateUiForAdminAlert(alert: AdminAlert.AddVehicle)
                                return;
                            } else {
                                self.updateUiForAdminAlert(alert: AdminAlert.ContactUs)
                                return;
                            }
                        } else {
                            for vehicle in self.providerDetailResponse.provider.vehicleDetail {
                                if vehicle.isSelected {
                                    ProviderSingleton.shared.currentVehicle = vehicle
                                    Utility.downloadImageFrom(link: self.self.providerDetailResponse.typeDetails.mapPinImageUrl, completion: { (image) in
                                        self.currentMarker.icon = image
                                    })
                                    
                                    if !(vehicle.isDocumentsUploaded) {
                                        if (self.providerDetailResponse.provider.providerType != ProviderType.PARTNER) {
                                            self.updateUiForAdminAlert(alert: AdminAlert.EditVehicle)
                                            return;
                                        }else {
                                            self.updateUiForAdminAlert(alert: AdminAlert.ContactUs)
                                            return;
                                        }
                                    }else if vehicle.isDocumentsExpired {
                                        if (self.providerDetailResponse.provider.providerType != ProviderType.PARTNER) {
                                            self.updateUiForAdminAlert(alert: AdminAlert.EditVehicle)
                                            return;
                                        }else {
                                            self.updateUiForAdminAlert(alert: AdminAlert.ContactUs)
                                            return;
                                        }
                                    }
                                    break
                                }
                            }
                            if ProviderSingleton.shared.currentVehicle.id.isEmpty {
                                self.updateUiForAdminAlert(alert: AdminAlert.ContactUs)
                            } else {
                                if ProviderSingleton.shared.provider.isApproved == FALSE {
                                    self.updateUiForAdminAlert(alert: AdminAlert.ProvderDecline)
                                } else {
                                    if ProviderSingleton.shared.provider.providerType == TRUE && self.providerDetailResponse.provider.isPartnerApprovedByAdmin == FALSE {
                                        self.updateUiForAdminAlert(alert: AdminAlert.ProvderDecline)
                                    } else {
                                        self.updateUiForOnlineOffline()
                                        if ProviderSingleton.shared.provider.providerType == ProviderType.ADMIN {
                                            self.btnDropOff.isHidden = false
                                        } else {
                                            self.btnDropOff.isHidden = true
                                        }
                                    }
                                }
                                
                                let typeDetail:TypeDetail  = self.providerDetailResponse.typeDetails
                                if typeDetail.typeid.isEmpty() {
                                    self.btnNewTrip.isHidden = true
                                } else {
                                    ProviderSingleton.shared.isAutoTransfer =  typeDetail.isAutoTransfer
                                    if typeDetail.isCheckProviderWalletAmountForReceivedCashRequest {
                                        let walletAmount = self.providerDetailResponse.provider.wallet;
                                        let minWalletAmount = typeDetail.providerMinWalletAmountSetForReceivedCashRequest;
                                        if walletAmount < minWalletAmount && ProviderSingleton.shared.provider.providerType != ProviderType.PARTNER {
                                            self.lblAdminWalletAlert.text = "MSG_MIN_WALLET_REQUIRED".localized + " " +  typeDetail.providerMinWalletAmountSetForReceivedCashRequest.toCurrencyString()
                                            self.viewForAdminWalletAlert.isHidden = false
                                            self.btnNewTrip.isHidden = true
                                        } else {
                                            self.viewForAdminWalletAlert.isHidden = true
                                            if preferenceHelper.getIsProviderInitiateTrip() == true {
                                                self.btnNewTrip.isHidden = false
                                            }else {
                                                self.btnNewTrip.isHidden = true
                                            }
                                        }
                                    } else {
                                        self.viewForAdminWalletAlert.isHidden = true
                                        if preferenceHelper.getIsProviderInitiateTrip() == true {
                                            self.btnNewTrip.isHidden = false
                                        } else {
                                            self.btnNewTrip.isHidden = true
                                        }
                                    }
                                    self.serviceTypeId = self.providerDetailResponse.provider.serviceType;
                                    self.getCountriesAndCity()
                                }
                            }
                        }
                    } catch {
                        print("data may be wrong")
                    }
                }
                if isCallCountyCity {
                    self.getCountriesAndCity()
                }
            }
        }
    }

    func wsGoOnline() {
        Utility.showLoading()

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.PROVIDER_IS_ACTIVE : TRUE]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_TOGGLE_STATE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, data, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                ProviderSingleton.shared.provider.isActive = TRUE
                self?.updateUiForOnlineOffline()
                self?.updateLocation()
                self?.setDoingRegularRide()
            }
        }
    }
    func wsGoOfline() {
        Utility.showLoading()
        
        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.PROVIDER_IS_ACTIVE : FALSE]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_TOGGLE_STATE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data) {
                ProviderSingleton.shared.provider.isActive = FALSE
                self.updateUiForOnlineOffline()
                self.bottomSheetVC.closeBottomSheet()
            }else {
            }
        }
    }
    func wsDropOff() {
        Utility.showLoading()
        
        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.VEHICLE_ID : ProviderSingleton.shared.currentVehicle.id]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_DROP_HUB_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data, withSuccessToast: true) {
                self.wsGetProviderDetail()
                self.btnGoOnline.isHidden = true
                self.viewForAdminAlert.isHidden = true
            }
        }
    }
    func setDoingRegularRide() {
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.IS_GOING_HOME] = false
        
        Utility.showLoading()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.TOGGLE_GO_HOME, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response,data,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                ProviderSingleton.shared.provider.isGoHome = FALSE
                self?.bottomSheetVC.customWillAppear()
            }
        }
    }

    func wsGetTrips() {
        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken()]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_TRIPS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            Utility.hideLoading()
            self.arrBid.removeAll()
            if Parser.isSuccess(response: response, data: data, andErrorToast: false) {
                let jsonDecoder = JSONDecoder()
                do {
                    let providerTripsResponse:GetTrips = try jsonDecoder.decode(GetTrips.self, from: data!)
                    if providerTripsResponse.trip_detail.count > 0 {
                        ProviderSingleton.shared.tripId = providerTripsResponse.trip_detail.first ?? ""
                        APPDELEGATE.gotoTrip()
                    }
                    if providerTripsResponse.bids.count > 0 {
                        self.arrBid.append(contentsOf: providerTripsResponse.bids)
                        self.startTripBidsListner()
                        if let vw = APPDELEGATE.window?.viewWithTag(DialogTags.tripBidingDialog) as? AcceptedBidTrips {
                            vw.reloadTrips(arrBids: self.arrBid)
                        }
                    } else {
                        if let vw = APPDELEGATE.window?.viewWithTag(DialogTags.tripBidingDialog) as? AcceptedBidTrips {
                            vw.removeFromSuperview()
                        }
                    }
                    self.btnBidTrips.isHidden = !(providerTripsResponse.bids.count > 0)
//                    if !self.btnBidTrips.isHidden{
//
//                        self.btnOffline.isHidden = true
//                    }else{
//                        self.btnOffline.isHidden = false
//                    }
                    self.bottomSheetVC.closeBottomSheet()
                    self.bottomSheetVC.isShow = !(providerTripsResponse.bids.count > 0)
                }catch let err {
                    print(err.localizedDescription)
                }
            } else {
                if let vw = APPDELEGATE.window?.viewWithTag(DialogTags.tripBidingDialog) as? AcceptedBidTrips {
                    vw.removeFromSuperview()
                }
            }
        }
    }

    func wsUpdateProviderType() {
        Utility.showLoading()

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.TYPE_ID:serviceTypeId]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_UPDATE_TYPE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            Utility.hideLoading()
            if Parser.parseTrips(response: response, data: data) {
                APPDELEGATE.gotoMap()
            }
        }
    }
    
    func wsProviderCreateTrip() {
        Utility.showLoading()

        var dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken()]
        if !self.txtDestinationAddress.text!.isEmpty {
            dictParam[PARAMS.D_LATITUDE] = destinationCoordinate.latitude.toString(places: 6)
            dictParam[PARAMS.D_LONGITUDE] = destinationCoordinate.longitude.toString(places: 6)
            dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = self.txtDestinationAddress.text
        } else {
            dictParam[PARAMS.D_LATITUDE] = ""
            dictParam[PARAMS.D_LONGITUDE] = ""
            dictParam[PARAMS.TRIP_DESTINATION_ADDRESS] = ""
        }
        dictParam[PARAMS.LATITUDE] = pickupCoordinate.latitude.toString(places: 6)
        dictParam[PARAMS.LONGITUDE] = pickupCoordinate.longitude.toString(places: 6)
        dictParam[PARAMS.TRIP_PICKUP_ADDRESS] = pickupAddress
        dictParam[PARAMS.PAYMENT_MODE] = PaymentMode.CASH
        dictParam[PARAMS.SERVICE_TYPE_ID] = ProviderSingleton.shared.provider.serviceType
        dictParam[PARAMS.FIRST_NAME] = txtFirstName.text ?? ""
        dictParam[PARAMS.LAST_NAME] = txtLastName.text ?? ""
        dictParam[PARAMS.PHONE] = txtPhoneNumber.text ?? ""
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = txtCountryPhoneCode.text ?? ""
        dictParam[PARAMS.EMAIL] = txtEmail.text ?? ""
        dictParam[PARAMS.TIMEZONE] = ProviderSingleton.shared.timeZone
        dictParam [PARAMS.IS_SURGE_HOURS] = checkSurgeTime(startHour: self.providerDetailResponse.typeDetails.surgeStartHour.toString(), endHour: self.providerDetailResponse.typeDetails.surgeEndHour.toString(), serverTime: self.providerDetailResponse.typeDetails.serverTime)
        dictParam[PARAMS.SURGE_MULTIPLIER] = self.providerCityType.surgeMultiplier
        dictParam["is_women_trip"] = ProviderSingleton.shared.provider.gender_type == 0 ? false : true
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_CREATETRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            self.viewForProviderTripOverlay.isHidden = true
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                let providerTripsResponse:TripsRespons = TripsRespons(dics: response)
                ProviderSingleton.shared.tripUser = providerTripsResponse.user
                ProviderSingleton.shared.tripId = providerTripsResponse.tripId
                self.stopSocketTripListner()
                APPDELEGATE.gotoTrip()
            }
        }
    }
    
    func wsGetHeatMapLocations() {
        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken()]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_HEAT_MAP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in

            if Parser.isSuccess(response: response, data: data,withSuccessToast: false,andErrorToast: false) {
                var list = [GMUWeightedLatLng]()
                let jsonDecoder = JSONDecoder()
                do {
                    let heatMapResponse:HeatMapResponse =  try jsonDecoder.decode(HeatMapResponse.self, from: data!)
                    for pickupLocations in heatMapResponse.pickupLocations {
                        let lat = pickupLocations.sourceLocation[0]
                        let lng = pickupLocations.sourceLocation[1]
                        let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , lng ), intensity: 1.0)
                        list.append(coords)
                    }
                    self.heatmapLayer.maximumZoomIntensity = 17
                    self.heatmapLayer.minimumZoomIntensity = 10
                    self.heatmapLayer.map = self.mapView
                    self.heatmapLayer.weightedData = list
                } catch {
                }
            }
        }
    }

    func wsGetVehicleListInCurrentCity(strCountry: String, strCity: String) {
        Utility.showLoading()
         
        if ProviderSingleton.shared.currentCoordinate.latitude == 0 && ProviderSingleton.shared.currentCoordinate.longitude == 0 {
            Utility.hideLoading()
            return
        }
        
        if strCountry.isEmpty() && strCity.isEmpty() {
            Utility.hideLoading()
            return
        }

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.COUNTRY:strCountry,
              PARAMS.CITY:strCity,
              PARAMS.LATITUDE : ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),
              PARAMS.LONGITUDE : ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6)]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_TYPELIST_SELETED_CITY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in

            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data,withSuccessToast: false,andErrorToast: false) {
                let jsonDecoder = JSONDecoder()
                do {
                    let cityListResponse:CityListResponse =  try jsonDecoder.decode(CityListResponse.self, from: data!)
                    ProviderSingleton.shared.isApplePayModeAvailable = (cityListResponse.cityDetail?.isPaymentModeApplePay == 1)
                    
                    //if cityListResponse.cityDetail?.countryid ?? "" ==
                    
                    var isTypeAvailable = false
                    if let arrayForTypes = cityListResponse.citytypes {
                        for carType in arrayForTypes {
                            let typeDetail = carType.typeDetails
                            if ((carType.typeid == self.providerDetailResponse.provider.admintypeid) && (self.providerDetailResponse.provider.serviceType == carType.id)) {
                                isTypeAvailable = true
                                self.providerCityType = carType
                            } else {
                                if ((carType.typeid == self.providerDetailResponse.provider.admintypeid) && !(self.providerDetailResponse.provider.serviceType == carType.id) && ProviderSingleton.shared.provider.isApproved == TRUE) {
                                    isTypeAvailable = true;
                                    self.serviceTypeId = carType.id;

                                    var basePrice:String = ""
                                    var timePrice:String = ""
                                    var distancePrice:String = ""

                                    if typeDetail.basePriceDistance == 0.0 {
                                        basePrice =  carType.basePrice.toCurrencyString()
                                    } else if typeDetail.basePriceDistance == 1.0 {
                                        basePrice = carType.basePrice.toCurrencyString() + "/" +  Utility.getDistanceUnit(unit: typeDetail.unit)
                                    } else {
                                        basePrice =  carType.basePrice.toCurrencyString() +
                                            "/" + carType.basePriceDistance.toString() + Utility.getDistanceUnit(unit: typeDetail.unit)
                                    }

                                    distancePrice = carType.pricePerUnitDistance.toCurrencyString() + "/" +  Utility.getDistanceUnit(unit: typeDetail.unit)
                                    timePrice = carType.priceForTotalTime.toCurrencyString() +  "/" +  MeasureUnit.MINUTES
                                    //self.openVisiterTypeDialog(typeName: typeDetail.typename, baseFareCost: basePrice, minFareCost:timePrice, distanceFareCost: distancePrice)
                                    break;
                                }
                            }
                        }
                        if (!isTypeAvailable) {
                            for carType in arrayForTypes {
                                let typeDetail:TypeDetail = carType.typeDetails
                                let isVisitType = typeDetail.serviceType;

                                if((isVisitType == TRUE) && !(self.providerDetailResponse.provider.serviceType == carType.id) && ProviderSingleton.shared.provider.isApproved == TRUE) {
                                    isTypeAvailable = true;
                                    self.serviceTypeId = carType.id;

                                    var basePrice:String = ""
                                    var timePrice:String = ""
                                    var distancePrice:String = ""
                                    if typeDetail.basePriceDistance == 0.0 {
                                        basePrice = carType.basePrice.toCurrencyString()
                                    } else if typeDetail.basePriceDistance == 1.0 {
                                        basePrice = carType.basePrice.toCurrencyString() + "/" +  Utility.getDistanceUnit(unit: typeDetail.unit)
                                    } else {
                                        basePrice = carType.basePrice.toCurrencyString() +
                                            "/" + carType.basePriceDistance.toString() + Utility.getDistanceUnit(unit: typeDetail.unit)
                                    }
                                    distancePrice = carType.pricePerUnitDistance.toCurrencyString() + "/" +  Utility.getDistanceUnit(unit: typeDetail.unit)
                                    timePrice =  carType.priceForTotalTime.toCurrencyString() +  "/" +  MeasureUnit.MINUTES
                                    //self.openVisiterTypeDialog(typeName: typeDetail.typename, baseFareCost: basePrice, minFareCost:timePrice, distanceFareCost: distancePrice)
                                    break;
                                }
                            }
                        }
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }
    }

    func wsCheckTypeCurrentCity(strCountry:String,strCity:String) {
        Utility.showLoading()

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.COUNTRY:strCountry,
              PARAMS.CITY:strCity,
              PARAMS.LATITUDE : ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),
              PARAMS.LONGITUDE : ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6)]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_TYPELIST_SELETED_CITY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in

            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data,withSuccessToast: false,andErrorToast: false) {
                let jsonDecoder = JSONDecoder()
                do {
                    let cityListResponse:CityListResponse =  try jsonDecoder.decode(CityListResponse.self, from: data!)
                    var isTypeAvailable = false
                    if let arrayForTypes = cityListResponse.citytypes {
                        for carType in arrayForTypes {
                            //let typeDetail = carType.typeDetails
                            if ((carType.typeid == self.providerDetailResponse.provider.admintypeid) && (self.providerDetailResponse.provider.serviceType == carType.id)) {
                                print(isTypeAvailable)
                                isTypeAvailable = true
                                self.providerCityType = carType
                                self.wsGetFareEstimate()
                                break;
                            }
                        }
                    }
                } catch {
                    print("wrong response parsing")
                }
            }
        }
    }
    
    func wsGetHubVehicleList() {
        
        Utility.showLoading()

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.LATITUDE : ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),
              PARAMS.LONGITUDE : ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6)]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_PROVIDER_HUB_VEHICLE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in

            Utility.hideLoading()
           
            if let errorCode = response["error_code"] as? String{
                print("\(errorCode)")
                if errorCode == "625"{
                    let noHubs = NoHubListPopup.showCustomVerificationDialog()
                    noHubs.onClickCancelButton = {
                        [unowned noHubs] in
//                        self.initialViewSetup()
                        noHubs.removeFromSuperview()
                    }
                    noHubs.onClickGoToHubButton = {
                        [unowned noHubs] in
//                        self.initialViewSetup()
                        //goto Hub
                        noHubs.removeFromSuperview()
                        let vc = UIStoryboard(name: "Hub", bundle: nil).instantiateViewController(withIdentifier: "HubListVC")
                        self.navigationController!.pushViewController(vc, animated: true)
                      
                    }
                    
                }
                else if errorCode == "626" {
                    Utility.showToast(message: "ERROR_CODE_626".localized)
                }
                else{
                    
                }
            }
            if Parser.isSuccess(response: response, data: data,withSuccessToast: false,andErrorToast: false) {
                let jsonDecoder = JSONDecoder()
                do {
                    let hubVehicleListResponse:HubVehicleListResponse =  try jsonDecoder.decode(HubVehicleListResponse.self, from: data!)
                    self.openHubVehicleList(vehicleResponse: hubVehicleListResponse)
                } catch {
                    print("wrong response parsing")
                }
            }else{
                let errorCode = response["error_code"] as? String
                print("\(errorCode)")
            }
        }
    }


    @objc func watchTimer() {
        wsGetTrips()
    }
}

extension MapVC: CLLocationManagerDelegate {

    func fillCurrentLocation() {
        txtCountryPhoneCode.text = ProviderSingleton.shared.provider.countryPhoneCode
        _ = txtCountryPhoneCode.becomeFirstResponder()
        _ = txtCountryPhoneCode.resignFirstResponder()
        txtDestinationAddress.text = ""
        destinationCoordinate = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
        destinationAddress = ""
        txtEmail.text = ""
        txtFirstName.text = ""
        txtLastName.text = ""
        txtPhoneNumber.text = ""
        self.lblFareEstimateValue.text = 0.0.toCurrencyString()
       
        LocationCenter.default.getAddressFromLatitudeLongitude(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude, completion: { (address, locations) in
            self.txtPickupAddress.text = address
            self.pickupCoordinate = CLLocationCoordinate2D.init(latitude: locations[0], longitude: locations[1])
            self.pickupAddress = address
            self.txtPickupAddress.isEnabled = self.pickupAddress.isEmpty()
            self.viewForProviderTripOverlay.isHidden = false
        })
    }

    func updateLocation() {
        if ProviderSingleton.shared.currentCoordinate.latitude != 0.0 && ProviderSingleton.shared.currentCoordinate.longitude != 0.0 {
            let dictParam:[String:Any] =
                [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                 PARAMS.TOKEN : preferenceHelper.getSessionToken(),
                 PARAMS.LATITUDE : ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),
                 PARAMS.LONGITUDE : ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6),
                 PARAMS.BEARING :ProviderSingleton.shared.bearing,
                 Google.LOCATION : [[ProviderSingleton.shared.currentCoordinate.latitude.toString(places: 6),ProviderSingleton.shared.currentCoordinate.longitude.toString(places: 6),Date().timeIntervalSince1970 * 1000
                    ]]]
            if self.socketHelper.socket?.status == .connected {
                if ProviderSingleton.shared.provider.isActive == TRUE {
                    if !preferenceHelper.getUserId().isEmpty() {
                        if self.isUpdateLocation {
                            self.isUpdateLocation = false
                            self.socketHelper.socket?.emitWithAck(self.socketHelper.locationEmit, dictParam).timingOut(after: 0) {data in
                                self.isUpdateLocation = true
                                print(data)
                                guard let response = data.first as? [String:Any] else { return }
                                let jsonData = try? JSONSerialization.data(withJSONObject:response)
                                
                                if let is_active = (response["is_active"] as? Int) {
                                    print("Active \(is_active)")
                                }
                                if let zone_queue_id = (response["zone_queue_id"] as? String) {
                                    print("zone_queue_id \(zone_queue_id)")
                                    if let zone_name = (response["zone_name"] as? String) {
                                        print("zone_name \(zone_name)")
                                        let zone_queue_number = (response["zone_queue_number"] as? Int) ?? 0
                                        if zone_queue_id != "" && zone_name != ""{
                                            self.viewZoneFull.isHidden = false
                                            self.zoneId = zone_queue_id
                                            self.lblZone.text = "\(zone_name) - \(zone_queue_number)"
                                            self.socketZoneListner(zoneId: self.zoneId)
                                        }else{
//                                            self.socketHelper.socket?.off("'\(self.zoneId)'")
//                                            self.viewZoneFull.isHidden = true
//                                            self.zoneId = ""
                                        }
                                        //21.594788907838556, 71.22465008559249
                                    }
                                    if let zone_queue_id = (response["zone_queue_id"] as? Int) {
                                        print("zone_queue_id \(zone_queue_id)")
                                    }
                                    
                                }
                                /*
                                 if self.providerDetailResponse.provider.zone_queue_id != "" && self.providerDetailResponse.provider.zone_name != ""{
                                     self.viewZoneFull.isHidden = false
                                     self.lblZone.text = "\(self.providerDetailResponse.provider.zone_name) - \(self.providerDetailResponse.provider.zone_queue_id)"
                                 }else{
                                     self.viewZoneFull.isHidden = true
                                 }
                                 
                                 */
                            }
                        }
                    } else {
                        self.stopSocketTripListner()
                        APPDELEGATE.gotoLogin()
                    }
                }
            } else {
//                self.updateLocation()
                socketHelper.socket?.connect()
                self.isUpdateLocation = true
            }
        }
    }

    func animateToCurrentLocation() {
        let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17.0, bearing: ProviderSingleton.shared.bearing, viewingAngle: 0.0)

        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        self.mapView?.animate(to: camera)
        //self.mapView.camera = camera
        self.currentMarker.position = position
        CATransaction.commit()
    }

    func checkSurgeTime(startHour:String,endHour:String,serverTime:String) -> Int {
        let currentDate:Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = DateFormat.WEB
        let tempDateFormatter = DateFormatter.init()
        tempDateFormatter.dateFormat = DateFormat.WEB
        tempDateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        guard let serverDateTime = tempDateFormatter.date(from: serverTime) else {
            print("server time not found")
            return FALSE
        }
        tempDateFormatter.timeZone = TimeZone.init(identifier: ProviderSingleton.shared.timeZone)
        let tempStrDate = tempDateFormatter.string(from: serverDateTime)
        guard let tempDate = tempDateFormatter.date(from: tempStrDate) else {
            print("temp date not found")
            return FALSE
        }
        let cal:Calendar = Calendar.current
        let serverHour:Int = cal.component(Calendar.Component.hour, from: tempDate)
        let serverMinut:Int = cal.component(Calendar.Component.minute, from: tempDate)
        var isSurge: Bool = false
        
        for surgeHours in providerCityType.surgeHours {
            if surgeHours.day == serverDateTime.dayNumberOfWeek().toString() {
                for dayTime in surgeHours.dayTime {
                    
                    var startHour = 0;
                    var startMinut = 0;
                    var endHour = 0;
                    var endMinut = 0;
                    
                    if dayTime.startTime.contains(":") {
                        let time = dayTime.startTime.components(separatedBy: ":")
                        startHour = time[0].toInt()
                        startMinut = time[1].toInt()
                    }
                    if dayTime.endTime.contains(":") {
                        let time = dayTime.endTime.components(separatedBy: ":")
                        endHour = time[0].toInt()
                        endMinut = time[1].toInt()
                    }
                    if let surgeStartDate:Date = Calendar.current.date(bySettingHour: startHour, minute: startMinut, second: 0, of: currentDate) {
                        if let surgeEndDate:Date = Calendar.current.date(bySettingHour: endHour, minute: endMinut, second: 0, of: currentDate) {
                            if let currentTime:Date = Calendar.current.date(bySettingHour: serverHour, minute: serverMinut, second: 0, of: currentDate) {
                                if ((surgeStartDate <= currentTime) && (surgeEndDate >= currentTime) && (providerCityType.isSurgeHours == TRUE)) {
                                    providerCityType.surgeMultiplier = dayTime.multiplier.toDouble()
                                    isSurge = true
                                    break;
                                }else {
                                    isSurge = false
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if (isSurge) {
            providerCityType.surgeMultiplier = providerCityType.richAreaSurgeMultiplier >  providerCityType.surgeMultiplier ? providerCityType.richAreaSurgeMultiplier :providerCityType.surgeMultiplier
            
            let isTestSurgeHour =  (providerCityType.surgeMultiplier != 1.0 && providerCityType.surgeMultiplier > 0.0)
            if isTestSurgeHour {
                return TRUE
            }else {
                return FALSE
            }
        } else if (providerCityType.surgeMultiplier != 1.0 && providerCityType.richAreaSurgeMultiplier > 0.0) {
            providerCityType.surgeMultiplier =   providerCityType.richAreaSurgeMultiplier
            return TRUE
        } else {
            return FALSE
        }
    }
}

extension MapVC:UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCountryPhoneCode {
            _ = textField.resignFirstResponder()
        } else if textField == txtPickupAddress {
            pickupAddress = ""
            autoCompleteTop.constant = viewForSourceAddress.frame.maxY + 60
        } else if textField == txtDestinationAddress {
            destinationAddress = ""
            autoCompleteTop.constant = viewForDestination.frame.maxY + 60
        } 
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtDestinationAddress {
            _ = txtFirstName.becomeFirstResponder()
        }
        if textField == txtFirstName {
            _ = txtLastName.becomeFirstResponder()
        }
        if textField == txtLastName {
            _ = txtEmail.becomeFirstResponder()
        } else if textField == txtEmail {
            _ = txtPhoneNumber.becomeFirstResponder()
            //openCountryDialog(textField)
            //view.endEditing(true)
        } else if textField == txtPhoneNumber {
            _ = txtPhoneNumber.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func searching(_ sender: UITextField) {
        if sender == txtPickupAddress {
            tblForAutoComplete.tag = 0
        } else {
            tblForAutoComplete.tag = 1
        }
        if (sender.text?.count)! > 2 {
            self.arrForAutoCompleteAddress.removeAll()
            LocationCenter.default.googlePlacesResult(input: sender.text!, completion: { [unowned self] (array) in
                if array.count > 0 && sender.text!.count > 2 {
                    self.arrForAutoCompleteAddress = array
                    self.tblForAutoComplete.reloadData()
                    self.autoCompleteHeight.constant = CGFloat(50 * array.count)
                    self.tblForAutoComplete.isHidden = false
                } else {
                    self.tblForAutoComplete.isHidden = true
                }
            })
        } else {
            self.tblForAutoComplete.isHidden = true
        }
    }

    @objc func openCountryDialog(_ sender:UITextField) {
        dialogForCountry = CustomCountryDialog.showCustomCountryDialog(withDataSource: NSMutableArray(array: ProviderSingleton.shared.arrForCountries),isForInitialTrip: true)
        self.dialogForCountry?.on_Country_Selected = { [unowned self, weak dialogForCountry = self.dialogForCountry] (country:CountryList) in
            txtCountryPhoneCode.text = country.countryPhoneCode
            strCountryCode = country.countryCode
            dialogForCountry?.removeFromSuperview()
        }
    }
    
    func openAcceptedTrips(arrBid: [Bids]) {
        let dialog = AcceptedBidTrips.showDialog(arrBids: arrBid)
        dialog.onClickLeftButton = {
            dialog.removeFromSuperview()
        }
        dialog.onRejectTrip = { [weak self] in
            guard let self = self else { return }
            self.wsGetTrips()
        }
    }
    
    func openHubVehicleList(vehicleResponse: HubVehicleListResponse) {
        let dialog = DialogHubVehicles.showDialog(vehicleResponse: vehicleResponse)
        dialog.onClickLeftButton = {
            dialog.removeFromSuperview()
        }
        dialog.onPickUp = { dialog in
            self.wsGetProviderDetail()
            dialog.removeFromSuperview()
        }
    }
}

extension MapVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAutoCompleteAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutocompleteCell
        if indexPath.row < self.arrForAutoCompleteAddress.count {
            autoCompleteCell.setCellData(place: arrForAutoCompleteAddress[indexPath.row])
        }
        return autoCompleteCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        tblForAutoComplete.isHidden = true

        if indexPath.row < arrForAutoCompleteAddress.count {
            let placeID = arrForAutoCompleteAddress[indexPath.row].placeid
            let address = self.arrForAutoCompleteAddress[indexPath.row].address
            let placeClient = GMSPlacesClient.shared()

            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue)))
            placeClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: GoogleAutoCompleteToken.shared.token, callback: { (place: GMSPlace?, error: Error?) in
                if let error = error {
                    // TODO: Handle the error.
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }

                if let place = place {
                    if self.tblForAutoComplete.tag == 0 {
                        self.txtPickupAddress.text = address
                        self.pickupAddress = address
                        self.pickupCoordinate = place.coordinate
                    }else {
                        self.txtDestinationAddress.text = address
                        self.destinationAddress = address
                        self.destinationCoordinate = place.coordinate
                    }
                    self.wsCheckTypeCurrentCity(strCountry: self.strCountry, strCity: self.strCurrentCity)
                }
            })
        }
    }
}

extension MapVC {
    
    func getCountriesAndCity() {
        LocationCenter.default.fetchCityAndCountry(location: Common.location) { (city, country, error) in
            if country  != nil {
                self.strCountry = country!
            }
            if city != nil {
                self.strCurrentCity = city!
            }
            self.wsGetVehicleListInCurrentCity(strCountry: self.strCountry, strCity: self.strCurrentCity)
        }
    }

    func socketTripListner() {
        let myProviderId: String = "'\(socketHelper.get_new_trip)\(preferenceHelper.getUserId())'"
        print("My Provider ID: \(myProviderId)")
        self.socketHelper.socket?.emit("room", myProviderId)
        self.socketHelper.socket?.on(myProviderId, callback: {  [weak self] (data, ack) in
            print("socket trip accept reject call: \(myProviderId)")
            guard let self = self else { return }
            guard let response = (data.first as? [String:Any]) else
            { return }
//            if let start = response["is_schedule_started"] as? Bool{
//
//            }
            Utility.wsGetAppSetting {
                if let start = response["is_schedule_started"] as? Bool{
                    if start{
                        self.wsGetTrips()
                    }
                }
                if preferenceHelper.getIsRequiredForceUpdate() {
                    if Utility.isUpdateAvailable(Utility.getLatestVersion()) {
                        self.showUpdate()
                    } else {
                        self.goToTrip(response: response)
                    }
                } else {
                    self.goToTrip(response: response)
                }
            }
        })
    }
    
    func socketZoneListner(zoneId : String) {
        //   self.socketHelper.socket?.off("'\(bid.trip_id ?? "")'")
        let zone = "'\(zoneId)'"
        self.socketHelper.socket?.emit("room", zone)
        self.socketHelper.socket?.on(zone, callback: {  [weak self] (data, ack) in
            print("socket socketZoneListner: \(zoneId)")
            guard let self = self else { return }
            guard let response = (data.first as? [String:Any]) else
            { return }
            if let isNewAdded = response["is_new_added"] as? Bool{
                if isNewAdded == false{
                    self.wsGetProviderDetail()
                }
            }
            
//            if let start = response["zone_queue_id"] as? String{
//                if let start = response["zone_name"] as? String{
//
//
//                }
//            }
        })
    }
    
    
    func goToTrip(response: [String:Any]) {
        if let requestId: String = response["trip_id"] as? String, !requestId.isEmpty() {
            ProviderSingleton.shared.timeLeftToRespondTrip = (response["time_left_to_responds_trip"] as? Int) ?? 0
            ProviderSingleton.shared.tripId = requestId
            APPDELEGATE.gotoTrip()
        }
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

    func stopSocketTripListner() {
        let myProviderId: String = "'\(socketHelper.get_new_trip)\(preferenceHelper.getUserId())'"
        self.socketHelper.socket?.off(myProviderId)
    }
    
    
}

class AutocompleteCell: TblVwCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewForAutocomplete: UIView!
    @IBOutlet weak var lblDivider: UILabel!

    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }

    //MARK: - SET CELL DATA
    func setCellData(place:(title:String,subTitle:String,address:String,placeid:String)) {
        lblTitle.text = place.title
        lblSubTitle.text = place.subTitle
    }

    func setLocalization() {
        //Colors
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForAutocomplete.backgroundColor = UIColor.white
        lblDivider.backgroundColor = UIColor.themeDividerColor
        
        lblTitle.textColor = UIColor.themeTitleColor
        lblSubTitle.textColor = UIColor.themeLightTextColor
        /*Set Font*/
        lblTitle.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblSubTitle.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
