//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

class DialogHubVehicles:CustomDialog,UITextFieldDelegate {

    //MARK: - OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var tblVehicleList: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!

    //MARK: - Variables
    var onClickRightButton : ((_ dialog:DialogHubVehicles ) -> Void)? = nil
    var onPickUp : ((_ dialog:DialogHubVehicles ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var arrVehicle = [VehicleDetail]()
    
    static let  verificationDialog = "DialogHubVehicles"

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTable.constant = tblVehicleList.contentSize.height
    }

    static func showDialog(vehicleResponse: HubVehicleListResponse, tag: Int = DialogTags.tripBidingDialog) -> DialogHubVehicles {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogHubVehicles
        view.alertView.setShadow()
        view.arrVehicle = vehicleResponse.vehicle_list ?? []
        
        view.reloadList(arr: view.arrVehicle)
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.tag = tag
        
        view.lblTitle.text = vehicleResponse.hub?.name ?? "-"
        
        view.setLocalization()
        view.setTableView()
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }

    func setLocalization() {
        /* Set Color */
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
  
        btnRight.setupButton()
        
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        lblMessage.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        btnLeft.setTitle("TXT_CLOSE".localized, for: UIControl.State.normal)
        btnRight.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        
        lblMessage.text = "".localized
        
        lblNoData.text = "ERROR_CODE_415".localized
        lblNoData.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblNoData.textColor = .themeTextColor
    }
    
    public func setTableView() {
        tblVehicleList.delegate = self
        tblVehicleList.dataSource = self
        tblVehicleList.separatorColor = .clear
        tblVehicleList.register(UINib(nibName: "HubVehicleListCell", bundle: nil), forCellReuseIdentifier: "HubVehicleListCell")
        tblVehicleList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func reloadList(arr: [VehicleDetail]) {
        self.arrVehicle.removeAll()
        for obj in arr {
            self.arrVehicle.append(obj)
        }
        tblVehicleList.reloadData()
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(self)
        }
    }
}

extension DialogHubVehicles: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVehicle.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HubVehicleListCell", for: indexPath) as! HubVehicleListCell
        let obj = arrVehicle[indexPath.row]
        cell.setData(data: obj)
        cell.onClickButton = { [weak self] tblCell in
            guard let self = self else { return }
            if let index = self.tblVehicleList.indexPath(for: cell) {
                print(index.row)
                self.wsPickVehicle(index: index.row)
            }
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DialogHubVehicles {
    
    func wsPickVehicle(index: Int) {
        
        Utility.showLoading()
        
        let obj = arrVehicle[index]
        
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.VEHICLE_ID] = obj.id

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.PROVIDER_PICK_HUB_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response,data, error) -> (Void) in
            Utility.hideLoading()
            guard let self = self else { return }
            if Parser.isSuccess(response: response,data: data,withSuccessToast: true) {
                if self.onPickUp != nil {
                    self.onPickUp!(self)
                }
            }
        }
    }
}
