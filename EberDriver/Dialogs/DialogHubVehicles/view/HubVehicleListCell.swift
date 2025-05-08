//
//  BidTrips.swift
//  EberDriver
//
//  Created by Mayur on 08/06/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class HubVehicleListCell: UITableViewCell {
    
    @IBOutlet  var lblVehicleName: UILabel!
    @IBOutlet  var lblVehiclePlateNumber: UILabel!
    @IBOutlet  var imgVehicle: UIImageView!
    @IBOutlet  var btnPick: UIButton!
    @IBOutlet  var imgError: UIImageView!
    @IBOutlet  var lblVehicleWarning: UILabel!
    
    var onClickButton : ((HubVehicleListCell) ->())?
    
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
        
        btnPick.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnPick.setTitle("txt_pick_up".localized, for: .normal)
        btnPick.setTitleColor(.themeButtonTitleColor, for: .normal)
        btnPick.backgroundColor = .themeButtonBackgroundColor
        btnPick.setRound()
    }
    
    func setData(data: VehicleDetail) {
        lblVehicleName.text = data.name + " " + data.model
        lblVehiclePlateNumber.text = data.plateNo
        
        imgVehicle.downloadedFrom(link: data.typeImageUrl, placeHolder: "asset-service-type", isFromCache: true, isIndicator: true, mode: .scaleAspectFit, isAppendBaseUrl: true)
        if data.isDocumentsExpired {
            lblVehicleWarning.text = "TXT_VEHICLE_DOCUMENT_EXPIRE".localized
        }
        if !data.isDocumentsUploaded {
            lblVehicleWarning.text = "TXT_VEHICLE_DOCUMENT_NOT_UPLOADED".localized
        }
        lblVehicleWarning.isHidden = !(data.isDocumentsExpired || !data.isDocumentsUploaded)
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        if onClickButton != nil {
            onClickButton!(self)
        }
    }
}
