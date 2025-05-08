//
//  InvoiceVC.swift
//  Edelivery
//   Created by Ellumination 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import Stripe

class InvoiceVC: BaseVC {
    
    /*Header View*/
    @IBOutlet  var navigationView: UIView!
    @IBOutlet  var btnMenu: UIButton!
    @IBOutlet  var imgMenu : UIImageView!
    @IBOutlet  var lblTitle: UILabel!
    @IBOutlet  var btnSubmit: UIButton!
    @IBOutlet  var imgSubmit: UIImageView!
    @IBOutlet  var lblTripType: UILabel!

    @IBOutlet  var viewForHeader: UIView!
    @IBOutlet  var lblTotalTime: UILabel!
//    @IBOutlet  var imgPayment: UIImageView!
    @IBOutlet  var lblPaymentIcon: UILabel!
    @IBOutlet  var imgPaymentIcon: UIImageView!
    @IBOutlet  var lblPaymentMode: UILabel!
    @IBOutlet  var lblDistance: UILabel!
    
    @IBOutlet  var lblTotal: UILabel!
    @IBOutlet  var lblTotalValue: UILabel!
    
    @IBOutlet  var viewForiInvoiceDialog: UIView!
    @IBOutlet  var lblTripId: UILabel!
    @IBOutlet  var lblMinFare: UILabel!
    
    @IBOutlet  var tblForInvoice: UITableView!
    var arrForInvoice:[[Invoice]]  = []
    var invoiceResponse:InvoiceResponse = InvoiceResponse.init()
    @IBOutlet  var lblIconDestination: UILabel!
    @IBOutlet  var imgIconDestination: UIImageView!
    @IBOutlet  var lblIconETA: UILabel!
    @IBOutlet  var imgIconETA: UIImageView!
     var socketHelper:SocketHelper = SocketHelper.shared
    
    /*Footer View*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketHelper.connectSocket()
        initialViewSetup()
        self.btnSubmit.enable()
        setupRevealViewController()
    }
    
    @IBAction func onClickBtnSubmitInvoice(_ sender: Any) {
        self.wsSubmitInvoice()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.wsGetInvoice()
    }
    
    func initialViewSetup(){
        
        lblTitle.text = "TXT_INVOICE".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        lblTotalTime.text = ""
        lblTotalTime.textColor = UIColor.themeTextColor
        lblTotalTime.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblDistance.text = ""
        lblDistance.textColor = UIColor.themeTextColor
        lblDistance.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblPaymentMode.text = ""
        lblPaymentMode.textColor = UIColor.themeTextColor
        lblPaymentMode.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        
        lblTotal.text = "TXT_TOTAL".localized
        lblTotal.textColor = UIColor.themeLightTextColor
        lblTotal.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblMinFare.text = "TXT_MIN_FARE".localized
        lblMinFare.textColor = UIColor.themeErrorTextColor
        lblMinFare.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        lblTotalValue.text = ""
        lblTotalValue.textColor = UIColor.themeSelectionColor
        lblTotalValue.font = FontHelper.font(size: FontSize.doubleExtraLarge, type: FontType.Bold)
        
        
        lblTripId.text = ""
        lblTripId.textColor = UIColor.themeLightTextColor
        lblTripId.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblTripType.text = ""
        lblTripType.textColor = UIColor.themeTextColor
        lblTripType.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblMinFare.isHidden = true
        self.tblForInvoice.tableHeaderView = UIView.init(frame: CGRect.zero)
        self.tblForInvoice.tableFooterView = UIView.init(frame: CGRect.zero)
        

//        btnMenu.setTitle(FontAsset.icon_menu, for: .normal)
//        btnMenu.setUpTopBarButton()
//
//        btnSubmit.setTitle(FontAsset.icon_checked, for: .normal)
//        btnSubmit.setUpTopBarButton()
        imgSubmit.tintColor = UIColor.themeImageColor
        
//        lblIconETA.text = FontAsset.icon_time
//        lblIconETA.setForIcon()
//        lblIconETA.font = FontHelper.assetFont(size: 40)
//        lblPaymentIcon.text = FontAsset.icon_card
//        lblPaymentIcon.setForIcon()
        imgPaymentIcon.image = UIImage(named: "icon_card")
        
//        lblIconDestination.text = FontAsset.icon_distance
//        lblIconDestination.setForIcon()
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    func setupLayout() {
        navigationView.navigationShadow()
    }

    func setupInvoice() {
        let tripDetail:InvoiceTrip = invoiceResponse.trip
        lblTripId.text = tripDetail.invoiceNumber
        lblTotalValue.text = tripDetail.total.toCurrencyString()
        if tripDetail.paymentMode == PaymentMode.CASH {
            imgPaymentIcon.image = UIImage.init(named: "asset-cash")
            //lblPaymentIcon.text = FontAsset.icon_payment_cash
            lblPaymentMode.text = "TXT_PAID_BY_CASH".localized
        } else if tripDetail.paymentMode == PaymentMode.CARD {
            imgPaymentIcon.image = UIImage.init(named: "asset-card")
            //lblPaymentIcon.text = FontAsset.icon_card
            lblPaymentMode.text = "TXT_PAID_BY_CARD".localized
        } else {
            imgPaymentIcon.image = UIImage.init(named: "asset-apple-pay")
            //lblPaymentIcon.text = FontAsset.icon_card
            lblPaymentMode.text = "TXT_PAID_BY_APPLE_PAY".localized
        }

        lblDistance.text = tripDetail.totalDistance.toString(places: 2) + Utility.getDistanceUnit(unit: tripDetail.unit)
        self.lblTotalTime.text = String(format:"%.2f%@", tripDetail.totalTime, MeasureUnit.MINUTES)

        if invoiceResponse.trip.tripType == TripType.AIRPORT || invoiceResponse.trip.tripType == TripType.CITY || invoiceResponse.trip.tripType == TripType.ZONE || tripDetail.isFixedFare {
            lblTripType.isHidden = false
            if invoiceResponse.trip.isFixedFare
            {
                lblTripType.text = "TXT_FIXED_FARE_TRIP".localized
            }
            else if invoiceResponse.trip.tripType == TripType.AIRPORT
            {
                lblTripType.text = "TXT_AIRPORT_TRIP".localized
            }
            else  if invoiceResponse.trip.tripType == TripType.ZONE
            {
                lblTripType.text = "TXT_ZONE_TRIP".localized
            }
            else  if invoiceResponse.trip.tripType == TripType.CITY
            {
                lblTripType.text = "TXT_CITY_TRIP".localized
            }
            else
            {
                lblTripType.isHidden = true
            }
        }
        else
        {
            lblTripType.isHidden = true
            if tripDetail.isMinFareUsed == TRUE
            {
                lblMinFare.isHidden = false
                lblMinFare.text = "TXT_MIN_FARE".localized + " " +  invoiceResponse.tripservice.minFare.toCurrencyString() + " " + "TXT_APPLIED".localized
            }
            else
            {
                lblMinFare.isHidden = true
            }
        }
    }
}

extension InvoiceVC :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForInvoice[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InvoiceCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice[indexPath.section][indexPath.row]
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell;
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        else if arrForInvoice[section].count == 0
        {
            return 0;
        }
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! InvoiceSection
        if arrForInvoice[section].count > 0
        {
        sectionHeader.setData(title: arrForInvoice[section][0].sectionTitle)
            return sectionHeader
        }
        else
        {
            return UIView.init()
        }
        
    }
   
}

extension InvoiceVC:PBRevealViewControllerDelegate
{
    @IBAction func onClickBtnMenu(_ sender: Any){
        
    }
    
    func setupRevealViewController(){
        self.revealViewController()?.panGestureRecognizer?.isEnabled = true
        btnMenu.addTarget(self.revealViewController(), action: #selector(PBRevealViewController.revealLeftView), for: .touchUpInside)
    }
    func revealController(_ revealController: PBRevealViewController, willShowLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = false;
    }
    func revealController(_ revealController: PBRevealViewController, willHideLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = true;
    }
}

extension InvoiceVC
{
    func wsGetInvoice() {
        Utility.showLoading()

        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]

        let dictParam:[String:String] =
            [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.TRIP_ID : ProviderSingleton.shared.tripId]

        let postData = try! JSONSerialization.data(withJSONObject: dictParam, options: [])

        let urlString:String = WebService.BASE_URL + WebService.GET_INVOICE

        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            print(data)
//            print(response)
//            print( error)
            print("\(#function)")
            
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    print("invoice \(json)")
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            if (error != nil)
            {
                self.wsGetInvoice()
                Utility.hideLoading()
            }
            else
            {
                Utility.hideLoading()

                // Code_By: Bhumita - git issue => user/120
                // Code_Function => recalls the invoice api if https status code is zero.
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 0{
                    self.wsGetInvoice()
                }
                OperationQueue.main.addOperation({
                    if Parser.isSuccess(response: [:], data: data, fromURL: WebService.GET_INVOICE)
                    {
                        let jsonDecoder = JSONDecoder()
                        do
                        {
                            self.invoiceResponse = try jsonDecoder.decode(InvoiceResponse.self, from: data!)
                            ProviderSingleton.shared.isTripEnd = self.invoiceResponse.trip.isTripEnd

                            print("\(#function) Dictionary=\(self.invoiceResponse)")

                            if Parser.parseInvoice(tripService: self.invoiceResponse.tripservice, tripDetail: self.invoiceResponse.trip, arrForInvocie: &self.arrForInvoice)
                            {
                                self.setupInvoice()
                                self.tblForInvoice.reloadData()
                            }
                            Utility.hideLoading()
                            
                            if ProviderSingleton.shared.isTripEnd == FALSE {
                                    Utility.showLoading()
                                self.wsPayPayment(tipAmount: 0.0)
                            } else {
                                if self.invoiceResponse.trip.paymentStatus == PAYMENT_STATUS.WAITING {
                                    Utility.showLoading()
                                    self.wsGetStripeIntent()
                                } else {
                                    self.btnSubmit.enable()
                                }
                            }
                        }
                        catch
                        {
                            print("wrong response")
                        }
                    }
                })
            }
        })
        dataTask.resume()
    }

    func wsPayPayment(tipAmount:Double) {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TIP_AMOUNT] = tipAmount.toString(places: 2).toDouble()
        dictParam[PARAMS.TRIP_ID] = ProviderSingleton.shared.tripId

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.PAY_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            }else {
//                OperationQueue.main.addOperation({
                    Utility.hideLoading()
                print("Paypayment response 1 \(response)")
                if Parser.isSuccess(response: response,data: data, andErrorToast: false , fromURL : WebService.PAY_PAYMENT) {
                    
                    if response["is_payment_pending"] as? Bool ?? false {
                        Utility.showToast(message: "Payment pending from user side.")
                        self.registerTripInvoiceSocket(id: preferenceHelper.getUserId())
                    }
                    
                    
                    if let paymentStatus: Int = response["payment_status"] as? Int {
                        if paymentStatus == PAYMENT_STATUS.FAILED{
                            self.wsFailPayment()
//                            self.wsGetInvoice()
                            self.btnSubmit.enable()
                        }else if paymentStatus != PAYMENT_STATUS.WAITING {
                            self.wsGetInvoice()
                            self.btnSubmit.enable()
                        } else {
                            if (response["required_param"] as? String)?.count ?? "".count > 0{
                                self.btnSubmit.enable()
                            }else{
                                if let paymentMethod =  response["payment_method"] as? String {
                                    if let clientSecret: String = response["client_secret"] as? String {
                                        self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret)
                                    }
                                }
                            }
                        }
                    }
                    return;
                }else{
                    DispatchQueue.main.async {
                        self.wsFailPayment()
                        print("Paypayment response 2 \(response)")
                        if (response["required_param"] as? String)?.count ?? "".count > 0{
                            self.btnSubmit.enable()
                        }
                        if response["is_payment_pending"] as? Bool ?? false {
                            Utility.showToast(message: "Payment pending from user side.")
                            self.registerTripInvoiceSocket(id: preferenceHelper.getUserId())
                        }
                    }
                }
//                })
            }
        }
    }
    
    func registerTripInvoiceSocket(id:String) {
        let myUserId = "'tdsp_trip_\(id)'"
        self.socketHelper.socket?.emit("room", myUserId)
        self.socketHelper.socket?.on(myUserId) {
            [weak self] (data, ack) in
            self?.wsGetInvoice()
            guard let `self` = self else { return }
            guard let response = data.first as? [String:Any] else
            
            { return }
            self.navigationController?.popViewController(animated: true)
            print("Soket Response\(response)")
        
        }
    }

    func wsGetStripeIntent()
    /*{
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] =  ProviderSingleton.shared.tripId

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_STRIPE_PAYMENT_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data) {
                    //self.emitTripNotification()
                    if let paymentMethod =  response["payment_method"] as? String {
                        if let clientSecret: String = response["client_secret"] as? String {
                            self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret)
                        }
                    } else {
                        self.wsFailPayment()
                    }
                } else {
                    self.wsFailPayment()
                }
            }
        }
    }*/
    {
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] =  ProviderSingleton.shared.tripId

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_STRIPE_PAYMENT_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data,fromURL: WebService.GET_STRIPE_PAYMENT_INTENT) {
                    //self.emitTripNotification()
                    if let paymentMethod =  response["payment_method"] as? String {
                        if let clientSecret: String = response["client_secret"] as? String {
                            self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret)
                        }
                    } else {
                        self.wsFailPayment()
                    }
                } else {
                    self.wsFailPayment()
                    /*if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                        self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "")
                    }else{
                        self.wsFailPayment()
                    }*/
                }
            }
        }
    }

   /* func openPaystackPinVerificationDialog(requiredParam:String,reference:String)
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

                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_PIN".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: text,otp : "", phone: "", dialog: dialogForPromo)
                        }
                    }
            case PaymentMethod.VerificationParameter.SEND_OTP:
                let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_OTP".localized, message: "EG_123456".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_OTP".localized,isHideBackButton: true)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in
                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_OTP".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : text, phone: "", dialog: dialogForPromo)
                        }
                    }
            case PaymentMethod.VerificationParameter.SEND_PHONE:
                let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_PHONE_NUMBER".localized, message: "MINIMUM_10_DIGITS".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_PHONE_NUMBER".localized,isHideBackButton: true)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in
                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_PHONE_NO".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
                        }
                    }
            case PaymentMethod.VerificationParameter.SEND_BIRTHDAY:
                let dialogForPromo = CustomPinVerificationDialog.showCustomAlertDialog(title: "ENTER_BIRTHDATE".localized, message: "EG_DD-MM-YYYY".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_BIRTHDATE".localized,isHideBackButton: false, isShowBirthdayTextfield: true)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in
                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_BIRTHDATE".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
                        }
                    }

            case PaymentMethod.VerificationParameter.SEND_ADDRESS:
                print(PaymentMethod.VerificationParameter.SEND_ADDRESS)
            //Didnt tested address flow
            /*  let dialogForPromo = CustomAddressVerificationDialog.showCustomAlertDialog(title: "Enter Address", message: "Eg. Xyz Building, St. road, Maharashtra, India 400001", titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "Enter Address",isHideBackButton: false)

             dialogForPromo.onClickLeftButton =
             { [unowned dialogForPromo] in
             dialogForPromo.removeFromSuperview();
             }

             dialogForPromo.onClickRightButton =
             { [unowned self, unowned dialogForPromo] (text:String) in
             if (text.count <  1)
             {
             Utility.showToast(message: "PLEASE_ENTER_BIRTHDATE".localized)
             }
             else
             {
             wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
             }
             }*/
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
             PARAMS.PHONE : "",
             PARAMS.TRIP_ID : ProviderSingleton.shared.tripId]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.SEND_PAYSTACK_REQUIRED_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response,data, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, data: data, withSuccessToast: false, andErrorToast: false)
            {
                dialog.removeFromSuperview()
                Utility.hideLoading()
                self.wsGetInvoice()
                self.btnSubmit.enable()
            }else{
                dialog.removeFromSuperview()
                if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                    self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "")
                }else{
                    Utility.showToast(message: response["error_message"] as? String ?? "")
                    self.wsFailPayment()
                }
            }
        }
    }
     */
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
                    print("Payment failed = \(error?.localizedDescription ?? "")")
                    self.wsFailPayment()
                    break
                case .canceled:
                    print("Payment canceled \(error?.localizedDescription ?? "")")
                    self.wsFailPayment()
                    break
                case .succeeded:
                    self.wsPayStripeIntentPayment()
                    break
                @unknown default:
                    fatalError()
                    break
            }
        }
    }

    func wsPayStripeIntentPayment() {
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] =  ProviderSingleton.shared.tripId
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.PAY_STRIPE_INTENT_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data,fromURL: WebService.PAY_STRIPE_INTENT_PAYMENT) {
                     OperationQueue.main.addOperation({
                        self.wsGetInvoice()
                    self.btnSubmit.enable()
                        return;})
                } else {}
            }
        }
    }

    func wsFailPayment() {
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] =  ProviderSingleton.shared.tripId
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.FAIL_STRIPE_INTENT_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.isSuccess(response: response,data: data,andErrorToast:false ,fromURL: WebService.FAIL_STRIPE_INTENT_PAYMENT) {
                    self.btnSubmit.enable()
                    Utility.hideLoading()
                    return;
                } else {}
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if SEGUE.TRIP_TO_FEEDBACK == segue.identifier
        {
            if let destinationVC:FeedbackVC = segue.destination as? FeedbackVC
            {
                destinationVC.tripDetail = self.invoiceResponse.trip
            }
        }
    }
}

class InvoiceCell:TblVwCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        lblTitle.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblTitle.textColor = UIColor.themeLightTextColor
        lblTitle.text = ""
        
        lblSubTitle.font = FontHelper.font(size: FontSize.small, type: .Light)
        lblSubTitle.textColor = UIColor.themeLightTextColor
        lblSubTitle.text = ""
        
        lblPrice.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        lblPrice.textColor = UIColor.themeTextColor
        lblPrice.text = ""
    }

    func setCellData(cellItem:Invoice) {
        lblTitle.text = cellItem.title!
        lblSubTitle.text = cellItem.subTitle!
        lblPrice.text = cellItem.price
    }
}

class InvoiceSection:TblVwCell
{
    @IBOutlet weak var lblSection: UILabel!
    override func awakeFromNib() {
        lblSection.textColor = UIColor.themeSelectionColor
        lblSection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
    }

    func setData(title: String)
    {
        lblSection.text =  title
    }
}

//MARK:- Web Service
extension InvoiceVC
{
    func startTripListner() {
        let myTripid = "'\(ProviderSingleton.shared.tripId)'"
        self.socketHelper.socket?.emit("room", myTripid)
        self.socketHelper.socket?.on(myTripid) {
            [weak self] (data, ack) in
            print("Socket Response \(data)")
            guard let `self` = self else { return }
            guard let response = data.first as? [String:Any] else { return }
            let isTripUpdate = (response[PARAMS.IS_TRIP_UPDATED] as? Bool) ?? false
            if isTripUpdate {
                print("Socket Response Trip Updated \(data)")
                self.wsGetInvoice()
            }
        }
    }

    func stopTripListner() {
        let myTripid = "'\(ProviderSingleton.shared.tripId)'"
        self.socketHelper.socket?.off(myTripid)
    }

    func wsSubmitInvoice() {
        if !ProviderSingleton.shared.tripId.isEmpty()
        {
            Utility.showLoading()
            var  dictParam : [String : Any] = [:]
            dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.TRIP_ID] = ProviderSingleton.shared.tripId
            
            let afh:AlamofireHelper = AlamofireHelper.init()
            afh.getResponseFromURL(url: WebService.SUBMIT_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data ,error) -> (Void) in
                if (error != nil)
                {Utility.hideLoading()}
                else
                {
                    if Parser.isSuccess(response: response,data: data,fromURL: WebService.SUBMIT_INVOICE)
                    {
                        self.socketHelper.disConnectSocket()
                        Utility.hideLoading()
                        self.performSegue(withIdentifier: SEGUE.TRIP_TO_FEEDBACK, sender: self)
                    }
                    else
                    {
                        Utility.hideLoading()
                    }
                }
            }
        }
        else{
        }
    }
}
extension InvoiceVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
