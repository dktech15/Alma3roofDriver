//
//  LocationVC.swift
//  Elluminati
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@objc protocol LocationHandlerDelegate: AnyObject {
    func finalAddressAndLocation(address:String,latitude:Double,longitude:Double)
}

class LocationVC: BaseVC,UINavigationControllerDelegate,UIScrollViewDelegate,GMSMapViewDelegate {

    weak var delegate:LocationHandlerDelegate?

    //MARK: - Outlets
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet weak var tblAutocomplete: UITableView!
    @IBOutlet weak var heightForAutoComplete: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblIconSourceLocation: UILabel!
    @IBOutlet weak var imgIconSourceLocation : UIImageView!
    
    @IBOutlet weak var lblIconSetLocation: UILabel!
    @IBOutlet weak var imgIconSetLocation: UIImageView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var imgForLocation: UIImageView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var navigationView: UIView!

    @IBOutlet weak var viewForSingleAddress: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnClearAddress: UIButton!
    @IBOutlet weak var imgClearAddress: UIImageView!

    //MARK: - Variables
    var focusLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 22.30, longitude: 70.80)
    var address:String = "";
    var location:[Double] = [0.0,0.0];
    var flag:Int = AddressType.pickupAddress
    var arrForAdress:[(title:String,subTitle:String,address:String,placeid:String)] = []
    var country:String = "";

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad();
        setLocalization()
        self.tblAutocomplete.estimatedRowHeight = UITableView.automaticDimension
        self.mapView.padding = UIEdgeInsets.init(top: viewForSingleAddress.frame.maxY, left: 20, bottom: viewForSingleAddress.frame.maxY, right: 20)
        animateToCurrentLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewForSingleAddress.isHidden = false
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
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

    @IBAction func onClickBtnClearAddress(_ sender: Any) {
        txtAddress.text = "";
        tblAutocomplete.isHidden = true
    }

    func setLocalization() {
        //COLORS
        self.view.backgroundColor = UIColor.themeDialogBackgroundColor;
        self.viewForSingleAddress.backgroundColor = UIColor.themeDialogBackgroundColor
        self.txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        self.txtAddress.textColor = UIColor.themeTextColor
        self.txtAddress.delegate = self
        self.txtAddress.backgroundColor = UIColor.white

        self.btnDone.backgroundColor = UIColor.themeButtonBackgroundColor
        self.btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnDone.setTitle("TXT_CONFIRM".localizedCapitalized, for: .normal)
        self.btnDone.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        self.navigationView.backgroundColor = UIColor.clear

        self.mapView.bringSubviewToFront(self.imgForLocation)
        self.mapView.bringSubviewToFront(self.lblIconSourceLocation)
        self.mapView.delegate = self;
        // self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;

        imgClearAddress.tintColor = UIColor.themeImageColor

//        lblIconSetLocation.text = FontAsset.icon_location
//        lblIconSourceLocation.text = FontAsset.icon_pickup_location
//        imgIconSourceLocation.image = UIImage(named: "asset-pin-pickup-location")
//        btnClearAddress.setTitle(FontAsset.icon_cross_rounded, for: .normal)
//        btnCurrentLocation.setTitle(FontAsset.icon_btn_current_location, for: .normal)
        btnCurrentLocation.setImage(UIImage(named: "asset-pin-current-location"), for: .normal)

//        lblIconSetLocation.setForIcon()
//        lblIconSourceLocation.setForIcon()
//        btnCurrentLocation.setSimpleIconButton()
//        btnClearAddress.setSimpleIconButton()
        imgBack.tintColor = UIColor.themeImageColor
//        btnBack.setupBackButton()
    }

    @IBAction func onClickDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func setupLayout() {
        btnDone.setupButton()
        viewForSingleAddress.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        viewForSingleAddress.setShadow()
    }

    //MARK: - Button action methods
    @IBAction func onClickBtnDone(_ sender: UIButton) {
        if !address.isEmpty() && location[0] != 0.0 && location[1] != 0.0 {
            self.delegate?.finalAddressAndLocation(address: address, latitude: location[0], longitude: location[1])
            self.navigationController?.popViewController(animated: true)
        } else {
            Utility.showToast(message: "VALIDATION_MSG_INVALID_LOCATION".localized)
        }
    }

    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let myCoordinate = position.target
        LocationCenter.default.getAddressFromLatitudeLongitude(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude) { [weak self](address, locations) in
            guard let self = self else { return }
            self.address = address
            self.txtAddress.text = self.address
            self.txtAddress.resignFirstResponder()
            self.location = [myCoordinate.latitude, myCoordinate.longitude]
        }
    }

    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        gettingCurrentLocation()
    }

    override func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        guard let userInfo = ntf.userInfo else { return }
        guard let location = userInfo["location"] as? CLLocation else { return }
        ProviderSingleton.shared.currentCoordinate = location.coordinate
        self.mapView.animate(toLocation: ProviderSingleton.shared.currentCoordinate)
        LocationCenter.default.stopUpdatingLocation()
        self.animateToCurrentLocation()
    }
    
    func gettingCurrentLocation() {
        LocationCenter.default.addObserver(self, [#selector(self.locationUpdate(_:)), #selector(self.locationFail(_:)),#selector(locationAuthorizationChanged(_:))])
        LocationCenter.default.startUpdatingLocation()
    }

    func animateToCurrentLocation() {
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {}
        let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17.0, bearing: 45, viewingAngle: 0.0)
        self.mapView.animate(to: camera)
        CATransaction.commit()
    }

    func animateToLocation(coordinate:CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {}
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0, bearing: 45, viewingAngle: 0.0)
        self.mapView.animate(to: camera)
        CATransaction.commit()
    }

    @IBAction func searching(_ sender: UITextField) {
        if (sender.text?.count)! > 2 {
            LocationCenter.default.googlePlacesResult(input: sender.text!, completion: { [unowned self] (array) in
                self.arrForAdress = array
                if self.arrForAdress.count > 0 {
                    self.heightForAutoComplete.constant = self.tblAutocomplete.contentSize.height
                    self.tblAutocomplete.reloadData()
                    self.tblAutocomplete.isHidden = false
                } else {
                    self.tblAutocomplete.isHidden = true
                }
            })
        }
    }
}

extension LocationVC: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAdress.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutocompleteCell
        autoCompleteCell.setCellData(place: arrForAdress[indexPath.row])
        return autoCompleteCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        tblAutocomplete.isHidden = true
        let placeID = arrForAdress[indexPath.row].placeid
        let address = self.arrForAdress[indexPath.row].address
        let placeClient = GMSPlacesClient.shared()
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue)))
        placeClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: GoogleAutoCompleteToken.shared.token , callback: { (place: GMSPlace?, error: Error?) in
            GoogleAutoCompleteToken.shared.token = nil
            if let error = error {
                // TODO: Handle the error.
                return
            }

            if let place = place {
                self.address = address
                self.location = [place.coordinate.latitude,place.coordinate.longitude]
                self.txtAddress.text = address
                self.animateToLocation(coordinate: place.coordinate)
            }
        })
    }
}
