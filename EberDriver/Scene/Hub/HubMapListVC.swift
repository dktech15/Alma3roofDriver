//
//  HubMapListVC.swift
//  EberDriver
//
//  Created by Rohit on 24/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class HubMapListVC: UIViewController {
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var viewMapView: UIView!
    @IBOutlet weak var imgCurrentLocation: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var arrHub = [Hubs]()
    var seletedHub: Hubs?
    var currentMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalized()
        setMap()
        mapView.settings.compassButton = false
//        currentMarker.icon = UIImage(named: "asset-driver-pin-placeholder")
//        currentMarker.map = mapView
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateToCurrentLocation()
        self.showCurrentLocationOnMap()
    }
    func setLocalized() {
        lblTitle.text = "txt_hub".localized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
//        imgCurrentLocation.image = UIImage(named: "asset-my-location_u")
        imgCurrentLocation.tintColor = UIColor.themeImageColor
    }
    //MARK: - Get Current Location
    func setMap() {
        mapView.clear()
//        currentMarker.map = mapView
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
    func animateToCurrentLocation() {
        let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 12.0, bearing: ProviderSingleton.shared.bearing, viewingAngle: 0.0)

        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        self.mapView?.animate(to: camera)
        //self.mapView.camera = camera
        self.currentMarker.position = position
        CATransaction.commit()
    }
    func showCurrentLocationOnMap(){
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ProviderSingleton.shared.currentCoordinate.latitude, longitude: ProviderSingleton.shared.currentCoordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 12.0, bearing: ProviderSingleton.shared.bearing, viewingAngle: 0.0)

        
//        let camera = GMSCameraPosition.camera(withLatitude: 11.11, longitude: 12.12, zoom: 14.0) //Set default lat and long
//        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.size.width, height: self.viewMap.frame.size.height), camera: camera)
//        self.viewMap.addSubview(mapView)
        //asset-charging
        for data in arrHub{
            let location = CLLocationCoordinate2D(latitude: data.location![0], longitude: data.location![1])
            print("location: \(location)")
            let marker = GMSMarker()
            marker.position = location
            marker.snippet = data.name!
            marker.icon = UIImage(named: "asset-charging")
            marker.icon?.withTintColor(UIColor.themeImageColor)
            marker.map = mapView
        }
    }

    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

}
