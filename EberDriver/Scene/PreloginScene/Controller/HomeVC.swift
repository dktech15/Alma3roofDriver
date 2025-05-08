//
//  ViewController.swift
//  EberDriver
//
//  Created by Elluminati  on 22.12.18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnChangeLanguage: UIButton!
    @IBOutlet weak var lblAllCopyRightReserved: UILabel!
    @IBOutlet weak var lblAppVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProviderSingleton.shared.clear()
        initialViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initialViewSetup() {
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
        self.lblAppVersion.text = "TXT_APP_VERSION".localized + " " + currentAppVersion
        self.lblAppVersion.textColor = UIColor.themeButtonTitleColor
        self.lblAppVersion.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        
        self.lblAllCopyRightReserved.text = "TXT_ALL_COPY_RIGHT_RESERVED".localized
        self.lblAllCopyRightReserved.textColor = UIColor.themeButtonTitleColor
        self.lblAllCopyRightReserved.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        self.btnChangeLanguage.setTitle("TXT_CHANGE_LANGUAGE".localizedUppercase, for: .normal)
        self.btnChangeLanguage.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        self.btnChangeLanguage.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        
        self.btnLogin.setTitle("TXT_LOGIN".localizedUppercase, for: .normal)
        self.btnLogin.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        self.btnLogin.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        
        self.btnRegister.setTitle("TXT_REGISTER".localizedUppercase, for: .normal)
        self.btnRegister.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        self.btnRegister.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
    }
    
    @IBAction func onClickBtnChangeLanguage(_ sender: Any) {
        self.openLanguageDialog()
    }
    
    @IBAction func onClickBtnLogin(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.HOME_TO_LOGIN, sender: self)
    }
    
    @IBAction func onClickBtnRegister(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.HOME_TO_REGISTER, sender: self)
    }
    
    func openLanguageDialog() {
        let dialogForLanguage:CustomLanguageDialog = CustomLanguageDialog.showCustomLanguageDialog()
        
        dialogForLanguage.onItemSelected =
            { [unowned self, unowned dialogForLanguage]
                (selectedItem:Int) in
                self.changed(selectedItem)
                dialogForLanguage.removeFromSuperview()
        }
    }
}
