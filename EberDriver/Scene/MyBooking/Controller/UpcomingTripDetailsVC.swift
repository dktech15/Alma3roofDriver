//
//  UpcomingTripDetailsVC.swift
//  EberDriver
//
//  Created by Rohit on 16/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps

protocol UpcomingTripUpdateDelegate: AnyObject {
    func updateTripData()
}


class UpcomingTripDetailsVC: UIViewController {
//    class func viewController(tripID: Trip) -> UpcomingTripDetailsVC {
//
//        let vc = UIStoryboard.mapStoryboard().instantiateViewController(withIdentifier: "UpcomingTripDetailsVC") as! UpcomingTripDetailsVC
//        vc.upcomingTrip = tripID
//        return vc
//    }
//
    weak var delegate: UpcomingTripUpdateDelegate?
    
    @IBOutlet var stackView: UIStackView!

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
   
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var roundedView: UIView!

    @IBOutlet weak var lblTripNo: UILabel!

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    
    @IBOutlet weak var tblMultipleStops: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!

    @IBOutlet var btnExpandMap: UIButton!
    @IBOutlet var imgExpandMap: UIImageView!
    
//    @IBOutlet weak var btnCancelTrip: UIButton!

    

    var rate:Float =  0.0
    let toolBar = UIToolbar()
    
    var hasMultipleStopPoints = false
    var arrLocations = [DestinationAddresses]()
    var upcomingTrip : Trip!
    var pendingTrip = PendingTrip()
    
    

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightTable.constant = 0
        self.tblMultipleStops.delegate = self
        self.tblMultipleStops.dataSource = self
        self.tblMultipleStops.register(UINib(nibName: StopLocationTVC.className, bundle: nil), forCellReuseIdentifier: StopLocationTVC.className)
        self.heightTable.constant = CGFloat(self.arrLocations.count * 30)
        
        self.initialViewSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.bringSubviewToFront(btnExpandMap)
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    //MARK: - Set localized layout
    func initialViewSetup() {
        roundedView.backgroundColor = UIColor.themeSelectionColor
        lblTitle.text = "TXT_HISTORY".localized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor


        lblDate.textColor = UIColor.themeButtonTitleColor
        lblDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblDate.backgroundColor = UIColor.themeSelectionColor
        
        lblTripNo.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblTripNo.textColor = UIColor.themeLightTextColor
        
        lblPickupAddress.text = "TXT_PICKUP_ADDRESS".localized
        lblPickupAddress.textColor = UIColor.themeTextColor
        lblPickupAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblDestinationAddress.text = "TXT_DESTINATION_ADDRESS".localized
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        rate = 0.0
        
        self.title = "TXT_FEEDBACK".localized

//        btnExpandMap.setTitle(FontAsset.icon_expand, for: .normal)
//        btnExpandMap.setRoundIconButton()
//        btnExpandMap.setTitleColor(UIColor.white, for: .normal)
        
//        btnBack.setupBackButton()
        self.setData()
    }
    
    func setData() {
//        if self.pendingTrip.destination_address!.count > 0 {
//            self.hasMultipleStopPoints = true
//            self.arrLocations = self.upcomingTrip.destinationAddresses
//            self.heightTable.constant = CGFloat(self.arrLocations.count * 30)
//            self.tblMultipleStops.reloadData()
//        }
//        else {
//
//        }
        self.setUserDetail()
//        DispatchQueue.main.async { [unowned self] in
//            let tripDetail:Trip = self.upcomingTrip
//            self.setupMap(tripDetail: tripDetail)
//        }
    }

    @IBAction func onClickBtnExpandMap(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
        }, completion: { (complete) in
            self.headerView.isHidden.toggle()
            self.updateViewConstraints();
            self.stackView.layoutIfNeeded()
        })
    }

    
    @IBAction func onCancelTripClicked(_ sender: UIButton) {
        Utility.getCancellationReasons { [weak self] reasons in
            self?.openCanceTripDialog(arrReason: reasons)
        }
        
    }
    
    func openCanceTripDialog(arrReason: [String])
    {
        let dialogForTripStatus = CustomCancelTripDialog.showCustomCancelTripDialog(title: "TXT_CANCEL_TRIP".localized, message: "TXT_CANCELLATION_CHARGE_MESSAGE".localized, cancelationCharge: "0", titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        dialogForTripStatus.arrReason = arrReason
        dialogForTripStatus.onClickLeftButton =
        { [unowned dialogForTripStatus] in
            dialogForTripStatus.removeFromSuperview();
        }
        dialogForTripStatus.onClickRightButton = {
            [unowned self, unowned dialogForTripStatus] (reason) in
            self.wsCancelTrip(dialog: dialogForTripStatus,reason: reason)
        }
    }
    
    func setupLayout() {
        navigationView.navigationShadow()
        roundedView.sizeToFit()
        roundedView.setRound(withBorderColor: .clear, andCornerRadious: (roundedView.frame.height/2), borderWidth: 0)
    }

    //MARK: - Button action method
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Web Service
    func wsCancelTrip(dialog:CustomCancelTripDialog,reason:String)
    {
//        if !self.upcomingTrip.id.isEmpty()
//        {
//            Utility.showLoading()
//            var  dictParam : [String : Any] = [:]
//            dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
//            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
//            dictParam[PARAMS.TRIP_ID] = self.upcomingTrip.id
//            dictParam[PARAMS.CANCEL_TRIP_REASON] = reason
//
//
//            let afh:AlamofireHelper = AlamofireHelper.init()
//            afh.getResponseFromURL(url: WebService.CANCEL_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
//                [unowned self, unowned dialog] (response, error) -> (Void) in
//                if (error != nil)
//                {Utility.hideLoading()}
//                else
//                {
//                    if Parser.isSuccess(response: response)
//                    {
//                        dialog.removeFromSuperview()
//                        self.delegate?.updateTripData()
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    else
//                    {
//
//                    }
//                }
//
//            }
//        }
//        else
//        {
//            dialog.removeFromSuperview()
//
//        }
    }

}

extension UpcomingTripDetailsVC: RatingViewDelegate, UITextViewDelegate
{
    
    func setUserDetail() {
//        guard let tripDetail = self.upcomingTrip else {return}

        lblTripNo.text =  ("TXT_TRIP_ID".localized + "\(pendingTrip.unique_id ??  0)")

//        var title = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: tripDetail.userCreateTime, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_FORMAT)) as String
//        if title == "Today"{
//            title = "TXT_TODAY".localized
//        } else if title == "Yesterday" {
//            title = "TXT_YESTERDAY".localized
//        }
//        lblDate.text = title + " " + Utility.stringToString(strDate: tripDetail.userCreateTime, fromFormat: DateFormat.WEB , toFormat: DateFormat.HISTORY_TIME_FORMAT)
        lblPickupAddress.text = pendingTrip.source_address
        self.lblDestinationAddress.text = pendingTrip.destination_address
    }

    func setupMap(tripDetail:Trip) {
        do {
            // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
            if Bundle.main.url(forResource: "styleable_map", withExtension: "json") != nil {
               // mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("The style definition could not be loaded: \(error)")
        }
        let sourceLoctions = CLLocationCoordinate2D.init(latitude: tripDetail.sourceLocation[0] , longitude: tripDetail.sourceLocation[1] )
        let destinationLocation = CLLocationCoordinate2D.init(latitude: tripDetail.destinationLocation[0] , longitude: tripDetail.destinationLocation[1] )
        

        let pickupMarker:GMSMarker = GMSMarker.init(position: sourceLoctions)
        pickupMarker.icon = Global.imgPinPickup
        pickupMarker.map = mapView

        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(sourceLoctions)
        
        if destinationLocation.latitude != 0 && destinationLocation.longitude != 0 {
            let destinationMarker:GMSMarker = GMSMarker.init(position: destinationLocation)
            destinationMarker.icon = Global.imgPinDestination
            destinationMarker.map = mapView
            bounds = bounds.includingCoordinate(destinationLocation)
        }
        
        
        if self.arrLocations.count > 0 {
            for stopApp in self.arrLocations {
                let wLat = stopApp.location[0]
                let wLong = stopApp.location[1]
                let location = CLLocationCoordinate2D(latitude: wLat, longitude: wLong)
                
                print("location: \(location)")
                let marker = GMSMarker()
                marker.icon = Global.imgPinSource
                marker.position = location
                marker.map = self.mapView
                
            }
        }

//        let locationArray = (self.historydetailResponse.startTripToEndTripLocations) ?? [tripDetail.sourceLocation]
//        let tempPath:GMSMutablePath = GMSMutablePath.init()

//        if locationArray.count > 1 {
//            for location in locationArray {
//                let coordinate = CLLocationCoordinate2D.init(latitude: location[0], longitude: location[1])
//                tempPath.add(coordinate)
//                bounds = bounds.includingCoordinate(coordinate)
//            }
//        }

//        let polyLinePath:GMSPolyline = GMSPolyline.init(path: tempPath)
//        polyLinePath.strokeWidth = 5.0
//        polyLinePath.strokeColor = UIColor.themeButtonBackgroundColor
//        polyLinePath.map = mapView
        CATransaction.begin()
        CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {}
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80.0))
        CATransaction.commit()
    }

    func RatingView(_ ratingView: RatingView, didUpdate rating: Float) {
        rate = rating
    }

    //MARK: - Web Service Calls
    
}

extension UpcomingTripDetailsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StopLocationTVC.className, for: indexPath) as! StopLocationTVC
        cell.setLocationData(address: arrLocations[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
