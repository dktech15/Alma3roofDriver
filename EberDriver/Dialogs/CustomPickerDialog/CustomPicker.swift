//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomPicker:CustomDialog,UIPickerViewDelegate,UIPickerViewDataSource
{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnDecrement: UIButton!
    @IBOutlet weak var btnIncrement: UIButton!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    var arrForPicker = [(Date,Date)]()
    //MARK:Variables
    var onClickRightButton : ((_ date:(Date,Date)) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForCustomPicker"
    let cal:Calendar = Calendar.current
    
    let date = Date()
    let formatter = DateFormatter()
 
    
    
  
    var selecetedyear:Int = 0
    
    public override func awakeFromNib() {
        formatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
        formatter.dateFormat = "yyyy"
        lblYear.text = formatter.string(from: date)
        formatter.locale = Locale.init(identifier: "en_GB")
        selecetedyear = Int(formatter.string(from: date))!
    }
    
    
    
   
    var selectedDate:(Date,Date) = (Date(),Date());
    
    
    public static func  showCustomPicker
        (title:String,
         titleLeftButton:String,
         titleRightButton:String
         ) ->
        CustomPicker
     {
        
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPicker
        view.alertView.setShadow()
       
        let date = Date()
        let calendar = Calendar.current
       let year = calendar.component(.year, from: date)
        
        view.arrForPicker = Utility.getListFromYear(year: year)
        if !view.arrForPicker.isEmpty
        {
        view.selectedDate = view.arrForPicker[0]
        }
        
        
        
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        
        view.picker.delegate = view
        view.picker.dataSource = view
        view.setLocalization()
        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    func setLocalization(){
        lblTitle.textColor = UIColor.themeTextColor
        btnLeft.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnRight.setTitleColor(UIColor.themeTextColor, for: .normal)
      
        
        lblTitle.font = FontHelper.font(size: FontSize.medium   , type: FontType.Bold)
        btnLeft.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        btnRight.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        self.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = UIColor.white
        alertView.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
    }
    //ActionMethods
    
    @IBAction func onClickBtnLeft(_ sender: Any){
        if self.onClickLeftButton != nil
        {
            self.onClickLeftButton!();
        }
        
    }
    @IBAction func onClickBtnRight(_ sender: Any){
        if self.onClickRightButton != nil
        {
            self.onClickRightButton!(selectedDate)
        }
        
    }
    // DataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrForPicker.count
    }
    
    // Delegate
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let data:String = Utility.dateToString(date: arrForPicker[row].0, withFormat: DateFormat.DD_MMM_YY)  + "   -   " + Utility.dateToString(date: arrForPicker[row].1, withFormat: DateFormat.DD_MMM_YY)
        
        
      return data
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDate = arrForPicker[row]
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        
        label.textColor = UIColor.themeTextColor
        label.textAlignment = .center
        label.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        label.adjustsFontSizeToFitWidth = true
        label.frame = CGRect.init(x: 0, y: 0, width: pickerView.frame.width, height: 30)
        label.minimumScaleFactor = 0.5
        label.text = Utility.dateToString(date: arrForPicker[row].0, withFormat: DateFormat.DD_MMM_YY)  + "   -   " +  Utility.dateToString(date: arrForPicker[row].1, withFormat: DateFormat.DD_MMM_YY)
        
        return label
    }
    @IBAction func onClickBtnIncrement(_ sender: Any){
        selecetedyear += 1
        if selecetedyear >  Int(formatter.string(from: date))!
        {
            selecetedyear -= 1
        }
        else
        {
            arrForPicker = Utility.getListFromYear(year: selecetedyear)
            lblYear.text = String(selecetedyear)
            if arrForPicker.count > 0
            {
                selectedDate = arrForPicker[0]
            }
            picker.reloadAllComponents()
            
        }
    }

    @IBAction func onClickBtnDecrement(_ sender: Any){
        selecetedyear -= 1
        if selecetedyear <  (Int(formatter.string(from: date))! - 3)
        {
            selecetedyear += 1
        }
        else
        {
            arrForPicker = Utility.getListFromYear(year: selecetedyear)
            if arrForPicker.count > 0
            {
                selectedDate = arrForPicker[0]
            }
            
            lblYear.text = String(selecetedyear)
            picker.reloadAllComponents()
        }
        
    }
}


