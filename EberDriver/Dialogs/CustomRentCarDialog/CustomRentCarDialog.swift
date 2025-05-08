//
//  CustomRentCarDialog.swift
//  Eber Driver
//
//  Created by Elluminati on 22/02/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomRentCarDialog:CustomDialog
{
    //MARK: - OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!

    @IBOutlet weak var lblPackageName: UILabel!

    @IBOutlet weak var lblBasePrice: UILabel!
    @IBOutlet weak var lblBaseTimeAndDistance: UILabel!

    @IBOutlet weak var lblExtraDistanceAndTimePrice: UILabel!

    //MARK: - Variables
    var onClickRightButton : (() -> Void)? = nil
    static let verificationDialog = "dialogForRentCar"

    @IBOutlet weak var heightForTable: NSLayoutConstraint!

    public static func showCustomRentCarDialog(title:String, message:String, titleRightButton:String, tag:Int = 403) -> CustomRentCarDialog {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomRentCarDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = "TXT_PACKAGES".localized;
        view.setLocalization()
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)

        if let view = (APPDELEGATE.window?.viewWithTag(403)) {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        } else {
            UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        view.btnRight.isHidden =  titleRightButton.isEmpty()
        return view;
    }

    func setLocalization() {
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setupButton()

        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)

        /* Set Font */
        lblPackageName.textColor = UIColor.themeTextColor
        lblPackageName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)

        lblBasePrice.textColor = UIColor.themeLightTextColor
        lblBasePrice.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        lblBaseTimeAndDistance.textColor = UIColor.themeLightTextColor
        lblBaseTimeAndDistance.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        lblExtraDistanceAndTimePrice.textColor = UIColor.themeLightTextColor
        lblExtraDistanceAndTimePrice.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        self.setRentalData()
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!()
        }
    }

    func setRentalData() {
        let data = ProviderSingleton.shared.tripStaus.tripService
        lblPackageName.text = data.typename
        lblBasePrice.text = data.basePrice.toCurrencyString()
        lblBaseTimeAndDistance.text = data.basePriceTime.toString() + MeasureUnit.MINUTES + " & " + data.basePriceDistance.toString() + Utility.getDistanceUnit(unit: ProviderSingleton.shared.tripStaus.trip.unit)
        lblExtraDistanceAndTimePrice.text = "TXT_EXTRA_DISTANCE_CHARGE".localized + " " + data.pricePerUnitDistance.toCurrencyString() + "/" + Utility.getDistanceUnit(unit: ProviderSingleton.shared.tripStaus.trip.unit) + "\n" + "TXT_EXTRA_TIME_CHARGE".localized + " " + data.priceForTotalTime.toCurrencyString() + "/" + MeasureUnit.MINUTES
    }
}
