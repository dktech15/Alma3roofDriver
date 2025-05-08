//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: BaseVC,UITabBarDelegate,UIScrollViewDelegate {
    
    //MARK:- OutLets
    
    /*Navigation View*/
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var switchForWallet: UISwitch!
    @IBOutlet weak var lblWalletIcon: UILabel!
    @IBOutlet weak var imgWalletIcon: UIImageView!
    
    @IBOutlet weak var viewForShabCredits: UIView!
    
    @IBOutlet weak var btnWalletHistory: UIButton!
    @IBOutlet weak var btnAddCard: UIButton!
    
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWalletValue: UILabel!
    
    @IBOutlet weak var btnAddWalletAmount: UIButton!
    @IBOutlet weak var txtAddWallet: ACFloatingTextfield!
    
    @IBOutlet weak var paymentTab: UITabBar!
    @IBOutlet weak var lblSelectPaymentMethod: UILabel!
    /*containerView*/
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForStripe: UIView!
    @IBOutlet weak var containerForApplePay: UIView!
    @IBOutlet weak var viewForPaymentGateway: UIView!
    @IBOutlet weak var btnSenMony: UIButton!
    let socketHelper:SocketHelper = SocketHelper.shared
    var applePay: StripeApplePayHelper?
    
    var finalTabItems:[UITabBarItem] = []
    var viewControllers:[UIViewController]? = []
    var containerViews:[UIView]? = []
    var stripeVC:StripeVC!
    var applePayVC:ApplePayVC!
    var payStackVC:PayStackVC!
    var allCardResponse: AllCardResponse?
    var walletAmount = 0.0

    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socketHelper.connectSocket()
        startPaytabsListner()
        self.wsGetAllCards()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        socketHelper.disConnectSocket()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setUpLayout() {
        viewForShabCredits.navigationShadow()
        btnAddCard.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25, borderWidth: 1.0)
        lblSelectPaymentMethod.text = "Select your payment method".localized
        lblSelectPaymentMethod.sectionRound(lblSelectPaymentMethod)
        if (viewControllers?.count ?? 0) > 0
        {
            let frame = containerForStripe.frame
            scrollView.contentSize = CGSize(width: CGFloat(viewControllers!.count) * UIScreen.main.bounds.size.width, height: frame.size.height)
        }
    }
    
    func initialViewSetup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        finalTabItems = paymentTab.items!
        paymentTab.items?.removeAll()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        lblTitle.text = "TXT_PAYMENTS".localized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        btnEdit.isSelected = false
        
        switchForWallet.isHidden = true
        
        lblWallet.text = "TXT_WALLET".localized
        lblWallet.textColor = UIColor.themeLightTextColor
        lblWallet.font = FontHelper.font(size: FontSize.small, type: .Regular)
        
        lblWalletValue.textColor = UIColor.themeButtonBackgroundColor
        lblWalletValue.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        btnSenMony.setTitle("TXT_SEND_MONEY".localizedCapitalized, for: .normal)
        btnSenMony.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnSenMony.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Light)
        
        
        btnAddCard.setTitle("TXT_ADD_CARD".localizedCapitalized, for: .normal)
        btnAddCard.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnAddCard.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnAddCard.backgroundColor = UIColor.themeButtonBackgroundColor
        
        btnEdit.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnEdit.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Light)
        
        btnWalletHistory.setTitle("TXT_WALLET_HISTORY".localizedCapitalized, for: .normal)
        btnWalletHistory.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnWalletHistory.titleLabel?.font = FontHelper.font(size: FontSize.small, type: .Light)
        
        self.btnWalletHistory.isEnabled = true
        self.txtAddWallet.isHidden = true
        self.txtAddWallet.placeholder = "TXT_WALLET_AMOUNT".localized
        
        btnAddWalletAmount.setTitle("TXT_ADD".localizedCapitalized, for: .normal)
        btnAddWalletAmount.setTitle("TXT_SUBMIT".localizedCapitalized, for: .selected)
        btnAddWalletAmount.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnAddWalletAmount.setTitleColor(UIColor.themeButtonBackgroundColor, for: .selected)
        btnAddWalletAmount.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        
//        lblWalletIcon.text = FontAsset.icon_payment_wallet
//        lblWalletIcon.setForIcon()
        imgWalletIcon.tintColor = UIColor.themeImageColor
//        btnBack.setupBackButton()
        imgBack.tintColor = UIColor.themeImageColor
        
        finalTabItems.removeAll()
        
        stripeVC = ((storyboard?.instantiateViewController(withIdentifier: "stripeVC"))! as! StripeVC)
        self.viewControllers?.append(stripeVC)
        self.containerViews?.append(containerForStripe)
        self.initiateTabbarWith(vc: stripeVC, container: containerForStripe)
        self.finalTabItems.append(UITabBarItem.init(title: "Stripe", image: nil, tag: 0))
        
        if ProviderSingleton.shared.isApplePayModeAvailable {
            applePayVC = ((storyboard?.instantiateViewController(withIdentifier: "ApplePayVC"))! as! ApplePayVC)
            viewControllers?.append(applePayVC);
            containerViews?.append(containerForApplePay)
            self.initiateTabbarWith(vc: applePayVC, container: containerForApplePay)
            self.finalTabItems.append(UITabBarItem.init(title: "TXT_APPLE_PAY".localizedCapitalized, image: nil, tag: 1))
        }
        
        tabBar(paymentTab, didSelect: finalTabItems[0])
        
        self.adjustPaymentTabbar()
        
        stripeVC.didApiCalled = { [weak self] (allCardResponse: AllCardResponse) -> Void in
            guard let self = self else { return }
            self.allCardResponse = allCardResponse
            self.setWallet(response: allCardResponse)
        }
        
        payStackVC = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PayStackVC") as? PayStackVC
        payStackVC.gotPayUResopnse = { [weak self] (_ message: String, _ isCallIntentAPI:Bool, _ showPaymentRetryDialog:Bool) -> Void in
            guard let self = self else { return }
            if PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs{
                self.txtAddWallet.isHidden = true
                self.lblWalletValue.isHidden = false
                self.txtAddWallet.text = ""
//                self.socketHelper.connectSocket()
                
            }else
            if isCallIntentAPI{
                self.txtAddWallet.isHidden = true
                self.lblWalletValue.isHidden = false
                self.txtAddWallet.text = ""
                Utility.showToast(message: message)
            }
        }
    }
    
    //MARK:- Tabbar Methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        self.view.endEditing(true)
        switch item.tag
        {
        case 0:
            self.btnAddCard.isEnabled = true
            self.btnAddCard.alpha = 1.0
            goToPoint(point: containerForStripe.frame.origin.x)
            break
        case 1:
            self.btnAddCard.isEnabled = false
            self.btnAddCard.alpha = 0.5
            goToPoint(point: containerForApplePay.frame.origin.x)
            break
        default:
            break
        }
    }
    
    func initiateTabbarWith(vc:UIViewController, container:UIView)
    {
        self.addChild(vc)
        vc.view.frame = CGRect(x: container.frame.origin.x, y: container.frame.origin.y, width:  container.frame.width, height: container.frame.size.height)
        container.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func adjustPaymentTabbar()
    {
        paymentTab.barTintColor = UIColor.themeViewBackgroundColor
        paymentTab.backgroundColor = UIColor.themeViewBackgroundColor
        let newItems:NSArray = NSArray.init(array: finalTabItems)
        let frame = containerForStripe.frame
        paymentTab.setItems(newItems as? [UITabBarItem], animated: true)
        
        for i in 0..<containerViews!.count
        {
            containerViews?[i].frame = CGRect.init(x: ( UIScreen.main.bounds.size.width * CGFloat(i)), y: frame.origin.y, width: UIScreen.main.bounds.width, height: frame.size.height)
            scrollView.addSubview(containerViews![i])
        }
        scrollView.contentSize = CGSize(width: CGFloat(viewControllers!.count) * UIScreen.main.bounds.width, height: frame.size.height)
        if finalTabItems.count > 0
        {
            paymentTab.selectedItem = paymentTab.items?[0]
        }
    }
    
    func setWallet(response: AllCardResponse) {
        if response.paymentGateway[0].is_add_card {
            self.viewForPaymentGateway.isHidden = false
            self.btnAddCard.isHidden = false
        }else{
            self.viewForPaymentGateway.isHidden = true
            self.btnAddCard.isHidden = true
        }
        
        self.lblWalletValue.text =  response.wallet.toString(places: 2) + " " + response.walletCurrencyCode
        self.setSendMoneyButton(amount: response.wallet)
    }
    
    //MARK:- Scrollview methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let currentPage = scrollView.currentPage
            if currentPage <= ((viewControllers?.count) ?? 0 - 1) && currentPage >= 0
            {
                self.tabBar(paymentTab, didSelect: paymentTab.items![currentPage])
                paymentTab.selectedItem = paymentTab.items?[currentPage]
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.currentPage
        if currentPage <= (((viewControllers?.count) ?? 0) - 1) && currentPage >= 0
        {
            self.tabBar(paymentTab, didSelect: paymentTab.items![currentPage])
            paymentTab.selectedItem = paymentTab.items?[currentPage]
        }
    }
    
    func goToPoint(point:CGFloat) {
        DispatchQueue.main.async
        {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations:
                            {
                self.scrollView.contentOffset.x = point
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func startPaytabsListner() {
        self.stopPaytabsListner()
        let socket = "'\(socketHelper.paytabs)\(preferenceHelper.getUserId())'"
        self.socketHelper.socket?.on(socket) {
            [weak self] (data, ack) in
            guard let self = self else {
                return
            }
            guard let response = data.first as? [String:Any] else {
                return
            }
            let status = (response["payment_status"] as? Bool) ?? false
            if status {
                let msg: String = {
                    if let str = response["msg"] as? String {
                        return str
                    }
                    return ""
                }()
                let action: Int = {
                    if let int = response["action"] as? Int {
                        return int
                    }
                    return -1
                }()
                
                if action == 2 {
                    if !msg.isEmpty {
                        Utility.showToast(message: msg)
                    } else {
                        self.wsGetAllCards()
                    }
                } else if action == 1 {
                    if !msg.isEmpty {
                        Utility.showToast(message: msg)
                    } else {
                        self.wsGetAllCards()
                        Utility.showToast(message: "MSG_CODE_91".localized)
                    }
                }
            } else {
                Utility.hideLoading()
            }
        }
        
        let socketApple = "'\(socketHelper.applePay)\(preferenceHelper.getUserId())'"
        self.socketHelper.socket?.on(socketApple) {
            [weak self] (data, ack) in
            guard let self = self else {
                return
            }
            guard let response = data.first as? [String:Any] else {
                return
            }
            print("Soket Response Apple Pay \(response)")
            self.wsGetAllCards()
        }
    }
    
    func stopPaytabsListner() {
        let socket = "'\(socketHelper.paytabs)\(preferenceHelper.getUserId())'"
        let socketApple = "'\(socketHelper.applePay)\(preferenceHelper.getUserId())'"
        
        self.socketHelper.socket?.off(socket)
        self.socketHelper.socket?.off(socketApple)
    }
    
    //MARK:- IBActions
    @IBAction func onClickBtnAddWallet(_ sender: Any) {
        self.view.endEditing(true)
        if btnAddWalletAmount.isSelected
        {
            let selectedTab = paymentTab.selectedItem
            switch(selectedTab?.tag ?? 0) {
            case 0:
                if txtAddWallet.text!.toDouble() == 0.0 {
                    Utility.showToast(message: "VALIDATION_MSG_VALID_AMOUNT".localized)
                } else if StripeApplePayHelper.isApplePayAvailable()  {
                    let dialogForPayment = CustomAppleCardDialog.showCustomPaymentSelectionDialog()
                    dialogForPayment.onClickPaymentModeSelected  =  { [weak self]  (paymentMode) in
                        guard let self = self else { return }
                        if paymentMode == PaymentMode.APPLE_PAY {
                            self.wsGetStripeIntent(amount: self.txtAddWallet.text!.toDouble(), isApplePay: true)
                        } else {
                            self.doPayment()
                        }
                    }
                } else {
                    doPayment()
                }
                
                break;
            case 1:
                if txtAddWallet.text!.toDouble() == 0.0 {
                    Utility.showToast(message: "VALIDATION_MSG_VALID_AMOUNT".localized)
                } else {
                    //self.openApplePay()
                }
                break;
            default:
                break;
            }
        }
        else {
            self.txtAddWallet.isHidden = false
            self.lblWalletValue.isHidden = true
            btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
        }
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if btnAddWalletAmount.isSelected {
            self.txtAddWallet.isHidden = true
            self.lblWalletValue.isHidden = false
            self.txtAddWallet.text = ""
            self.btnAddWalletAmount.isSelected = false
        }else {
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                navigationVC.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func onClickBtnAddCard(_ sender: Any) {
        if PaymentMethod.Payment_gateway_type == PaymentMethod.Stripe_ID{//stripe
            self.performSegue(withIdentifier: SEGUE.PAYMENT_TO_ADD_CARD, sender: self)
        }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs{
            wsGetStripeIntent() 
        }else{
            self.performSegue(withIdentifier: SEGUE.PAYMENT_TO_PAYSTACK_WEBVIEW, sender: self)
        }
    }
    
    @IBAction func onClickBtnWalletHistory(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.WALLET_HISTORY, sender: self)
    }
}
//MARK: - Send money

extension PaymentVC{
    func setSendMoneyButton(amount : Double){
        self.btnSenMony.isHidden = true
        self.walletAmount = amount
        if amount > 0 && preferenceHelper.getIsSendMoney(){
            self.btnSenMony.isHidden = false
        }
        print("np - \(preferenceHelper.getIsSendMoney())")
    }
    @IBAction func actionSendMoney(_ sender: Any) {
        let sendMony = SendMoneyPopup.showCustomVerificationDialog(amount: self.walletAmount)
        sendMony.onClickCancelButton = {
            [unowned sendMony] in
            self.initialViewSetup()
            sendMony.removeFromSuperview()
        }
        
    }
}
extension PaymentVC {
    func doPayment() {
        if  PaymentMethod.Payment_gateway_type == PaymentMethod.New_payment && txtAddWallet.text!.toDouble() != 0.0 {
           print("new payment")
           btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
           self.wsGetStripeIntent(amount: self.txtAddWallet.text!.toDouble())
       } else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID && txtAddWallet.text!.toDouble() != 0.0 {
            btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
            self.wsGetStripeIntent(amount: self.txtAddWallet.text!.toDouble())
        } else if PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay && txtAddWallet.text!.toDouble() != 0.0 {
            btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
            self.wsGetStripeIntent(amount: self.txtAddWallet.text!.toDouble())
        } else if PaymentMethod.Payment_gateway_type == PaymentMethod.Paypal_ID && txtAddWallet.text!.toDouble() != 0.0 {
            if let allCardResponse = allCardResponse {
                let paypal = PaypalHelper.init(currrencyCode: allCardResponse.walletCurrencyCode, amount: self.txtAddWallet.text!)
                paypal.delegate = self
            }
        }else if !stripeVC.selectedCard.id.isEmpty && txtAddWallet.text!.toDouble() != 0.0 {
            btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
            self.wsGetStripeIntent(amount: self.txtAddWallet.text!.toDouble())
        }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs && txtAddWallet.text!.toDouble() != 0.0 {
            if stripeVC.selectedCard.id.isEmpty {
                Utility.showToast(message: "VALIDATION_MSG_ADD_CARD_FIRST".localized)
            } else {
                btnAddWalletAmount.isSelected = !btnAddWalletAmount.isSelected
                self.wsGetStripeIntent(amount: self.txtAddWallet.text!.toDouble())
            }
        }
        else {
            if stripeVC.selectedCard.id.isEmpty {
                Utility.showToast(message: "VALIDATION_MSG_ADD_CARD_FIRST".localized)
            }
            if txtAddWallet.text!.toDouble() == 0.0 {
                Utility.showToast(message: "VALIDATION_MSG_VALID_AMOUNT".localized)
            }
        }
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func wsAddAmountToWallet(paymentMethod:String, lastFour: String? = nil) {
        Utility.showLoading()
        var dictParam : [String : Any] = [PARAMS.USER_ID: preferenceHelper.getUserId(),
                                          PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                                          PARAMS.PAYMENT_INTENT_ID: paymentMethod,
                                          PARAMS.TYPE: CONSTANT.TYPE_PROVIDER]
        
        if let lastFour = lastFour {
            dictParam[PARAMS.PAYMENT_GATEWAY_TYPE] = 14
            dictParam[PARAMS.last_four] = lastFour
            dictParam[PARAMS.WALLET] = txtAddWallet.text!
        }
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.ADD_WALLET_AMOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response:response, data:data, withSuccessToast:true, andErrorToast:true) {
                let jsonDecoder = JSONDecoder()
                do {
                    let walletResponse:WalletResponse = try jsonDecoder.decode(WalletResponse.self, from: data!)
                    self.txtAddWallet.isHidden = true
                    self.lblWalletValue.isHidden = false
                    self.txtAddWallet.text = ""
                    self.lblWalletValue.text = walletResponse.wallet.toString(places: 2) + " " + walletResponse.walletCurrencyCode
                    self.setSendMoneyButton(amount: walletResponse.wallet)
                } catch {
                }
            }
        }
    }
    
    func openPaystackPinVerificationDialog(requiredParam:String,reference:String)
    {
        self.view.endEditing(true)
        
        switch requiredParam {
        case PaymentMethod.VerificationParameter.SEND_PIN:
            let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_PIN".localized, message: "EG_1234".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_PIN".localized,isHideBackButton: true)
            
            dialogForPromo.onClickLeftButton =
            { [unowned dialogForPromo] in
                dialogForPromo.removeFromSuperview();
            }
            
            dialogForPromo.onClickRightButton =
            { [unowned self, unowned dialogForPromo] (text:String) in
                
                if (text.count <  1) {
                    Utility.showToast(message: "PLEASE_ENTER_PIN".localized)
                }
                else {
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: text,otp : "", phone: "", dialog: dialogForPromo)
                }
            }
        case PaymentMethod.VerificationParameter.SEND_OTP:
            let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_OTP".localized, message: "EG_123456".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_OTP".localized,isHideBackButton: true)
            
            dialogForPromo.onClickLeftButton = { [unowned dialogForPromo] in
                dialogForPromo.removeFromSuperview();
            }
            
            dialogForPromo.onClickRightButton = { [unowned self, unowned dialogForPromo] (text:String) in
                if (text.count <  1) {
                    Utility.showToast(message: "PLEASE_ENTER_OTP".localized)
                }
                else {
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : text, phone: "", dialog: dialogForPromo)
                }
            }
        case PaymentMethod.VerificationParameter.SEND_PHONE:
            let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_PHONE_NUMBER".localized, message: "MINIMUM_10_DIGITS".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_PHONE_NUMBER".localized,isHideBackButton: true)
            
            dialogForPromo.onClickLeftButton = { [unowned dialogForPromo] in
                dialogForPromo.removeFromSuperview();
            }
            
            dialogForPromo.onClickRightButton = { [unowned self, unowned dialogForPromo] (text:String) in
                if (text.count <  1) {
                    Utility.showToast(message: "PLEASE_ENTER_PHONE_NO".localized)
                }
                else {
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
                }
            }
        case PaymentMethod.VerificationParameter.SEND_BIRTHDAY:
            let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_BIRTHDATE".localized, message: "EG_DD-MM-YYYY".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_BIRTHDATE".localized,isHideBackButton: false, isShowBirthdayTextfield: true)
            
            dialogForPromo.onClickLeftButton = { [unowned dialogForPromo] in
                dialogForPromo.removeFromSuperview();
            }
            
            dialogForPromo.onClickRightButton = { [unowned self, unowned dialogForPromo] (text:String) in
                if (text.count <  1) {
                    Utility.showToast(message: "PLEASE_ENTER_BIRTHDATE".localized)
                }
                else {
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
                }
            }
            
        case PaymentMethod.VerificationParameter.SEND_ADDRESS:
            print(PaymentMethod.VerificationParameter.SEND_ADDRESS)
            
        default:
            break
        }
    }
    
    
    func wsSendPaystackRequiredDetail(requiredParam:String,reference:String,pin:String,otp:String,phone:String,dialog:CustomPinVerificationDialog)
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId(),
         PARAMS.TOKEN  : preferenceHelper.getSessionToken(),
         PARAMS.TYPE : CONSTANT.TYPE_PROVIDER,
         PARAMS.PAYMENT_GATEWAY_TYPE : PaymentMethod.Payment_gateway_type,
         PARAMS.REFERENCE : reference,
         PARAMS.REQUIRED_PARAM : requiredParam,
         PARAMS.PIN : pin,
         PARAMS.OTP : otp,
         PARAMS.BIRTHDAY : "",
         PARAMS.ADDRESS : "",
         PARAMS.PHONE : ""]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.SEND_PAYSTACK_REQUIRED_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, data, error) -> (Void) in
            Utility.hideLoading()
            print("add wallet response = \(response)")
            dialog.removeFromSuperview()
            
            if Parser.isSuccess(response:response, data:data, withSuccessToast:true, andErrorToast:false) {
                let jsonDecoder = JSONDecoder()
                do {
                    let walletResponse:WalletResponse = try jsonDecoder.decode(WalletResponse.self, from: data!)
                    self.txtAddWallet.isHidden = true
                    self.lblWalletValue.isHidden = false
                    self.txtAddWallet.text = ""
                    self.lblWalletValue.text = walletResponse.wallet.toString(places: 2) + " " + walletResponse.walletCurrencyCode
                    self.setSendMoneyButton(amount: walletResponse.wallet)
                } catch {
                }
            } else {
                
                if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                    self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "")
                }else{
                    if (response["error_code"] as? String)?.count ?? "".count > 0{
                        Utility.showToast(message: "ERROR_CODE_\(response["error_code"] as? String ?? "")".localized)
                    }
                }
            }
        }
    }
    
    func wsAddAmountToWalletWithApplePay(paymentMethod:String, amount:Double, handler: @escaping (_ success:Bool) -> (Void))
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [PARAMS.USER_ID:preferenceHelper.getUserId(),
         PARAMS.TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.PAYMENT_INTENT_ID:paymentMethod,
         PARAMS.TYPE:CONSTANT.TYPE_PROVIDER
        ]
        print("add wallet param = \(dictParam)")
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.ADD_WALLET_AMOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, data, error) -> (Void) in
            Utility.hideLoading()
            print("add wallet response = \(response)")
            if Parser.isSuccess(response: response, data:data, withSuccessToast: false, andErrorToast: true)
            {
                let jsonDecoder = JSONDecoder()
                do {
                    let walletResponse:WalletResponse = try jsonDecoder.decode(WalletResponse.self, from: data!)
                    self.txtAddWallet.isHidden = true
                    self.lblWalletValue.isHidden = false
                    self.txtAddWallet.text = ""
                    self.lblWalletValue.text = walletResponse.wallet.toString(places: 2) + " " + walletResponse.walletCurrencyCode
                    self.setSendMoneyButton(amount: walletResponse.wallet)
                } catch {}
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    func wsGetStripeIntent()
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.PAYMENT_GATEWAY_TYPE  : PaymentMethod.Payment_gateway_type,
             PARAMS.TYPE : CONSTANT.TYPE_PROVIDER]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_STRIPE_ADD_CARD_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {
            (response, data, error) -> (Void) in
            if Parser.isSuccess(response: response, data: data) {
                Utility.hideLoading()
                print(response["authorization_url"] as? String ?? "")
                let pstkUrl = response["authorization_url"] as? String ?? ""
                self.payStackVC.htmlDataString = pstkUrl
                self.navigationController?.pushViewController(self.payStackVC, animated: true)
            }
        }
    }

}

extension PaymentVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAddWallet {
            let textFieldString = textField.text! as NSString;
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension PaymentVC: STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    func wsGetStripeIntent(amount:Double, isApplePay: Bool = false) {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_PROVIDER
        dictParam[PARAMS.AMOUNT] =  amount
        
        if isApplePay {
            dictParam[PARAMS.PAYMENT_GATEWAY_TYPE] = PaymentMethod.Stripe_ID
            dictParam[PARAMS.is_apple_pay] = true
            dictParam[PARAMS.is_wallet_amount] = true
        }
        
        if PaymentMethod.Payment_gateway_type == PaymentMethod.New_payment {
            dictParam["is_add_wallet"] = true
        }
        
        if let intValue = Int(PaymentMethod.Payment_gateway_type) {
            dictParam[PARAMS.PAYMENT_GATEWAY_TYPE] = intValue
        } else {
            dictParam[PARAMS.PAYMENT_GATEWAY_TYPE] = PaymentMethod.Payment_gateway_type
        }
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_STRIPE_PAYMENT_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if isApplePay {
                Utility.hideLoading()
                if Parser.isSuccess(response:response, data:data, andErrorToast:false) {
                    if let clientSecret: String = response["client_secret"] as? String {
                        let model = ApplePayHelperModel(amount: amount.clean, currencyCode: ProviderSingleton.shared.provider.walletCurrencyCode, country: ProviderSingleton.shared.provider.alpha2, applePayClientSecret: clientSecret)
                        self.applePay = StripeApplePayHelper(model: model)
                        self.applePay?.delegate = self
                        self.applePay?.openApplePayDialog()
                    }
                } else {
                    Utility.showToast(message: response["error"] as? String ?? "")
                }
            } else if PaymentMethod.Payment_gateway_type == PaymentMethod.Stripe_ID{//stripe
                if (error != nil) {
                    Utility.hideLoading()
                }else {
                    if Parser.isSuccess(response:response, data:data, andErrorToast:false) {
                        if let paymentMethod =  response["payment_method"] as? String {
                            if let clientSecret: String = response["client_secret"] as? String {
                                self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret)
                            }
                        } else {}
                    } else {
                        Utility.hideLoading()
                        Utility.showToast(message: response["error"] as? String ?? "")
                    }
                }
            }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID{
                
                if Parser.isSuccess(response:response, data:data, withSuccessToast:true, andErrorToast:false) {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let walletResponse:WalletResponse = try jsonDecoder.decode(WalletResponse.self, from: data!)
                        self.txtAddWallet.isHidden = true
                        self.lblWalletValue.isHidden = false
                        self.txtAddWallet.text = ""
                        self.lblWalletValue.text = walletResponse.wallet.toString(places: 2) + " " + walletResponse.walletCurrencyCode
                        self.setSendMoneyButton(amount: walletResponse.wallet)
                    } catch {
                    }
                }else {
                    Utility.hideLoading()
                    if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                        self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "")
                    }else{
                        Utility.showToast(message: response["error_message"] as? String ?? "")
                    }
                }
            }else  if PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID{
                self.payStackVC.htmlDataString = response["html_form"] as? String ?? ""
                self.navigationController?.pushViewController(self.payStackVC, animated: true)
                
            }else  if PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay{
                self.payStackVC.htmlDataString = response["html_form"] as? String ?? ""
                self.navigationController?.pushViewController(self.payStackVC, animated: true)
            }else  if PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs {
                self.payStackVC.htmlDataString = response["authorization_url"] as? String ?? ""
                self.navigationController?.pushViewController(self.payStackVC, animated: true)
            }  else if PaymentMethod.Payment_gateway_type == PaymentMethod.New_payment {
                self.payStackVC.htmlDataString = response["url"] as? String ?? ""
                self.navigationController?.pushViewController(self.payStackVC, animated: true)
                
            }
        }
    }
    
    func wsGetStripeIntentApplePay(paymentMethod:String, amount:Double, handler: @escaping (_ success:Bool, _ clientSecret:String, _ paymentMethod:String, _ errorMsg:String) -> (Void))
    {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_PROVIDER
        dictParam[PARAMS.AMOUNT] = amount
        dictParam[PARAMS.PAYMENT_METHOD] = paymentMethod
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_STRIPE_PAYMENT_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response:response, data:data, andErrorToast:false) {
                    if let paymentMethod =  response["payment_method"] as? String {
                        if let clientSecret: String = response["client_secret"] as? String {
                            handler(true, clientSecret, paymentMethod, "")
                        }
                    } else {}
                } else {
                    Utility.hideLoading()
                    handler(false, "", "", response["error"] as? String ?? "")
                }
            }
        }
    }
    
    func openStripePaymentMethod(paymentMethod:String, clientSecret: String) {
        StripeAPI.defaultPublishableKey = preferenceHelper.getStripeKey()
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethod
        
        //Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { [weak self] (status, paymentIntent, error) in
            guard let self = self else { return }
            switch (status) {
            case .failed:
                self.txtAddWallet.isHidden = true
                self.lblWalletValue.isHidden = false
                self.txtAddWallet.text = ""
                Utility.hideLoading()
                Utility.showToast(message: error?.localizedDescription ?? "")
                break
            case .canceled:
                self.txtAddWallet.isHidden = true
                self.lblWalletValue.isHidden = false
                self.txtAddWallet.text = ""
                Utility.hideLoading()
                Utility.showToast(message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                self.wsAddAmountToWallet(paymentMethod: paymentIntent?.stripeId ?? "")
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    //MARK:- Web Service Methods
    func wsGetAllCards() {
        Utility.showLoading()
        
        
        let dictParam : [String : Any] = [ PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                                           PARAMS.USER_ID: preferenceHelper.getUserId(),
                                           PARAMS.TYPE: CONSTANT.TYPE_PROVIDER];
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.USER_GET_CARDS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { response, data, error in
            
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response,data: data) {
                let jsonDecoder = JSONDecoder()
                do {
                    let allCardResponse:AllCardResponse = try jsonDecoder.decode(AllCardResponse.self, from: data!)
                    self.txtAddWallet.isHidden = true
                    self.lblWalletValue.isHidden = false
                    self.txtAddWallet.text = ""
                    self.btnAddWalletAmount.isSelected = false
                    self.setWallet(response: allCardResponse)
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }
    }
}

extension PaymentVC: PaypalHelperDelegate {
    func paymentSucess(capture: PaypalCaptureResponse) {
        txtAddWallet.text = capture.amount
        wsAddAmountToWallet(paymentMethod: "", lastFour: "paypal")
    }
    
    func paymentCancel() {
        print("payapal payment cancel")
    }
}

extension PaymentVC: StripeApplePayHelperDelegate {
    func didComplete() {
        self.txtAddWallet.isHidden = true
        self.lblWalletValue.isHidden = false
        self.txtAddWallet.text = ""
        self.btnAddWalletAmount.isSelected = false
        Utility.showLoading()
    }
    
    func didFailed(err: String) {
        Utility.showToast(message: err)
    }
}
