//
//  DialogForApplicationModw.swift
//  Edelivery Provider
//
//  Created by MacPro3 on 14/02/22.
//  Copyright © 2022 Elluminati iMac. All rights reserved.
//

import UIKit
import SwiftUI

public class DialogForApplicationMode:CustomDialog {
    
    @IBOutlet weak var viewCard: UIView!
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnDeveloper: UIButton!
    @IBOutlet weak var btnStaging: UIButton!
    
    @IBOutlet weak var lblServer: UILabel!
    
    @IBOutlet weak var viewTextLocation: UIView!
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var txtLat: UITextField!
    @IBOutlet weak var txtLong: UITextField!

    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    
    var appMode: AppMode = .live
    
    static let  verificationDialog = "DialogForApplicationMode"

    public override func awakeFromNib() {
        super.awakeFromNib()
        btnCancel.setTitleColor(UIColor.themeTitleColor, for: .normal)
        btnCancel.titleLabel?.textColor = UIColor.themeTitleColor
        
        self.btnLive.setImage(UIImage.init(named: "asset-radio-normal")!.imageWithColor(color: .themeTextColor), for: .normal)
        self.btnLive.setImage(UIImage.init(named: "asset-radio-selected")!.imageWithColor(color: .themeTextColor), for: .selected)
        
        self.btnDeveloper.setImage(UIImage.init(named: "asset-radio-normal")!.imageWithColor(color: .themeTextColor), for: .normal)
        self.btnDeveloper.setImage(UIImage.init(named: "asset-radio-selected")!.imageWithColor(color: .themeTextColor), for: .selected)
        
        self.btnStaging.setImage(UIImage.init(named: "asset-radio-normal")!.imageWithColor(color: .themeTextColor), for: .normal)
        self.btnStaging.setImage(UIImage.init(named: "asset-radio-selected")!.imageWithColor(color: .themeTextColor), for: .selected)
        
        switchLocation.isOn = false
        if preferenceHelper.getIsFakeGpsOn() {
            switchLocation.isOn = true
            let arrLocation = preferenceHelper.getCustomLocation()
            if arrLocation.count > 1 {
                txtLat.text = "\(arrLocation[0])"
                txtLong.text = "\(arrLocation[1])"
            }
        }
        viewTextLocation.isHidden = !switchLocation.isOn
        
        switch AppMode.currentMode {
        case .live:
            self.onClickRadio(btnLive)
        case .developer:
            self.onClickRadio(btnDeveloper)
        case .staging:
            self.onClickRadio(btnStaging)
        }
    }

    public static func showCustomAppModeDialog() -> DialogForApplicationMode {
        if let tagView = APPDELEGATE.window?.viewWithTag(15975) as? DialogForApplicationMode {
            APPDELEGATE.window?.addSubview(tagView)
            APPDELEGATE.window?.bringSubviewToFront(tagView)
            return tagView
        } else {
            let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForApplicationMode
            view.tag = 15975
            view.viewCard.applyShadowToView(12)
            view.btnOk.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
            view.btnOk.backgroundColor = UIColor.themeTextColor
            view.btnOk.layer.cornerRadius = view.btnOk.frame.size.height/2
            view.btnOk.clipsToBounds = true
            let frame = (APPDELEGATE.window?.frame)!
            view.frame = frame
            
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            
            return view
        }
    }
    
    @IBAction func onClickRadio(_ sender: UIButton) {
        
        btnLive.isSelected = false
        btnDeveloper.isSelected = false
        btnStaging.isSelected = false
        
        sender.isSelected = true
        
        if sender == btnLive {
            appMode = .live
        } else if sender == btnDeveloper {
            appMode = .developer
        } else {
            appMode = .staging
        }
    }
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        self.onClickLeftButton!();
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        if switchLocation.isOn && txtLat.text!.count == 0 {
            Utility.showToast(message: "Please Enter Latitude")
        } else if switchLocation.isOn && txtLong.text!.count == 0 {
            Utility.showToast(message: "Please Enter Longitude")
        } else {
            if AppMode.currentMode != appMode {
                if preferenceHelper.getUserId() == "" {
                    preferenceHelper.setSessionToken("");
                    preferenceHelper.setUserId("");
                    ProviderSingleton.shared.clear()
                    preferenceHelper.removeImageBaseUrl()
                    UIViewController.clearPBRevealVC()
                    AppMode.currentMode = self.appMode
                    APPDELEGATE.goToSplash()
                } else {
                    wsLogout()
                    preferenceHelper.setBiomatricVerification(false)
                }
            }
            if switchLocation.isOn {
                preferenceHelper.setCustomLocation([Double(txtLat.text!)!,Double(txtLong.text!)!])
                NotificationCenter.default.post(name: .didChangeCustomLocation, object: nil)
                preferenceHelper.setIsFakeGpsOn(true)
            } else {
                preferenceHelper.setCustomLocation([])
                preferenceHelper.setIsFakeGpsOn(false)
            }
            self.onClickRightButton!();
        }
        
    }
    
    @IBAction func switchLocationChange(_ sender: UISwitch) {
        viewTextLocation.isHidden = !sender.isOn
    }
    
    func wsLogout() {
        Utility.showLoading()
        
        var  dictParam : [String : Any] = [:]
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.PROVIDER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            }else {
                if Parser.parseLogout(response: response, data: data) {
                    UIViewController.clearPBRevealVC()
                    AppMode.currentMode = self.appMode
                    APPDELEGATE.goToSplash()
                }else {
                    Utility.hideLoading()
                }
            }
        }
    }
}
