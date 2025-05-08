//
//  DocumentVC.swift
//  edelivery
//
//  Created by tag on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DocumentVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    // MARK: - OUTLET
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblMandatoryFields: UILabel!
    @IBOutlet weak var tblForDocumentList: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    /*doc Dialog*/
    @IBOutlet weak var dialogForDocument: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmitDocument: UIButton!
    
    @IBOutlet weak var stkForDoc: UIStackView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet weak var lblMandatory: UILabel!
    
    @IBOutlet weak var documentDialog: UIView!
    @IBOutlet weak var viewForDocumentImage: UIView!
    
    // MARK: - Variables
    var arrdocumentList:NSMutableArray = []
    var documentListLength:Int? = 0
    var selectedDocument:ProviderDocument? = nil
    var selectedIndex = 0;
    var isPicAdded: Bool = false;
    var dialogForImage:CustomPhotoDialog? = nil;
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycle
    override func viewDidLoad(){
        super.viewDidLoad()
        lblMandatory.isHidden = true
        if #available(iOS 10.0, *) {
            tblForDocumentList.refreshControl = refreshControl
        } else {
            tblForDocumentList.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
        setLocalization()
        wsGetDocumentList()
        btnSubmit.isEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        viewForDocumentImage.isUserInteractionEnabled = true
        viewForDocumentImage.addGestureRecognizer(tapGestureRecognizer)
        tblForDocumentList.estimatedRowHeight = 80
        tblForDocumentList.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setLocalization(){
        
        lblMandatoryFields.text = "TXT_MANDATORY_FIELDS".localized
        
        lblTitle.text = "TXT_DOCUMENTS".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        refreshControl.tintColor = UIColor.black
        view.addSubview(dialogForDocument)
        dialogForDocument.isHidden = true
        
        tblForDocumentList.backgroundColor = UIColor.themeViewBackgroundColor
        
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblMandatoryFields.textColor = UIColor.themeErrorTextColor;
        updateUI(isUpdate:false)
        
        lblMandatory.text = "*".localized
        lblMandatory.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblMandatory.textColor = UIColor.themeErrorTextColor
        
        /*Set Font*/
        lblMandatoryFields.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnSubmit.titleLabel?.font = FontHelper.font(size: FontSize.button, type: FontType.Regular)
        btnCancel.titleLabel?.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        
        btnCancel.setTitle("TXT_CANCEL".localizedCapitalized, for: .normal)
        btnSubmitDocument.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        btnSubmitDocument.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmitDocument.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmitDocument.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        
        txtExpDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtDocId.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblDocTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        btnSubmit.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSubmit.titleLabel?.font  = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
    }
    
    func setupLayout(){
        dialogForDocument.frame = view.bounds
        tblForDocumentList.tableFooterView = UIView.init()
        navigationView.navigationShadow()
        btnSubmitDocument.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
        btnSubmit.setRound(withBorderColor: UIColor.clear, andCornerRadious: 25.0, borderWidth: 1.0)
        documentDialog.setShadow()
        documentDialog.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
    }
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentListLength!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:DocumentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DocumentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentdocument:ProviderDocument = arrdocumentList[indexPath.row] as! ProviderDocument
        cell.setCellData(cellItem: currentdocument)
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedDocument = arrdocumentList[indexPath.row] as? ProviderDocument;
        selectedIndex = indexPath.row
        self.openDocumentUploadDialog(selectedDoc:selectedDocument!)
    }
    
    //MARK: - TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            openDatePicker()
            return false
        }else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    //MARK: - ACTION FUNCTION
    @IBAction func onClickBtnSubmit(_ sender: Any){
        selectedDocument?.uniqueCode = txtDocId.text!
        wsUploadDocuments(selectedDoc:selectedDocument!)
    }

    @IBAction func onClickBtnCancel(_ sender: Any){
        closeDocumentUploadDialog()
    }

    @IBAction func onClickBtnNext(_ sender: Any) {
        if((ProviderSingleton.shared.provider.isDocumentUploaded == FALSE)) {
            self.openLogoutDialog()
        } else {
            if self.revealViewController() != nil {
                if let navigaionVC = self.navigationController {
                    navigaionVC.popViewController(animated: true);
                }
            } else {
                if ProviderSingleton.shared.tripStaus.trip.id.isEmpty {
                    APPDELEGATE.gotoMap()
                } else {
                    APPDELEGATE.gotoTrip()
                }
            }            
        }
    }

    @IBAction func onClickBtnBack(_ sender: Any) {
        self.onClickBtnNext(UIButton() as Any)
    }

    /*Document Dialog image tapped*/
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.openImageDialog()
    }

    //MARK: - USER DEFINE FUNCTION
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        wsGetDocumentList()
    }

    func updateUI(isUpdate: Bool = false) {
        imgEmpty.isHidden = isUpdate
        tblForDocumentList.isHidden = !isUpdate
        lblMandatoryFields.isHidden = !isUpdate
        if (ProviderSingleton.shared.provider.isDocumentUploaded == TRUE) {
            self.btnSubmit.isEnabled = true
            btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        } else {
            self.btnSubmit.isEnabled = false
            btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        }
    }

    //MARK: - WEB SERVICE CALLS
    func wsGetDocumentList() {
        let dictParam: [String:Any] =
            [PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TYPE:String(CONSTANT.TYPE_PROVIDER)]

        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.GET_DOCUMENTS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data,error) -> (Void) in
            Parser.parseDocumentList(response,data: data, toArray: self.arrdocumentList, completion: { [unowned self] (result) in
                if result {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.documentListLength = self.arrdocumentList.count;
                        self.tblForDocumentList.reloadData()
                        self.updateUI(isUpdate:true)
                    }
                } else {
                    self.updateUI(isUpdate:false)
                }
            })
        }
    }

    func wsUploadDocuments(selectedDoc:ProviderDocument) {
        if(checkDocumentValidation()) {
            var dictParam: Dictionary<String,Any> =
                [PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
                 PARAMS.TOKEN:preferenceHelper.getSessionToken(),
                 PARAMS.TYPE:String(CONSTANT.TYPE_PROVIDER),
                 PARAMS.DOCUMENT_ID:selectedDoc.id,
                 ]
            dictParam.updateValue(selectedDoc.uniqueCode, forKey: PARAMS.UNIQUE_CODE);
            dictParam.updateValue(selectedDoc.expiredDate, forKey: PARAMS.EXPIRED_DATE);
            if selectedDocument!.isUniqueCode {
                dictParam.updateValue(selectedDoc.uniqueCode, forKey: PARAMS.UNIQUE_CODE);
            }

            if selectedDocument!.isExpiredDate {
                dictParam.updateValue(selectedDoc.expiredDate, forKey: PARAMS.EXPIRED_DATE);
            }

            Utility.showLoading()
            let alamoFire:AlamofireHelper = AlamofireHelper.init();
            alamoFire.getResponseFromURL(url: WebService.UPLOAD_DOCUMENT, paramData: dictParam, image: imgDocument.image!, block: { (response,data,error) -> (Void) in
                if (Parser.isSuccess(response: response, data: data, withSuccessToast: false, andErrorToast: true)) {
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let documentResponse:UploadDocumentResponse =  try! jsonDecoder.decode(UploadDocumentResponse.self, from: data!)
                    
                    self.selectedDocument?.documentPicture = documentResponse.documentPicture
                    
                    self.selectedDocument?.expiredDate = documentResponse.expiredDate
                    self.selectedDocument?.uniqueCode = documentResponse.uniqueCode
                    
                    self.arrdocumentList.replaceObject(at: self.selectedIndex, with: self.selectedDocument!)
                    
                    DispatchQueue.main.async {
                        self.tblForDocumentList.reloadData()
                        ProviderSingleton.shared.provider.isDocumentUploaded = documentResponse.isDocumentUploaded
                        
                        if (ProviderSingleton.shared.provider.isDocumentUploaded == TRUE) {
                            self.btnSubmit.isEnabled = true
                            self.btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
                        }else {
                            self.btnSubmit.isEnabled = false
                            self.btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
                        }
                        self.closeDocumentUploadDialog()
                        self.isPicAdded = false
                    }
                }
                Utility.hideLoading()
            })
        }
    }
    
    func checkDocumentValidation() -> Bool {
        if ((txtDocId.text?.isEmpty())! && (selectedDocument!.isUniqueCode)) {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        } else if ((txtExpDate.text?.isEmpty())! && (selectedDocument!.isExpiredDate)) {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        } else if !isPicAdded && selectedDocument?.documentPicture.count ?? 0 == 0 {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        } else {
            return true
        }
    }

    func wsLogout() {
        self.view.endEditing(true)
        Utility.showLoading()

        var dictParam : [String : Any] = [:]
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        dictParam[PARAMS.APP_VERSION] = currentAppVersion
        dictParam[PARAMS.PROVIDER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if (error != nil) {
                Utility.hideLoading()
            } else {
                if Parser.parseLogout(response: response,data: data) {
                    APPDELEGATE.gotoLogin()
                } else {
                    Utility.hideLoading()
                }
            }
        }
    }

    //MARK:- Dialogues
    func openDocumentUploadDialog(selectedDoc:ProviderDocument) {
        dialogForDocument.frame = self.view.frame
        dialogForDocument.isHidden = false
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
        txtDocId.placeholder = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = "TXT_ENTER_EXP_DATE".localized
        txtDocId.isHidden = false
        txtExpDate.isHidden = false
        self.stkForDoc.isHidden = false
        lblDocTitle.text = selectedDocument!.name

        if((selectedDocument!.documentPicture.isEmpty())) {
            imgDocument.image = UIImage.init(named: "asset-document-placeholder")
            if (selectedDocument!.isExpiredDate) {
                txtExpDate.text = ""
            } else {
                txtExpDate.isHidden = true
            }

            if (selectedDocument!.isUniqueCode) {
                txtDocId.text = ""
            } else {
                txtDocId.isHidden = true
            }

            if(txtExpDate.isHidden && txtDocId.isHidden) {
                self.stkForDoc.isHidden = true
                //imgDocument.center = dialogForDocument.center
            }
        } else {
            imgDocument.downloadedFrom(link: (selectedDocument?.documentPicture)!, placeHolder: "asset-document-placeholder")
            if (selectedDocument!.isExpiredDate) {
                txtExpDate.text = Utility.stringToString(strDate: selectedDoc.expiredDate, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_FORMAT)
            } else {
                txtExpDate.isHidden = true
            }

            if (selectedDocument!.isUniqueCode) {
                txtDocId.text = selectedDoc.uniqueCode
            } else {
                txtDocId.isHidden = true
            }

            if(txtExpDate.isHidden && txtDocId.isHidden) {
                self.stkForDoc.isHidden = true
            }
        }

        if (selectedDocument!.option == TRUE) {
            lblMandatory.isHidden = false
        } else {
            lblMandatory.isHidden = true
        }
        imgDocument.setRound()
    }

    func closeDocumentUploadDialog() {
        dialogForDocument.isHidden = true
        lblDocTitle.text = ""
        txtDocId.text = ""
        txtExpDate.text = ""
    }

    func openImageDialog() {
        self.view.endEditing(true)
        self.dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage]
            (image:UIImage) in
            self.imgDocument.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperview()
        }
    }

    func openDatePicker() {
        self.view.endEditing(true)
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.setMinDate(mindate: Date())
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] (selectedDate:Date) in
            let currentDate = Utility.dateToString(date: selectedDate, withFormat: DateFormat.DATE_FORMAT)
            self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DateFormat.WEB, isForceEnglish: true)
            self.txtExpDate.text = currentDate
            datePickerDialog.removeFromSuperview()
        }
    }

    func openLogoutDialog() {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
        dialogForLogout.onClickLeftButton = { [unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = { [unowned self, unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
            self.wsLogout()
            preferenceHelper.setBiomatricVerification(false)
        }
    }
}
