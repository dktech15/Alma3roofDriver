//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomDatePickerDialog:CustomDialog {
    
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK:Variables
    var onClickRightButton : ((_ selectedDate:Date) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  datePickerDialog = "dialogForDatePicker"
    
    public static func showCustomDatePickerDialog(title:String, titleLeftButton:String, titleRightButton:String, mode:UIDatePicker.Mode = .date) -> CustomDatePickerDialog {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDatePickerDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        view.datePicker.datePickerMode = mode
        view.datePicker.setValue(false, forKey: "highlightsToday")
        view.datePicker.locale = Locale(identifier: preferenceHelper.getLanguageCode())
        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    
    func setLocalization(){
        lblTitle.textColor = UIColor.themeTitleColor
        datePicker.setValue(UIColor.black, forKey: "textColor")
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular    )
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setupButton()
        btnLeft.titleLabel?.font =   FontHelper.font(size: FontSize.regular, type: FontType.Regular    )
        btnRight.titleLabel?.font =   FontHelper.font(size: FontSize.regular, type: FontType.Bold    )
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    
    func setMinDate(mindate:Date) {
        datePicker.minimumDate = mindate
        datePicker.date = mindate
    }
    
    func setMaxDate(maxdate:Date) {
        datePicker.maximumDate = maxdate
    }
    
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(datePicker.date)
        }
    }
    
    func setDatePickerForFutureTrip() {
        self.datePicker.datePickerMode = .dateAndTime
        let gregorian = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeZone = TimeZone.init(identifier: ProviderSingleton.shared.timeZone)!
        
        var dateComponents = DateComponents.init()
        dateComponents.day = 3
        let currentDate = Date()
        let maxDate = gregorian.date(byAdding: dateComponents, to: currentDate)
        let minimumDate:Date = Date.init(timeIntervalSinceNow: TimeInterval(60*preferenceHelper.getPreSchedualTripTime()))
        datePicker.minimumDate = minimumDate
        
        datePicker.maximumDate = maxDate!
        datePicker.calendar = gregorian
        datePicker.timeZone = TimeZone.init(identifier: ProviderSingleton.shared.timeZone)!
    }
    
    func timeInterval(date:Date) -> Double {
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strLocalDate = dateFormatter.string(from: Date())
        
        let startDate = strLocalDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
        return (date.timeIntervalSince(startDate) * 1000)
    }
    
    func getFutureTripBookingDate() -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strLocalDate = dateFormatter.string(from: datePicker.date)
        let startDate = dateFormatter.date(from: strLocalDate) ?? Date()
        return startDate.toString(withFormat: "EEE, dd MMM") + "AT" + startDate.toString(withFormat: "hh:mm a")
    }
}
