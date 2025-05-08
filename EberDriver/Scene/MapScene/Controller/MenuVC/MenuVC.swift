//
//  ViewController.swift
//  newt
//
//  Created by Elluminati  on 10/07/18.
//  Copyright © 2018 Elluminati. All rights reserved.
//

import UIKit

class MenuVC: BaseVC {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var topProfileView: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var viewForFooter: UIView!
    @IBOutlet weak var collectionForMenu: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var heightNavigation: NSLayoutConstraint!
    @IBOutlet weak var heightLogout: NSLayoutConstraint!
    @IBOutlet var imgNotification: UIImageView!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnRating: UIButton!
    var arrForMenu:[String] = []
//    var imagesArray = [#imageLiteral(resourceName: "asset-menu-profile") , #imageLiteral(resourceName: "asset-menu-payments") , #imageLiteral(resourceName: "asset-menu-booking") , #imageLiteral(resourceName: "asset-menu-history"), #imageLiteral(resourceName: "asset-menu-document"), #imageLiteral(resourceName: "asset-menu-referral"), #imageLiteral(resourceName: "asset-menu-setting"), #imageLiteral(resourceName: "asset-menu-heart"), #imageLiteral(resourceName: "asset-menu-contact-us",#imageLiteral(resourceName: "asset-redeem"))]
    var imagesArray = [UIImage]()
    var imagesArray0 = [#imageLiteral(resourceName: "asset-menu-profile") ,#imageLiteral(resourceName: "asset-menu-booking") , #imageLiteral(resourceName: "asset-menu-history") , #imageLiteral(resourceName: "asset-menu-document") , #imageLiteral(resourceName: "asset-menu-setting"), #imageLiteral(resourceName: "asset-menu-earning"), #imageLiteral(resourceName: "asset-menu-referral"), #imageLiteral(resourceName: "asset-redeem"),#imageLiteral(resourceName: "asset-menu-payments"), #imageLiteral(resourceName: "asset-rate-normal"), #imageLiteral(resourceName: "asset-menu-bank-detail") ,  ]
    var imagesArray1 = [#imageLiteral(resourceName: "asset-menu-profile") ,#imageLiteral(resourceName: "asset-menu-booking") , #imageLiteral(resourceName: "asset-menu-history") , #imageLiteral(resourceName: "asset-menu-document") , #imageLiteral(resourceName: "asset-menu-setting"), #imageLiteral(resourceName: "asset-menu-earning"), #imageLiteral(resourceName: "asset-menu-payments"),#imageLiteral(resourceName: "asset-redeem"), #imageLiteral(resourceName: "asset-menu-contact-us")]
    var isBack = false
    let provider = ProviderSingleton.shared.provider
    let cellHeight: CGFloat = 85
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgNotification.tintColor = UIColor.themeImageColor
        initialViewSetup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUserInfoTap))
        topProfileView.isUserInteractionEnabled = true
        topProfileView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wsGetProviderDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        viewForFooter.navigationShadow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialViewSetup() {
        lblTitle.text = "TXT_MENU".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        btnLogout.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnLogout.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnLogout.setTitle("TXT_LOGOUT".localized, for: .normal)
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
        topProfileView.layer.cornerRadius = 16
        
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.width/2
        imgProfilePic.layer.borderWidth = 3
        imgProfilePic.layer.borderColor = UIColor.white.cgColor
        if !provider.picture.isEmpty {
            imgProfilePic.downloadedFrom(link: provider.picture)
        }
        self.lblName.text = "\(provider.firstName) \(provider.lastName)"
        self.lblEmail.text = provider.email
    }
    
    @objc func handleUserInfoTap() {
        // Handle the tap action here
        print("User Info View Tapped")
        // For example, navigate or show a modal
        self.revealViewController()?.revealLeftView()
        if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
            navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PROFILE, sender: self)
        }
    }

    @IBAction func onClickBtnLogout(_ sender: Any) {
        self.revealViewController()?.revealLeftView()
        openLogoutDialog()
    }
    
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.isBack = true
        self.revealViewController()?.revealLeftView()
    }
    @IBAction func actionNotification(_ sender: Any) {
        self.revealViewController()?.revealLeftView()
        let massNotificationVC = MassNotificationVC(nibName: "MassNotificationVC", bundle: nil)
        massNotificationVC.modalPresentationStyle = .fullScreen
        self.present(massNotificationVC, animated: true, completion: nil)
    }
    @IBAction func onClickBtnSetting(_ sender: Any) {
        self.revealViewController()?.revealLeftView()
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
            navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_SETTING, sender: self)
        }
    }
    
    func openLogoutDialog() {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_LOGOUT".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized)
        dialogForLogout.onClickLeftButton = { [/*unowned self,*/ unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = { [unowned self, unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
            self.wsLogout()
            preferenceHelper.setBiomatricVerification(false)
        }
    }

    func openScheduleTrip(){
        let massNotificationVC = MyBookingVC(nibName: "MyBookingVC", bundle: nil)
        massNotificationVC.modalPresentationStyle = .fullScreen
        self.present(massNotificationVC, animated: true, completion: nil)
    }
}

//MARK: CollectionView Delegate Methods
extension MenuVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        collectionForMenu.dataSource = self
        collectionForMenu.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.revealViewController()?.revealLeftView()
        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
            let obj = arrForMenu[indexPath.row]
            switch obj {
            case "TXT_MY_BOOKINGS".localized:
                self.openScheduleTrip()
            case "TXT_PROFILE".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PROFILE, sender: self)
            case "TXT_HISTORY".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_HISTORY, sender: self)
            case "TXT_DOCUMENTS".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_DOCUMENTS, sender: self)
            case "TXT_SETTINGS".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_SETTING, sender: self)
            case "TXT_EARNING".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_EARNING, sender: self)
            case "TXT_REFERRAL".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_SHARE_REFERRAL, sender: self)
            case "TXT_PAYMENTS".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PAYMENT, sender: self)
            case "TXT_REDEEM".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_REDEEM, sender: self)
            case "TXT_CONTACT_US".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
            case "TXT_BANK_DETAIL".localized:
                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_BANK_DETAIL, sender: self)
            case "txt_hub".localized:
                let vc = UIStoryboard(name: "Hub", bundle: nil).instantiateViewController(withIdentifier: "HubListVC")
                navigationVC.pushViewController(vc, animated: true)
            default:
                print("under development")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.setData(name: arrForMenu[indexPath.row].0, imageUrl:  arrForMenu[indexPath.row].1)
        cell.setData(name: self.arrForMenu[indexPath.row], icon: self.arrForMenu[indexPath.row], icons: imagesArray[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width-60)/3, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//extension MenuVC : UITableViewDataSource,UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrForMenu.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
//            cell.setData(name: arrForMenu[indexPath.row], icon: arrForMenu[indexPath.row], icons: imagesArray[indexPath.row])
//            cell.selectionStyle = .none
//            return cell
//        }
//        return UITableViewCell.init()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 48
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.revealViewController()?.revealLeftView()
//        if  let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
//            let obj = arrForMenu[indexPath.row]
//            switch obj {
//            case "TXT_MY_BOOKINGS".localized:
//                self.openScheduleTrip()
//            case "TXT_PROFILE".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PROFILE, sender: self)
//            case "TXT_HISTORY".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_HISTORY, sender: self)
//            case "TXT_DOCUMENTS".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_DOCUMENTS, sender: self)
//            case "TXT_SETTINGS".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_SETTING, sender: self)
//            case "TXT_EARNING".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_EARNING, sender: self)
//            case "TXT_REFERRAL".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_SHARE_REFERRAL, sender: self)
//            case "TXT_PAYMENTS".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_PAYMENT, sender: self)
//            case "TXT_REDEEM".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_REDEEM, sender: self)
//            case "TXT_CONTACT_US".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
//            case "TXT_BANK_DETAIL".localized:
//                navigationVC.performSegue(withIdentifier: SEGUE.HOME_TO_BANK_DETAIL, sender: self)
//            case "txt_hub".localized:
//                let vc = UIStoryboard(name: "Hub", bundle: nil).instantiateViewController(withIdentifier: "HubListVC")
//                navigationVC.pushViewController(vc, animated: true)
//            default:
//                print("under development")
//            }
//        }
//    }
//}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return MenuOptions.sectionedMenu.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.sectionedMenu[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MenuOptions.sectionedMenu[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = MenuOptions.sectionedMenu[indexPath.section]
        let title = section.items[indexPath.row]
        let icon = section.icons[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
            cell.setData(name: title, icon: title, icons: icon)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.revealViewController()?.revealLeftView()
        let item = MenuOptions.sectionedMenu[indexPath.section].items[indexPath.row]

        if let navVC = self.revealViewController()?.mainViewController as? UINavigationController {
            switch item {
                case "TXT_MY_BOOKINGS".localized: self.openScheduleTrip()
                case "TXT_PROFILE".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_PROFILE, sender: self)
                case "TXT_HISTORY".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_HISTORY, sender: self)
                case "TXT_DOCUMENTS".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_DOCUMENTS, sender: self)
                case "TXT_SETTINGS".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_SETTING, sender: self)
                case "TXT_EARNING".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_EARNING, sender: self)
                case "TXT_REFERRAL".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_SHARE_REFERRAL, sender: self)
                case "TXT_PAYMENTS".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_PAYMENT, sender: self)
                case "TXT_REDEEM".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_REDEEM, sender: self)
                case "TXT_CONTACT_US".localized: navVC.performSegue(withIdentifier: SEGUE.HOME_TO_CONTACT_US, sender: self)
                default: break
            }
        }
    }
}


extension MenuVC {
    func wsLogout() {
        self.view.endEditing(true)
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
                    APPDELEGATE.gotoLogin()
                }else {
                    Utility.hideLoading()
                }
            }
        }
    }
    
    func wsGetProviderDetail() {
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.DEVICE_TYPE : CONSTANT.IOS,
              PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
              PARAMS.APP_VERSION: currentAppVersion,
              PARAMS.TYPE: CONSTANT.TYPE_PROVIDER]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_PROVIDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, data, error) -> (Void) in
            guard let self = self else { return }
            if (self.view?.subviews.count ?? 0)  > 0 {
                if Parser.parseProviderDetail(response: response, data: data) {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let providerDetailResponse = try jsonDecoder.decode(ProviderDetailResponse.self, from: data!)
                        
                        let typeDetail:TypeDetail  = providerDetailResponse.typeDetails
                        if !typeDetail.typeid.isEmpty() {
                            ProviderSingleton.shared.isAutoTransfer =  typeDetail.isAutoTransfer
                        }
                        if !self.isBack { //don't set height when you already press back button and after receive response from api, it will show glitch animation
                        }
                    } catch {
                        print("data may be wrong")
                    }
                }
            }
        }
    }

}

class MenuCell:CltVwCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        self.lblName.font = FontHelper.font(type: FontType.Regular)
        self.lblName.textColor = UIColor.themeLightTextColor
        self.lblIcon.setForIcon()
    }
    /*func setData(name:String,imageUrl:String) {
     lblName.text = name
     imgUser.image = UIImage.init(named: imageUrl)
     
     }*/
    
    func setData(name: String, icon: String , icons : UIImage) {
        self.lblName.text = name
        self.lblIcon.text = icon
        self.imgIcon.image = icons
    }
}

public extension UIViewController {
    static func clearPBRevealVC() {
        if let vC = APPDELEGATE.window?.rootViewController {
            if vC.isKind(of: PBRevealViewController.classForCoder()) {
                let pbrVC = vC as! PBRevealViewController
                pbrVC.delegate = nil
                
                pbrVC.tapGestureRecognizer?.delegate = nil
                pbrVC.panGestureRecognizer?.delegate = nil
                pbrVC.tapGestureRecognizer?.view?.removeGestureRecognizer(pbrVC.tapGestureRecognizer ?? UIGestureRecognizer())
                pbrVC.panGestureRecognizer?.view?.removeGestureRecognizer(pbrVC.tapGestureRecognizer ?? UIGestureRecognizer())
                
                pbrVC.mainViewController?.removeFromParent()
                pbrVC.mainViewController?.view.removeFromSuperview()
                pbrVC.leftViewController?.removeFromParent()
                pbrVC.leftViewController?.view.removeFromSuperview()
                
                pbrVC.leftViewController = UIViewController()
                pbrVC.mainViewController = UIViewController()
            }
        }
    }
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMenuTitle: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var iconMenu: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblMenuTitle.font = FontHelper.font(size: 16, type: FontType.Regular)
        self.lblMenuTitle.textColor = UIColor.themeLightTextColor
        cellView.layer.cornerRadius = 10
    }
    
    func setData(name: String, icon: String,icons: UIImage) {
        self.lblMenuTitle.text = name
        self.iconMenu.image = icons
    }
}
