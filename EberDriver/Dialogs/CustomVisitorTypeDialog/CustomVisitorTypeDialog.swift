//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomVisitorTypeDialog:CustomDialog
{
   //MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTypeName: UILabel!
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblBaseFareValue: UILabel!
    
    @IBOutlet weak var lblTimeFare: UILabel!
    @IBOutlet weak var lblTimeFareValue: UILabel!
    
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblDistanceFareValue: UILabel!
    
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    
    @IBOutlet weak var alertView: UIView!
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "CustomVisitorTypeDialog"
    
    public static func  showCustomVisitorTypeDialog
        (title:String,
         message:String,
         typeName:String,
         baseFareCost:String,
         minFareCost:String,
         distanceFareCost:String,
         titleLeftButton:String,
         titleRightButton:String, 
         tag:Int = 401
         ) ->
        CustomVisitorTypeDialog
     {
       
        
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomVisitorTypeDialog
        view.tag = tag
        view.alertView.setShadow()
        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        
        view.lblMessage.text = message;
        view.setLocalization()
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        
        view.lblBaseFareValue.text = baseFareCost
        view.lblTimeFareValue.text = minFareCost
        view.lblDistanceFareValue.text = distanceFareCost
        view.lblTypeName.text = typeName
        
        if let view = (APPDELEGATE.window?.viewWithTag(tag))
        {
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        else
        {
        UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        }
        view.btnLeft.isHidden =  titleLeftButton.isEmpty()
        view.btnRight.isHidden =  titleRightButton.isEmpty()
        view.lblTitle.isHidden = title.isEmpty()
        view.lblMessage.isHidden = message.isEmpty()
        
        return view;
    }
    
    func setLocalization(){
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
         btnRight.setupButton()
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        lblMessage.font = FontHelper.font(type: FontType.Regular)
        
        
       
        
        lblBaseFare.text = "TXT_BASE_PRICE".localized
        lblBaseFare.textColor = UIColor.themeLightTextColor
        lblBaseFare.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        
        
        
        lblTypeName.textColor = UIColor.themeTextColor
        lblTypeName.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        
        
        lblBaseFareValue.text = "TXT_DEFAULT".localized
        lblBaseFareValue.textColor = UIColor.themeTextColor
        lblBaseFareValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblTimeFare.text = "TXT_TIME_PRICE".localized
        lblTimeFare.textColor = UIColor.themeLightTextColor
        lblTimeFare.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        
        
        lblTimeFareValue.text = "TXT_DEFAULT".localized
        lblTimeFareValue.textColor = UIColor.themeTextColor
        lblTimeFareValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        lblDistanceFare.text = "TXT_DISTANCE_PRICE".localized
        lblDistanceFare.textColor = UIColor.themeLightTextColor
        lblDistanceFare.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        
        
        lblDistanceFareValue.text = "TXT_DEFAULT".localized
        lblDistanceFareValue.textColor = UIColor.themeTextColor
        lblDistanceFareValue.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
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
            self.onClickRightButton!()
        }
        
    }
    
}


