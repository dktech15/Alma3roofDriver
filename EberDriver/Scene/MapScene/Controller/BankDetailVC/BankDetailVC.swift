//
//  BankDetailVC.swift
//
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

struct ImageDocument {
    var imageName: String = ""
    var image: UIImage? = nil
    var tag: Int = 0
}

class BankDetailVC: BaseVC,UITextFieldDelegate {
    
    //MARK: - Outlets Declaration
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var scrBankDetail: UIScrollView!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtRoutingNumber: UITextField!
    @IBOutlet weak var txtPersonalIdNumber: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtStateCode: UITextField!
    @IBOutlet weak var lblGender: UILabel!
    
//    @IBOutlet weak var radioBtnForMale: UILabel!
//    @IBOutlet weak var radioBtnForFemale: UILabel!
//asset-radio-selected
    //asset-radio-normal
        @IBOutlet weak var imgradioBtnForMale: UIImageView!
        @IBOutlet weak var imgradioBtnForFemale: UIImageView!

    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    
    @IBOutlet weak var lastLine: UIView!
    @IBOutlet weak var stkViewForGender: UIStackView!
    var imgDocVw: ImageUploadVw = ImageUploadVw.fromNib()
    
    var password:String = ""
    var bankDetail:BankDetail? = nil
    var dialogForImage:CustomPhotoDialog?;
    var isPicAdded: Bool = false
    var gender:String = ""
    
    var arrForImage:[ImageDocument] = [
        ImageDocument.init(imageName: "BANK_DETAIL_IMAGE_DOC_1".localized, image: nil,tag: 0),
        ImageDocument.init(imageName: "BANK_DETAIL_IMAGE_DOC_2".localized, image: nil,tag: 1),
        ImageDocument.init(imageName: "BANK_DETAIL_IMAGE_DOC_3".localized, image: nil,tag: 2)
    ]
    
    @IBOutlet weak var vwImgDoc: RootVw!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var hTblVw: NSLayoutConstraint!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
        enableTextFields(enable: true)
        self.wsGetBankDetail()
        self.imgDocVw.add(into: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.vwImgDocConfig()
            self.navigationView.navigationShadow()
        }
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func initialViewSetup() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.scrBankDetail.backgroundColor = UIColor.themeViewBackgroundColor;
        txtAccountNumber.textColor = UIColor.themeTextColor
        txtAccountHolderName.textColor = UIColor.themeTextColor
        txtRoutingNumber.textColor = UIColor.themeTextColor
        txtPersonalIdNumber.textColor = UIColor.themeTextColor
        txtDob.textColor = UIColor.themeTextColor
        self.btnSave.setImage(UIImage.init(named: "asset-save"), for: .normal)
        btnSave.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        btnSave.setTitleColor(UIColor.themeTextColor  , for: .normal)
        lblGender.text = "Gender".localized
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
        /*Set Text*/
        lblTitle.text = "TXT_BANK_DETAIL".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        txtAccountNumber.placeholder = "TXT_ACCOUNT_NUMBER".localized
        txtAccountHolderName.placeholder =  "TXT_ACCOUNT_HOLDER_NAME".localized
        if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.Paypal_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs {
            txtRoutingNumber.placeholder = "TXT_BANK_CODE".localized
        }else{
            txtRoutingNumber.placeholder = "TXT_ROUTING_NUMBER".localized
        }
        
        txtPersonalIdNumber.placeholder = "TXT_PERSONAL_ID_NUMBER".localized
        txtDob.placeholder = "TXT_DOB".localized
        txtPostalCode.placeholder = "TXT_POSTAL_CODE".localized
        txtStateCode.placeholder = "TXT_STATE_CODE".localized
        txtAddress.placeholder = "TXT_ADDRESS".localized
//        btnMale.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
//        btnMale.setTitleColor(UIColor.themeLightTextColor  , for: .normal)
        lblMale.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        lblMale.textColor = UIColor.themeLightTextColor
        lblMale.text = "TXT_GENDER_MALE".localizedCapitalized
        
        lblFemale.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        lblFemale.textColor = UIColor.themeLightTextColor
        lblFemale.text = "TXT_GENDER_FEMALE".localizedCapitalized
        
//        btnFemale.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
//        btnFemale.setTitleColor(UIColor.themeLightTextColor  , for: .normal)
//        btnMale.setTitle("TXT_GENDER_MALE".localizedCapitalized, for: .normal)
//        btnFemale.setTitle("TXT_GENDER_FEMALE".localizedCapitalized, for: .normal)
        
        /*Set Font*/
        txtAccountNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtAccountHolderName.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtRoutingNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtPersonalIdNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtAddress.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        txtDob.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        
//        radioBtnForMale.text = FontAsset.icon_radio_box_normal
//        radioBtnForFemale.text = FontAsset.icon_radio_box_normal
//        radioBtnForMale.setForIcon()
//        radioBtnForFemale.setForIcon()
        imgradioBtnForMale.image = UIImage(named: "asset-radio-normal")
        imgradioBtnForFemale.image = UIImage(named: "asset-radio-normal")
        
        lblGender.textColor = UIColor.themeLightTextColor
        
        self.tblVw.register(ImageDocumentCell.nib, forCellReuseIdentifier: ImageDocumentCell.nm)
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwImgDoc.shadow = Shadow(toVw: self.vwImgDoc)
        self.vwImgDoc.shadow.radius = 5.0
        self.vwImgDoc.shadow.opacity = 0.15
        setAccordingTOPaymentgateway()
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDob {
            self.view.endEditing(true)
            openDatePicker()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtAccountHolderName {
            txtAccountNumber.becomeFirstResponder()
        }else if textField == txtAccountNumber {
            txtRoutingNumber.becomeFirstResponder()
        }else if textField == txtRoutingNumber {
            txtPersonalIdNumber.becomeFirstResponder();
        }else if textField == txtPersonalIdNumber {
            txtDob.becomeFirstResponder()
        }else if textField == txtDob {
            txtAddress.becomeFirstResponder()
        }else if textField == txtAddress {
            txtStateCode.becomeFirstResponder()
        }else if textField == txtStateCode {
            txtPostalCode.becomeFirstResponder()
        }else {
            textField.resignFirstResponder();
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPersonalIdNumber {
            if  (string == "") || string.count < 1 {
                return true
            }
        }
        return true;
    }
    
    //MARK: - Action Methods
    @IBAction func onClickBtnSave(_ sender: Any) {
        if self.btnSave.tag == 0 {
            if (checkValidation()) {
                if ProviderSingleton.shared.provider.socialUniqueId.isEmpty {
                    openVerifyAccountDialog()
                } else {
                    self.wsAddBankDetail()
                }
            }
        } else {
            if ProviderSingleton.shared.provider.socialUniqueId.isEmpty {
                openVerifyAccountDialog()
            } else {
                self.wsDeleteBankDetail()
            }
        }
    }
    
    @IBAction func onClickBtnMale(_ sender: UIButton) {
//        radioBtnForMale.text = FontAsset.icon_radio_box_selected
//        radioBtnForFemale.text = FontAsset.icon_radio_box_normal
        imgradioBtnForFemale.image = UIImage(named: "asset-radio-normal")
        imgradioBtnForMale.image = UIImage(named: "asset-radio-selected")
        lblMale.textColor = UIColor.themeTextColor
        lblFemale.textColor = UIColor.themeLightTextColor
        
//        btnMale.setTitleColor(UIColor.themeTextColor  , for: .normal)
//        btnFemale.setTitleColor(UIColor.themeLightTextColor  , for: .normal)
        gender = "male"
    }
    
    @IBAction func onClickBtnFemale(_ sender: UIButton) {
//        radioBtnForMale.text = FontAsset.icon_radio_box_normal
//        radioBtnForFemale.text = FontAsset.icon_radio_box_selected
        imgradioBtnForMale.image = UIImage(named: "asset-radio-normal")
        imgradioBtnForFemale.image = UIImage(named: "asset-radio-selected")
        
        lblMale.textColor = UIColor.themeLightTextColor
        lblFemale.textColor = UIColor.themeTextColor
        
//        btnFemale.setTitleColor(UIColor.themeTextColor  , for: .normal)
//        btnMale.setTitleColor(UIColor.themeLightTextColor  , for: .normal)
        gender = "female"
    }
    
    func enableTextFields(enable: Bool) -> Void{
        self.view.isUserInteractionEnabled = enable
        txtAccountNumber.isEnabled = enable
        txtRoutingNumber.isEnabled = enable
        txtAccountHolderName.isEnabled = enable
        txtPersonalIdNumber.isEnabled = enable
        txtDob.isEnabled = enable
        txtPostalCode.isEnabled = enable
        txtStateCode.isEnabled = enable
        txtAddress.isEnabled = enable
    }
    
    //MARK: - User Define Methods
    func checkValidation() -> Bool{
        if PaymentMethod.Payment_gateway_type == PaymentMethod.Stripe_ID {
            if (
                (txtAccountNumber.text?.isEmpty())! ||
                (txtAccountHolderName.text?.isEmpty())! ||
                (txtRoutingNumber.text?.isEmpty())! ||
                (txtPersonalIdNumber.text?.isEmpty())! ||
                (txtDob.text?.isEmpty())! ||
                (txtStateCode.text?.isEmpty())! ||
                (txtPostalCode.text?.isEmpty())! ||
                (txtAddress.text?.isEmpty())! ||
                (gender == "")
            ) {
                if (txtAccountHolderName.text!.isEmpty()) {
                    txtAccountHolderName.becomeFirstResponder();
                    Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_ACCOUNT_HOLDER_NAME".localized)
                }else if (txtAccountNumber.text!.isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_ACCOUNT_NUMBER".localized)
                    txtAccountNumber.becomeFirstResponder()
                }else if (txtRoutingNumber.text!.isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_ROUTING_NUMBER".localized)
                    txtRoutingNumber.becomeFirstResponder();
                }else if (txtPersonalIdNumber.text!.trim().isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_PERSONAL_ID_NUMBER".localized)
                    txtPersonalIdNumber.becomeFirstResponder();
                }else if (txtDob.text!.isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_DOB".localized)
                    txtDob.becomeFirstResponder();
                }else if (gender == "") {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_SELECT_GENDER".localized)
                }else if ((txtAddress.text?.count)! <  1) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_ADDRESS".localized)
                    txtAddress.becomeFirstResponder()
                }else if (txtStateCode.text!.isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_STATE_CODE".localized)
                    txtStateCode.becomeFirstResponder()
                }else if ((txtPostalCode.text?.count)! <  1) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_POSTAL_CODE".localized)
                    txtPostalCode.becomeFirstResponder()
                }
                return false;
            } else {
                for img in arrForImage {
                    if img.image == nil  {
                        Common.alert("Error", img.imageName)
                        return false
                    }
                }
                return true
            }
        } else {
            if ((txtAccountNumber.text?.isEmpty())! || (txtRoutingNumber.text?.isEmpty())! ) {
                if (txtAccountNumber.text!.isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_ACCOUNT_NUMBER".localized)
                    txtAccountNumber.becomeFirstResponder()
                } else if (txtRoutingNumber.text!.isEmpty()) {
                    Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_BANK_CODE".localized)
                    txtRoutingNumber.becomeFirstResponder();
                }
                return false;
            }else{
                return true
            }
        }
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openVerifyAccountDialog() {
        self.view.endEditing(true)
        if !ProviderSingleton.shared.provider.socialUniqueId.isEmpty {
            self.password = ""
            if (self.btnSave.tag == 1) {
                self.wsDeleteBankDetail()
            } else {
                self.wsAddBankDetail();
            }
        } else {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "".localized, titleLeftButton: "TXT_NO".localized, titleRightButton: "TXT_YES".localized, editTextHint: "TXT_PASSWORD".localized,  editTextInputType: true)
            dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
                dialogForVerification.removeFromSuperview();
            }
            dialogForVerification.onClickRightButton = { [unowned self, unowned dialogForVerification] (text:String) in
                if (text.count < passwordMinLength) {
                    if text.isEmpty {
                        dialogForVerification.editText.showErrorWithText(errorText: "VALIDATION_MSG_ENTER_PASSWORD".localized)
                    } else {
                        let myString = String(format: NSLocalizedString("VALIDATION_MSG_INVALID_PASSWORD", comment: ""),passwordMinLength.toString())
                        dialogForVerification.editText.showErrorWithText(errorText: myString)
                    }
                } else {
                    self.password = text
                    if (self.btnSave.tag == 1) {
                        self.wsDeleteBankDetail()
                    } else {
                        self.wsAddBankDetail();
                    }
                    dialogForVerification.removeFromSuperview();
                }
            }
        }
    }
    
    func openErrorDialog(strMessage:String) {
        let dialogForNote = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ERROR".localized, message: strMessage, titleLeftButton: "", titleRightButton: "TXT_OK".localized)
        dialogForNote.onClickLeftButton = { [unowned dialogForNote] in
            dialogForNote.removeFromSuperview();
        }
        dialogForNote.onClickRightButton = { [unowned dialogForNote] in
            dialogForNote.removeFromSuperview();
        }
    }
    
    func setBankData() {
        setAccordingTOPaymentgateway()
        if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.Paypal_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs ||  PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay {
            let s = (bankDetail?.accountNumber)!
            var str : String = ""
            for j in 1...4 {
                let i = s.index(s.startIndex, offsetBy: s.count-j)
                str = str + String(s[i])
            }
            self.txtAccountNumber.text = "*******" + str
        } else {
            self.txtAccountNumber.text = "*******" + (bankDetail?.accountNumber ?? "")
        }
        
        self.txtAccountHolderName.text = bankDetail?.accountHolderName
        self.txtPersonalIdNumber.text = ""
        self.txtRoutingNumber.text = bankDetail?.routingNumber
        self.txtDob.isHidden = true
        self.txtPersonalIdNumber.isHidden = true
        self.btnSave.setImage(UIImage.init(named: "asset-close"), for: .normal)
        self.btnSave.tag = 1
        self.scrBankDetail.isUserInteractionEnabled = false
        self.txtStateCode.isHidden = true
        self.txtPostalCode.isHidden = true
        self.stkViewForGender.isHidden = true
        self.txtAddress.isHidden = true
        self.lastLine.isHidden = true
    }
    
    func resetBankData() {
        self.txtAccountNumber.text = ""
        self.txtAccountHolderName.text = ""
        self.txtStateCode.text = ""
        self.txtAddress.text = ""
        self.txtPostalCode.text = ""
        self.gender = ""
        self.txtPersonalIdNumber.text = ""
        self.txtRoutingNumber.text = ""
        self.txtDob.text = ""
        self.txtPersonalIdNumber.text = ""
        self.txtDob.isHidden = false
        self.txtPersonalIdNumber.isHidden = false
        self.txtPostalCode.isHidden = false
        self.txtStateCode.isHidden = false
        self.txtAddress.isHidden = false
        self.stkViewForGender.isHidden = false
        self.lastLine.isHidden = false
        self.btnSave.setImage(UIImage.init(named: "asset-save"), for: .normal)
        self.btnSave.tag = 0
        self.scrBankDetail.isUserInteractionEnabled = true
        setAccordingTOPaymentgateway()
    }
    
    func setAccordingTOPaymentgateway() {
        if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.Paypal_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs || PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay{
            self.txtAccountHolderName.isHidden = true
            self.txtPersonalIdNumber.isHidden = true
            self.txtDob.isHidden = true
            self.stkViewForGender.isHidden = true
            self.txtAddress.isHidden = true
            self.txtStateCode.isHidden = true
            self.txtPostalCode.isHidden = true
            self.vwImgDoc.isHidden = true
            self.lastLine.isHidden = true
        } else {
            self.txtAccountHolderName.isHidden = false
            self.txtPersonalIdNumber.isHidden = false
            self.txtDob.isHidden = false
            self.stkViewForGender.isHidden = false
            self.txtAddress.isHidden = false
            self.txtStateCode.isHidden = false
            self.txtPostalCode.isHidden = false
            self.vwImgDoc.isHidden = false
            self.lastLine.isHidden = false
        }
    }
    
    @IBAction func onClickBtnAddImage(_ sender: Any) {
        openImageDialog()
    }
    
    func openImageDialog() {
        self.view.endEditing(true)
        self.dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
            self.isPicAdded = true
            dialogForImage?.removeFromSuperview()
        }
    }
    
    func openDatePicker() {
        self.view.endEditing(true)
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -13
        let maxDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DOB_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        
        datePickerDialog.setMaxDate(maxdate: maxDate)
        
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] (selectedDate:Date) in
            self.txtDob.text = Utility.dateToString(date: selectedDate, withFormat: DateFormat.DD_MM_YY)
            datePickerDialog.removeFromSuperview()
        }
    }
}

extension BankDetailVC {
    func wsGetBankDetail() {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [PARAMS.PASSWORD: password  ,
         PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
         PARAMS.TOKEN: preferenceHelper.getSessionToken(),
         PARAMS.SOCIAL_UNIQUE_ID : ProviderSingleton.shared.provider.socialUniqueId
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.GET_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, data,error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data,withSuccessToast: false,andErrorToast: false) {
                let jsonDecoder = JSONDecoder()
                do {
                    let bankDetailResponse:BankDetailResponse = try jsonDecoder.decode(BankDetailResponse.self, from: data!)
                    PaymentMethod.Payment_gateway_type = "\(bankDetailResponse.payment_gateway_type)"
                    
                    self.bankDetail = bankDetailResponse.bankdetails
                    self.setBankData()
                }catch {
                    print("Exception")
                }
            }else {
                PaymentMethod.Payment_gateway_type = "\(response["payment_gateway_type"] ?? "")"
                if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.Paypal_ID || PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs || PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay{
                    self.txtRoutingNumber.placeholder = "TXT_BANK_CODE".localized
                }else{
                    self.txtRoutingNumber.placeholder = "TXT_ROUTING_NUMBER".localized
                }
                self.resetBankData()
//                if PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay{
//                    self.setBankData()
//                    self.txtRoutingNumber.placeholder = "TXT_BANK_CODE".localized
//                }
            }
        }
    }
    
    func wsAddBankDetail() {
        
        Utility.showLoading()
        
        var dictParam : [String : Any] = [:]
        var images: [UIImage] = []
        
        if PaymentMethod.Payment_gateway_type == PaymentMethod.Stripe_ID{
            
            dictParam  =
            [ PARAMS.BANK_ACCOUNT_HOLDER_NAME   : txtAccountHolderName.text!,
              PARAMS.BANK_ACCOUNT_NUMBER      : txtAccountNumber.text!  ,
              PARAMS.BANK_ROUTING_NUMBER   : txtRoutingNumber.text!,
              PARAMS.BANK_PERSONAL_ID_NUMBER   : txtPersonalIdNumber.text!,
              PARAMS.BANK_DOB   : txtDob.text!,
              PARAMS.PASSWORD: password  ,
              PARAMS.BANK_HOLDER_TYPE: CONSTANT.INDIVIDUAL,
              PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
              PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
              PARAMS.TOKEN: preferenceHelper.getSessionToken(),
              PARAMS.SOCIAL_UNIQUE_ID : ProviderSingleton.shared.provider.socialUniqueId,
              PARAMS.ADDRESS: txtAddress.text!,
              PARAMS.STATE_CODE: txtStateCode.text!,
              PARAMS.POSTAL_CODE: txtPostalCode.text!,
              PARAMS.GENDER: self.gender,
              PARAMS.PAYMENT_GATEWAY_TYPE : PaymentMethod.Payment_gateway_type
            ]
            for imageDoc in self.arrForImage {
                images.append(imageDoc.image ?? UIImage())
            }
        }else{
            dictParam  =
            [
                PARAMS.BANK_ACCOUNT_NUMBER      : self.txtAccountNumber.text ?? ""  ,
                PARAMS.BANK_CODE   : self.txtRoutingNumber.text ?? "",
                PARAMS.PASSWORD: password  ,
                PARAMS.PAYMENT_GATEWAY_TYPE : PaymentMethod.Payment_gateway_type,
                PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
                PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.BANK_HOLDER_TYPE: CONSTANT.INDIVIDUAL,
            ]
        }
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.ADD_BANK_DETAIL, paramData: dictParam, images: images) {(response, data,error) -> (Void) in
            
            print(response)
            
            let isShowErrorToast: Bool = {
                if let errCode = response["error_code"] as? Int {
                    if errCode == 434 {
                        return true
                    }
                } else if let errcode = response["error_code"] as? String {
                    if errcode == "434" {
                        return true
                    }
                }
                return false
            }()
            
            if Parser.isSuccess(response: response,data: data, andErrorToast: isShowErrorToast) {
                DispatchQueue.main.async {
                    Utility.hideLoading()
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                Utility.hideLoading()
                if let code = response["error_code"] as? Int {
                    if code != 434 {
                        self.openErrorDialog(strMessage: (response["stripe_error"] as? String) ?? "Error")
                    }
                } else if let code = response["error_code"] as? String {
                    if code != "434" {
                        self.openErrorDialog(strMessage: (response["stripe_error"] as? String) ?? "Error")
                    }
                } else {
                    self.openErrorDialog(strMessage: (response["stripe_error"] as? String) ?? "Error")
                }
            }
        }
    }
    
    func wsDeleteBankDetail() {
        Utility.showLoading()
        
        let dictParam : [String : Any] =
        [PARAMS.PASSWORD: password  ,
         PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
         PARAMS.TOKEN: preferenceHelper.getSessionToken(),
         PARAMS.SOCIAL_UNIQUE_ID : ProviderSingleton.shared.provider.socialUniqueId,
         PARAMS.PAYMENT_GATEWAY_TYPE : PaymentMethod.Payment_gateway_type
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.DELETE_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, data,error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data) {
                self.resetBankData()
            }else {
                self.openErrorDialog(strMessage: (response["stripe_error"] as? String) ?? "Error")
            }
        }
    }
}

extension BankDetailVC : UITableViewDelegate,UITableViewDataSource {
    func vwImgDocConfig() {
        self.tblVw.reloadData(hToFit: self.hTblVw) { [weak self] in
            guard let self = self else { return }
            
            self.vwImgDoc.shadow.path = self.vwImgDoc.bounds
            self.vwImgDoc.shadow.draw()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrForImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageDocumentCell.nm, for: indexPath) as! ImageDocumentCell
        cell.setData(self.arrForImage[indexPath.row], indexPath)
        cell.didSelect = { [weak self] (document: ImageDocument) -> Void in
            guard let self = self else { return }
            self.openImageDialog(document: document)
        }
        
        return cell
    }
    
    //MARK: - TblVwDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func openImageDialog(document:ImageDocument) {
        self.view.endEditing(true)
        self.imgDocVw.lblDocumentName.text = document.imageName
        self.imgDocVw.reload(document, self)
        self.imgDocVw.onImageSelected = { [weak self] (image)  in
            guard let self = self else { return}
            self.arrForImage[document.tag].image = image
            self.tblVw.reloadData()
            self.imgDocVw.hide()
        }
    }
}

extension NSObject {
    class var nm: String {
        return String(describing: self)
    }
    var typeNm: String {
        return type(of: self).nm
    }
}

extension UIView {
    class var nib: UINib {
        let type = self.self
        return UINib(nibName: type.nm, bundle: nil)
    }
    
    class func fromNib<T: UIView>() -> T {
        let type = self.self
        let objs = Bundle.main.loadNibNamed(type.nm, owner: nil, options: nil)
        guard let nibObjs = objs else { return type.init() as! T }
        
        for nibObj in nibObjs {
            let obj = nibObj as AnyObject
            
            if obj.isKind(of: type) {
                return obj as! T
            }
        }
        return type.init() as! T
    }
    
    func clean() {
        for subvw in self.subviews {
            subvw.clean()
        }
        if self.superview == Common.appDelegate.window {
            self.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self)
    }
}
