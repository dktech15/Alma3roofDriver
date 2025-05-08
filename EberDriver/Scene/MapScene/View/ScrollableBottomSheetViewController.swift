//
//  ScrollableBottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 10/15/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit

class ScrollableBottomSheetViewController: BaseVC {
    
    @IBOutlet  var headerView: UIView!
    /*Car View*/
    
    @IBOutlet  var carView: UIView!
    @IBOutlet  var imgCar: UIImageView!
    @IBOutlet  var btnChange: UIButton!
    @IBOutlet  var lblCarModel: UILabel!
    @IBOutlet  var lblServiceType: UILabel!
    @IBOutlet  var lblCarNumber: UILabel!
    
    @IBOutlet  var lblBasePrice: UILabel!
    @IBOutlet  var lblBasePriceValue: UILabel!
    
    @IBOutlet  var lblDistancePrice: UILabel!
    @IBOutlet  var lblDistancePriceValue: UILabel!
    
    @IBOutlet  var lblTimePrice: UILabel!
    @IBOutlet  var lblTimePriceValue: UILabel!
    
    @IBOutlet  var tblForVehicleDetail: UITableView!
    
    @IBOutlet  var btnAddNewVehicle: UIButton!
    @IBOutlet  var btnGoOffline: UIButton!
    
    @IBOutlet  var lblYourVehicle: UILabel!
    
    @IBOutlet  var viewForYourVehicle: UIView!
    @IBOutlet  var heightForHeader: NSLayoutConstraint!
    
    @IBOutlet weak var btnGoingHome: UIButton!
//    @IBOutlet weak var btnOR: UIButton!
    @IBOutlet weak var btnDoingRegularRide: UIButton!
    
    @IBOutlet weak var stkGoingHome: UIStackView!
    
    @IBOutlet weak var imgVehiclePending: UIImageView!
    @IBOutlet weak var imgNoApproved: UIImageView!
    var arrForVehicleList:[VehicleDetail] = []
    var selectedVehicle:VehicleDetail? = nil
    
    var fullView: CGFloat =  90
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 100
    }
    
    var isShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullView = self.view.safeAreaTop + 40
        tblForVehicleDetail.delegate = self
        tblForVehicleDetail.dataSource = self
        tblForVehicleDetail.tableFooterView = UIView.init()
        self.tblForVehicleDetail.register(UINib.init(nibName: "VehicleCell", bundle: nil), forCellReuseIdentifier: "cell")
        initialViewSetup()
        self.view.backgroundColor = UIColor.white
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScrollableBottomSheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carView.setRound(withBorderColor: UIColor.themeLightDividerColor, andCornerRadious: 3.0, borderWidth: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customWillAppear()
        if ProviderSingleton.shared.provider.providerType == ProviderType.PARTNER {
            btnAddNewVehicle.isHidden = true
        }
        //prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.allowUserInteraction], animations: {
                self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                self.viewForYourVehicle.transform = CGAffineTransform.identity
                self.heightForHeader.constant = 100
                self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.viewForYourVehicle.transform = CGAffineTransform.identity
            self?.heightForHeader.constant = 100
            self?.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBtnAddNewVehicle(_ sender: Any) {
        if let mainViewController:VehicleDetailVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "vehicleDetailVC") as? VehicleDetailVC {
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
    
    @IBAction func onClickSelectVehicle(_ sender: Any) {
        let currentVehicle:VehicleDetail = arrForVehicleList[(sender as! UIButton).tag]
        if !(currentVehicle.adminTypeId.isEmpty() && ProviderSingleton.shared.provider.providerType != ProviderType.PARTNER) {
            if ((self.parent as! MapVC).providerDetailResponse.scheduleTripCount != 0 && ProviderSingleton.shared.provider.providerType == 0 && ProviderSingleton.shared.provider.serviceType != currentVehicle.serviceType) {
                let AlertDialogue = CustomAlertDialog.showCustomAlertDialog(title: "Change vehicle?", message: "All scheduled trips will be removed from this vehicle", titleLeftButton: "Cancel", titleRightButton: "Confirm")
                AlertDialogue.onClickRightButton = { [unowned AlertDialogue] in
                    self.wsSelectVehicle(id: currentVehicle.id, service_id: currentVehicle.serviceType)
                    AlertDialogue.removeFromSuperview();
                }
                AlertDialogue.onClickLeftButton = { [unowned AlertDialogue] in
                    AlertDialogue.removeFromSuperview();
                }
            }
            else
            {self.wsSelectVehicle(id: currentVehicle.id, service_id: currentVehicle.serviceType)}
        }
        else {
            Utility.showToast(message: "VALIDATION_MSG_YOU_CAN'T_SELECT_VEHICLE".localized)
        }
    }
    
    @IBAction func onClickBtnOffline(_ sender: Any) {
        self.wsGoOfline()
    }
    
    @IBAction func onGoHomeClicked(_ sender: Any) {
        self.setGoingHome(isGoingHome: true)
    }
    
    @IBAction func onDoRegularRideClicked(_ sender: Any) {
        self.setGoingHome(isGoingHome: false)
    }
    
    
    @IBAction func onClickBtnChange(_ sender: Any) {
        
    }
    
    func customWillAppear() {
        wsGetVehicleList()
        
        if ProviderSingleton.shared.provider.providerType == ProviderType.PARTNER || ProviderSingleton.shared.provider.providerType == ProviderType.ADMIN {
            btnAddNewVehicle.isHidden  = true
        }
        
        if ProviderSingleton.shared.currentVehicle.id.isEmpty {
            self.headerView.isHidden = true
            self.btnGoOffline.isHidden = true
            self.stkGoingHome.isHidden = true
        }else {
            self.headerView.isHidden = false
            self.setTypeData()
        }
        if preferenceHelper.getGoingHomeOn() {
            self.btnGoingHome.isHidden = ProviderSingleton.shared.provider.isGoHome == TRUE
            self.btnDoingRegularRide.isHidden = !self.btnGoingHome.isHidden
        } else {
            self.btnGoingHome.isHidden = true
            self.btnDoingRegularRide.isHidden = true
        }
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
    func initialViewSetup() {
        carView.backgroundColor = UIColor.themeLightDividerColor
        lblYourVehicle.text = "TXT_YOUR_VEHICLE".localized
        lblYourVehicle.font = FontHelper.font(size: FontSize.navigationTitle , type: FontType.Bold)
        lblYourVehicle.textColor = UIColor.themeTextColor
        
        btnGoOffline.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnGoOffline.setTitle("TXT_GO_OFFLINE".localizedCapitalized, for: .normal)
        btnGoOffline.setTitleColor(UIColor.themeErrorTextColor, for: .normal)
        
        self.btnGoingHome.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        self.btnGoingHome.setTitle("TXT_GOING_HOME".localizedCapitalized, for: .normal)
        self.btnGoingHome.setTitleColor(UIColor.green, for: .normal)
        
        self.btnDoingRegularRide.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        self.btnDoingRegularRide.setTitle("TXT_DOING_REGULAR".localizedCapitalized, for: .normal)
        self.btnDoingRegularRide.setTitleColor(UIColor.themeErrorTextColor, for: .normal)
        
        self.btnDoingRegularRide.isHidden = true
        self.btnGoingHome.isHidden = true
        
        let p = ProviderSingleton.shared.provider.isGoHome
        if p  == 1 {
            self.btnDoingRegularRide.isHidden = false
        }
        else {
            self.btnGoingHome.isHidden = false
        }

        btnAddNewVehicle.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        btnAddNewVehicle.setTitle("TXT_ADD_NEW_VEHICLE".localizedCapitalized, for: .normal)
        btnAddNewVehicle.setTitleColor(UIColor.white, for: .normal)
        btnAddNewVehicle.backgroundColor = UIColor.black
        btnAddNewVehicle.layer.cornerRadius = 16
        
        if ProviderSingleton.shared.provider.providerType == ProviderType.PARTNER {
            btnAddNewVehicle.isHidden  = true
        }
        
        lblBasePrice.text = "TXT_BASE_PRICE".localized
        lblBasePrice.textColor = UIColor.themeLightTextColor
        lblBasePrice.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblBasePriceValue.text = "--".localized
        lblBasePriceValue.textColor = UIColor.themeTextColor
        lblBasePriceValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblDistancePrice.text = "TXT_DISTANCE_PRICE".localized
        lblDistancePrice.textColor = UIColor.themeLightTextColor
        lblDistancePrice.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblDistancePriceValue.text = "--".localized
        lblDistancePriceValue.textColor = UIColor.themeTextColor
        lblDistancePriceValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblTimePrice.text = "TXT_TIME_PRICE".localized
        lblTimePrice.textColor = UIColor.themeLightTextColor
        lblTimePrice.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTimePriceValue.text = "--".localized
        lblTimePriceValue.textColor = UIColor.themeTextColor
        lblTimePriceValue.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblCarModel.text = "TXT_DEFAULT".localized
        lblCarModel.textColor = UIColor.themeTextColor
        lblCarModel.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblCarNumber.text = "TXT_DEFAULT".localized
        lblCarNumber.textColor = UIColor.themeLightTextColor
        lblCarNumber.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblServiceType.text = "TXT_DEFAULT".localized
        lblServiceType.textColor = UIColor.themeLightTextColor
        lblServiceType.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        imgVehiclePending.tintColor = .themeWalletDeductedColor
        imgVehiclePending.isHidden = true
    }
}

extension ScrollableBottomSheetViewController: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForVehicleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VehicleDetailCell
        let dict = arrForVehicleList[indexPath.row]
        cell.btnSelected.tag = indexPath.row
        cell.btnSelected.addTarget(self, action:#selector(self.onClickSelectVehicle(_:)), for: .touchUpInside)
        cell.setData(data: dict)
        if ProviderSingleton.shared.provider.providerType == ProviderType.ADMIN {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedVehicle =   arrForVehicleList[indexPath.row]
        if let mainViewController:VehicleDetailVC = AppStoryboard.Map.instance.instantiateViewController(withIdentifier: "vehicleDetailVC") as? VehicleDetailVC {
            mainViewController.selectedVehicle = self.selectedVehicle
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
}

class VehicleDetailCell: TblVwCell {
    
    @IBOutlet  var lblVehicleName: UILabel!
    @IBOutlet  var lblVehiclePlateNumber: UILabel!
    @IBOutlet  var imgVehicle: UIImageView!
    @IBOutlet  var btnSelected: UIButton!
    @IBOutlet  var imgError: UIImageView!
    @IBOutlet  var lblVehicleWarning: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblVehicleName.textColor = UIColor.themeTextColor
        lblVehicleWarning.textColor = UIColor.themeErrorTextColor
        
        lblVehiclePlateNumber.textColor = UIColor.themeLightTextColor
        
        lblVehicleName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblVehicleWarning.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblVehiclePlateNumber.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        imgError.isHidden = true
        lblVehicleWarning.isHidden = true
//        btnSelected.setTitle(FontAsset.icon_radio_box_normal, for: .normal)
//        btnSelected.setTitle(FontAsset.icon_radio_box_selected, for: .selected)
        btnSelected.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        btnSelected.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
//        btnSelected.setSimpleIconButton()
//        btnSelected.titleLabel?.font = FontHelper.assetFont(size: 25)
    }
    
    func setData(data: VehicleDetail) {
        lblVehicleName.text = data.name + " " + data.model
        lblVehiclePlateNumber.text = data.plateNo
        btnSelected.isSelected = data.isSelected 
        
        imgVehicle.downloadedFrom(link: data.typeImageUrl, placeHolder: "asset-service-type", isFromCache: true, isIndicator: true, mode: .scaleAspectFit, isAppendBaseUrl: true)
        if data.isDocumentsExpired {
            lblVehicleWarning.text = "TXT_VEHICLE_DOCUMENT_EXPIRE".localized
        }
        if !data.isDocumentsUploaded {
            lblVehicleWarning.text = "TXT_VEHICLE_DOCUMENT_NOT_UPLOADED".localized
        }
        lblVehicleWarning.isHidden = !(data.isDocumentsExpired || !data.isDocumentsUploaded)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension ScrollableBottomSheetViewController: UIGestureRecognizerDelegate {
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        print(velocity.y)
        if !isShow {
            Utility.showToast(message: "txt_you_can_not_open_while_you_asked_bid_trip".localized, sameContainer: true)
            return
        }
        
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }

        if recognizer.state == .changed {
            
            if (velocity.y > 0 && self.heightForHeader.constant != 100) || (velocity.y < 0 && self.heightForHeader.constant != 0) {
                self.viewForYourVehicle.transform = CGAffineTransform.init(scaleX: (y + translation.y)/self.view.frame.height, y: (y + translation.y)/self.view.frame.height)
                self.view.layoutIfNeeded()
            }
        }
        if recognizer.state == .ended {
            let duration =  1.3
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                
                    if  (velocity.y > 0 && self.heightForHeader.constant != 100) {
                        print("show Full")
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                        self.viewForYourVehicle.transform = CGAffineTransform.identity
                        self.heightForHeader.constant = 100
                    }else {
                        print("show Partial")
                        if (self.heightForHeader.constant != 0 && velocity.y < 0) {
                            self.viewForYourVehicle.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                            self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                            self.heightForHeader.constant = 0
                        }
                    }
                    self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tblForVehicleDetail.isScrollEnabled = true
                    self?.viewForYourVehicle.transform = CGAffineTransform.init(scaleX:0.0, y:0.0)
                    self?.heightForHeader.constant = 0
                    
                    if ProviderSingleton.shared.currentVehicle.id.isEmpty {
                        self?.headerView.isHidden = true
                        self?.btnGoOffline.isHidden = true
                        self?.stkGoingHome.isHidden = true
                    }else {
                        self?.headerView.isHidden = false
                        self?.setTypeData()
                        if ProviderSingleton.shared.provider.isActive == FALSE {
                            self?.btnGoOffline.isHidden = true
                            self?.stkGoingHome.isHidden = true
                        }else {
                            self?.stkGoingHome.isHidden = false
                        }
                    }
                }else {
                    self?.viewForYourVehicle.transform = CGAffineTransform.identity
                    self?.heightForHeader.constant = 100
                }
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    func closeBottomSheet() {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.allowUserInteraction], animations: {
                self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                self.viewForYourVehicle.transform = CGAffineTransform.identity
                self.heightForHeader.constant = 100
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()})
    }
    
    func openBottomSheet() {
        if !isShow {
            return
        }
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.allowUserInteraction], animations: {
                self.viewForYourVehicle.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                self.heightForHeader.constant = 0
                self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.tblForVehicleDetail.isScrollEnabled = true
            self?.viewForYourVehicle.transform = CGAffineTransform.init(scaleX:0.0, y:0.0)
            self?.heightForHeader.constant = 0
            if ProviderSingleton.shared.currentVehicle.id.isEmpty {
                self?.headerView.isHidden = true
                self?.btnGoOffline.isHidden = true
                self?.stkGoingHome.isHidden = true
            }else {
                self?.headerView.isHidden = false
                self?.setTypeData()
                if ProviderSingleton.shared.provider.isActive == FALSE {
                    self?.btnGoOffline.isHidden = true
                    self?.stkGoingHome.isHidden = true
                }else {
                    self?.btnGoOffline.isHidden = true
                    self?.stkGoingHome.isHidden = false
                }
            }
            self?.view.layoutIfNeeded()
        })
    }
}

//MARK: Web Service Calls
extension ScrollableBottomSheetViewController {
    func wsGetVehicleList() {
        let dictParam : [String : Any] =
            [PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.TOKEN: preferenceHelper.getSessionToken()]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.GET_VEHICLE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data,error) -> (Void) in
            self.arrForVehicleList.removeAll()
            if Parser.isSuccess(response: response,data: data) {
                let jsonDecoder = JSONDecoder()
                do {
                    let vehicleList = try jsonDecoder.decode(VehicleListResponse.self, from: data!)
                    for vehicle in vehicleList.vehicleList {
                        self.arrForVehicleList.append(vehicle)
                    }
                }catch {
                    print("data may be wrong")
                }
                self.setTypeData()
            }else {
            }
            self.tblForVehicleDetail.reloadData()
        }
    }
    
    func wsGetProviderDetail() {
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
            
            Utility.hideLoading()
            if Parser.parseProviderDetail(response: response, data: data) {
                let jsonDecoder = JSONDecoder()
                do {
                    (self.parent as! MapVC).providerDetailResponse = try jsonDecoder.decode(ProviderDetailResponse.self, from: data!)
                    if ProviderSingleton.shared.provider.isDocumentsExpired {
                        return;
                    }else if (self.parent as! MapVC).providerDetailResponse.provider.vehicleDetail.isEmpty {
                        if ((self.parent as! MapVC).providerDetailResponse.provider.providerType != ProviderType.PARTNER) {
                            return;
                        }else {
                            return;
                        }
                    }else {
                        for vehicle in (self.parent as! MapVC).providerDetailResponse.provider.vehicleDetail {
                            if vehicle.isSelected {
                                ProviderSingleton.shared.currentVehicle = vehicle
                                Utility.downloadImageFrom(link: (self.parent as! MapVC).providerDetailResponse.typeDetails.mapPinImageUrl, completion: { (image) in
                                    (self.parent as! MapVC).currentMarker.icon = image
                                })
                                break
                            }
                        }
                        if ProviderSingleton.shared.currentVehicle.id.isEmpty {
                        }else {
                            self.setTypeData()
                        }
                    }
                }catch {
                    print("data may be wrong")
                }
            }else {
            }
        }
    }
    func setTypeData() {
        if ProviderSingleton.shared.provider.providerType == ProviderType.PARTNER {
            btnAddNewVehicle.isHidden  = true
        }
        if ProviderSingleton.shared.currentVehicle.id.isEmpty {
            self.headerView.isHidden = true
            self.btnGoOffline.isHidden = true
            self.stkGoingHome.isHidden = true
        }else {
            if ProviderSingleton.shared.provider.isActive == FALSE {
                self.btnGoOffline.isHidden = true
                self.stkGoingHome.isHidden = true
            }else {
                self.btnGoOffline.isHidden = true
                self.stkGoingHome.isHidden = false
            }
            let currentVehicle:VehicleDetail = ProviderSingleton.shared.currentVehicle
            self.lblCarNumber.text = currentVehicle.plateNo
            var typedetail:TypeDetail = TypeDetail.init()
            
            if let mapVC:MapVC =  self.parent as? MapVC {
                typedetail  = mapVC.providerDetailResponse.typeDetails
            }
            
            if !typedetail.typeid.isEmpty() {
                self.lblServiceType.text = typedetail.typename
                
                if typedetail.basePriceDistance == 0.0 {
                    self.lblBasePriceValue.text = typedetail.basePrice.toCurrencyString()
                }else if typedetail.basePriceDistance == 1.0 {
                    self.lblBasePriceValue.text = typedetail.basePrice.toCurrencyString() + "/" +  Utility.getDistanceUnit(unit: typedetail.unit)
                }else {
                    self.lblBasePriceValue.text = typedetail.basePrice.toCurrencyString() +
                        "/" + typedetail.basePriceDistance.toString() + Utility.getDistanceUnit(unit: typedetail.unit)
                }



                self.lblDistancePriceValue.text = typedetail.distancePrice.toCurrencyString() + "/" +  Utility.getDistanceUnit(unit: typedetail.unit)
                
                self.lblTimePriceValue.text = typedetail.timePrice.toCurrencyString() +  "/" +  MeasureUnit.MINUTES
                self.imgCar.downloadedFrom(link: typedetail.typeImageUrl, placeHolder: "asset-service-type", isFromCache: true, isIndicator: true, mode: .scaleAspectFit, isAppendBaseUrl: true)
            }
            
            self.lblCarModel.text = currentVehicle.name + " - " + currentVehicle.model
            self.headerView.isHidden = false
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
                (self.parent as! MapVC).updateUiForOnlineOffline()
                self.closeBottomSheet()
            }else {
            }
        }
    }
    
    func setGoingHome(isGoingHome: Bool) {
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.IS_GOING_HOME] = isGoingHome
        
        Utility.showLoading()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.TOGGLE_GO_HOME, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data) {
                ProviderSingleton.shared.provider.isGoHome = isGoingHome ? TRUE : FALSE
                self.btnGoingHome.isHidden = isGoingHome
                self.btnDoingRegularRide.isHidden = !self.btnGoingHome.isHidden
                self.closeBottomSheet()
            }
        }
    }
    
    func wsSelectVehicle(id:String = "", service_id:String = "") {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.VEHICLE_ID: id,
             PARAMS.SERVICE_TYPE: service_id]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.SELECT_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, data, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data) {
                self.wsGetVehicleList()
                self.wsGetProviderDetail()
            }else {
                
            }
            self.tblForVehicleDetail.reloadData()
        }
    }
}
