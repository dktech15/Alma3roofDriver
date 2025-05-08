//
//  VehicleDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class VehicleDetailVC: BaseVC {
    
    let downArrow:String = "\u{25BC}"
    /*Navigation View Basic Detail*/
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    
    /*Vehicle Basic Detail*/
    @IBOutlet weak var viewForVehicleDetail: UIView!
    @IBOutlet weak var txtVehicleName: UITextField!
    @IBOutlet weak var txtVehicleModel: UITextField!
    @IBOutlet weak var txtColor: UITextField!
    @IBOutlet weak var txtPlacteNumber: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var btnDropDownYear: UIButton!
    
    /*Vehicle Document Detail*/
    @IBOutlet weak var dialogForDocument: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmitDocument: UIButton!
    
    @IBOutlet weak var stkForDoc: UIStackView!
    @IBOutlet weak var stkForExpDateWithID: UIStackView!
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet weak var lblMandatory: UILabel!
    
    @IBOutlet weak var documentDialog: UIView!
    @IBOutlet weak var viewForDocumentImage: UIView!
    
    @IBOutlet weak var heightForTable: NSLayoutConstraint!
    /*Year picker*/
    @IBOutlet weak var pickYear: UIPickerView!
    @IBOutlet weak var pickerOverview: UIView!
    @IBOutlet weak var dialogForPicker: UIView!
    @IBOutlet weak var lblPickerTitle: UILabel!
    @IBOutlet weak var btnCancelPicker: UIButton!
    @IBOutlet weak var btnSelectPicker: UIButton!
    @IBOutlet weak var lblUploadDocument: UILabel!
    @IBOutlet weak var lblMandatoryFields: UILabel!
    
    @IBOutlet weak var viewForDoc: UIView!
    @IBOutlet weak var tblVehicleDocument: UITableView!
    
    //Accebility View
    @IBOutlet weak var viewForAccessiblity: UIView!
    @IBOutlet weak var lblAccessibility: UILabel!
    @IBOutlet weak var btnHotspot: UIButton!
    @IBOutlet weak var btnHandicap: UIButton!
    @IBOutlet weak var btnBabySeat: UIButton!
    @IBOutlet weak var lblHandicap: UILabel!
    @IBOutlet weak var lblbabySit: UILabel!
    @IBOutlet weak var lblHotSpot: UILabel!

    var selectedYear:String = ""
    var selectedVehicle:VehicleDetail? = nil
    var arrForVehicleDocuments:[ProviderDocument] = []
    var arrForYearPicker:[String] = []

    var selectedDocument:ProviderDocument? = nil
    var selectedIndex = 0;
    var isPicAdded: Bool = false;
    var dialogForImage:CustomPhotoDialog? = nil;

    var maxYear:Int = 0
    var minYear:Int = 0

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPickerTitle.text = "Select registration year".localized
        lblMandatory.isHidden = true
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        maxYear = currentYear
        for i in 0...20 {
            minYear = currentYear - i
            arrForYearPicker.append(String(currentYear - i))
        }
        tblVehicleDocument.separatorStyle = .none

        selectedYear = arrForYearPicker[0]
        setLocalization()

        if (selectedVehicle != nil) {
            setVehicleData()
            enableTextFields(enable: false)
            self.btnEdit.setTitle("TXT_EDIT".localizedCapitalized, for: .normal)
        } else {
            self.btnEdit.setTitle("TXT_DONE".localizedCapitalized, for: .normal)
            enableTextFields(enable: true)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        viewForDocumentImage.isUserInteractionEnabled = true
        viewForDocumentImage.addGestureRecognizer(tapGestureRecognizer)
        if ProviderSingleton.shared.provider.providerType == ProviderType.PARTNER {
            self.btnEdit.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupLayout() {
        pickerOverview.frame = view.bounds
        tblVehicleDocument.tableFooterView = UIView.init()
        tblVehicleDocument.delegate = self
        tblVehicleDocument.dataSource = self
        navigationView.navigationShadow()

        dialogForDocument.frame = view.bounds
        documentDialog.setShadow()
        documentDialog.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)

        btnSelectPicker.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnSelectPicker.frame.height/2, borderWidth: 1.0)
        btnSubmitDocument.setRound(withBorderColor: UIColor.clear, andCornerRadious: btnSubmitDocument.frame.height/2, borderWidth: 1.0)
    }

    func setLocalization() {
        lblTitle.text = "TXT_VEHICLE".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
        
        txtVehicleModel.placeholder = "TXT_VEHICLE_MODEL".localized
        txtVehicleName.placeholder = "TXT_VEHICLE_NAME".localized
        txtColor.placeholder = "TXT_VEHICLE_COLOR".localized
        txtYear.placeholder = "TXT_VEHICLE_REGISTER_YEAR".localized
        txtPlacteNumber.placeholder = "TXT_VEHICLE_PLATE_NUMBER".localized
        
        lblMandatory.text = "*".localized
        lblMandatory.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblMandatory.textColor = UIColor.themeErrorTextColor

        txtVehicleModel.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtVehicleName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtColor.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtYear.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtPlacteNumber.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        txtVehicleModel.textColor = UIColor.themeTextColor
        txtVehicleName.textColor = UIColor.themeTextColor
        txtColor.textColor = UIColor.themeTextColor
        txtYear.textColor = UIColor.themeTextColor
        txtPlacteNumber.textColor = UIColor.themeTextColor
        
        lblUploadDocument.text = "TXT_UPLOAD_ALL_DOCUMENT".localized
        lblUploadDocument.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblUploadDocument.textColor = UIColor.themeTextColor
        
        lblMandatoryFields.text = "TXT_MANDATORY_FIELDS".localized
        
        lblMandatoryFields.textColor = UIColor.themeErrorTextColor;
        lblMandatoryFields.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        pickerOverview.isHidden = true
        tblVehicleDocument.isHidden = true
        
        btnSubmitDocument.setTitle("TXT_SUBMIT".localizedCapitalized, for: UIControl.State.normal)
        btnSubmitDocument.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnSubmitDocument.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        btnSubmitDocument.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSubmitDocument.backgroundColor = UIColor.themeButtonBackgroundColor
        
        btnCancel.setTitle("TXT_CANCEL".localizedCapitalized, for: .normal)
        btnCancel.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnCancel.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        btnCancelPicker.setTitle("TXT_CANCEL".localizedCapitalized, for: .normal)
        btnCancelPicker.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnCancelPicker.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        btnSelectPicker.setTitle("TXT_SELECT".localizedCapitalized, for: .normal)
        
        btnSelectPicker.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnSelectPicker.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        btnSelectPicker.backgroundColor = UIColor.themeButtonBackgroundColor
        
        txtExpDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        txtDocId.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblDocTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        
        view.addSubview(dialogForDocument)
        dialogForDocument.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgDocument.isUserInteractionEnabled = true
        imgDocument.addGestureRecognizer(tapGestureRecognizer)
        
        /*Picker View */
        pickerOverview.backgroundColor = UIColor.themeOverlayColor
        dialogForPicker.backgroundColor = UIColor.themeViewBackgroundColor
        lblPickerTitle.textColor = UIColor.themeTextColor
        lblPickerTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        
        dialogForPicker.setShadow()
        pickYear.reloadAllComponents()
        btnDropDownYear.setTitle(downArrow, for: .normal)
        btnDropDownYear.isEnabled = false
        lblAccessibility.text = "TXT_ACCESSIBILITY".localized
        lblAccessibility.textColor = UIColor.themeTextColor
        lblAccessibility.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        
        btnHotspot.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblHotSpot.text = " " + "TXT_HOTSPOT".localizedCapitalized
        lblHotSpot.textColor = UIColor.themeTextColor
        //        btnHotspot.setTitle(" " + "TXT_HOTSPOT".localizedCapitalized, for: .normal)
        //        btnHotspot.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        /*btnBabySeat.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
         btnBabySeat.setTitle(" " + "TXT_BABY_SEAT".localizedCapitalized, for: .normal)
         btnBabySeat.setTitleColor(UIColor.themeTextColor, for: .normal)*/
        lblbabySit.text = " " + "TXT_BABY_SEAT".localizedCapitalized
        lblbabySit.textColor = UIColor.themeTextColor
        
        /*btnHandicap.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
         btnHandicap.setTitle(" " + "TXT_HANDICAP".localizedCapitalized, for: .normal)
         btnHandicap.setTitleColor(UIColor.themeTextColor, for: .normal)*/
        
        lblHandicap.text = " " + "TXT_HANDICAP".localizedCapitalized
        lblHandicap.textColor = UIColor.themeTextColor
//        btnMenu.setupBackButton()
        imgMenu.tintColor = UIColor.themeImageColor
        
        btnHandicap.setImage(UIImage(named: "asset-checkbox-normal"), for: .normal)
        btnHandicap.setImage(UIImage(named: "asset-checkbox-selected"), for: .selected)
        
        btnBabySeat.setImage(UIImage(named: "asset-checkbox-normal"), for: .normal)
        btnBabySeat.setImage(UIImage(named: "asset-checkbox-selected"), for: .selected)
        
        btnHotspot.setImage(UIImage(named: "asset-checkbox-normal"), for: .normal)
        btnHotspot.setImage(UIImage(named: "asset-checkbox-selected"), for: .selected)
        
//        btnHandicap.setTitle(FontAsset.icon_check_box_normal, for: .normal)
//        btnHandicap.setTitle(FontAsset.icon_check_box_selected, for: .selected)
//        btnHandicap.setSimpleIconButton()
//        btnHandicap.titleLabel?.font = FontHelper.assetFont(size: 25)
//
//        btnBabySeat.setTitle(FontAsset.icon_check_box_normal, for: .normal)
//        btnBabySeat.setTitle(FontAsset.icon_check_box_selected, for: .selected)
//        btnBabySeat.setSimpleIconButton()
//        btnBabySeat.titleLabel?.font = FontHelper.assetFont(size: 25)
//
//        btnHotspot.setTitle(FontAsset.icon_check_box_normal, for: .normal)
//        btnHotspot.setTitle(FontAsset.icon_check_box_selected, for: .selected)
//        btnHotspot.setSimpleIconButton()
//        btnHotspot.titleLabel?.font = FontHelper.assetFont(size: 25)
    }

    //MARK: - Other Methods
    func updateUI(isUpdate: Bool = false) {
        tblVehicleDocument.isHidden = !isUpdate
        viewForDoc.isHidden = !isUpdate
        self.tblVehicleDocument.reloadData()
        if isUpdate {
            heightForTable.constant = tblVehicleDocument.contentSize.height + 10
        }
    }

    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.openImageDialog()
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnHotSpot(_ sender: Any) {
        btnHotspot.isSelected = !btnHotspot.isSelected
    }

    @IBAction func onClickBtnHandicap(_ sender: Any) {
        btnHandicap.isSelected = !btnHandicap.isSelected
    }

    @IBAction func onClickBtnBabySeat(_ sender: Any) {
        btnBabySeat.isSelected = !btnBabySeat.isSelected
    }

    @IBAction func onClickDropDownYear(_ sender: Any) {
        openPickerView()
    }

    @IBAction func onClickBtnSave(_ sender: Any) {
        if txtVehicleModel.isEnabled {
            btnDropDownYear.isEnabled = false
            if (checkValidation()) {
                if (selectedVehicle?.name.isEmpty) ?? true {
                    wsAddVehicleDetail()
                } else {
                    wsUpdateVehicleDetail()
                }
            }
        } else {
            btnDropDownYear.isEnabled = true
            self.enableTextFields(enable: true)
            self.btnEdit.setTitle("TXT_DONE".localizedCapitalized, for: .normal)
        }
    }

    func enableTextFields(enable: Bool) -> Void {
        self.txtVehicleName.isEnabled = enable
        self.txtVehicleModel.isEnabled = enable
        self.txtPlacteNumber.isEnabled = enable
        self.txtColor.isEnabled = enable
        self.txtYear.isEnabled = enable
        self.tblVehicleDocument.allowsSelection = enable
        btnBabySeat.isUserInteractionEnabled = enable
        btnHotspot.isUserInteractionEnabled = enable
        btnHandicap.isUserInteractionEnabled = enable
    }

    @IBAction func onClickBtnSubmit(_ sender: Any) {
        selectedDocument?.uniqueCode = txtDocId.text ?? ""
        wsUploadDocuments(selectedDoc:selectedDocument!)
    }

    @IBAction func onClickBtnCancel(_ sender: Any) {
        closeDocumentUploadDialog()
    }

    //MARK: - User Define Methods
    func checkValidation() -> Bool {
        if ((txtVehicleModel.text?.isEmpty())! ||
            (txtColor.text?.isEmpty())! ||
            (txtPlacteNumber.text?.isEmpty())! ||
            (txtVehicleName.text?.isEmpty())! ||
            (txtYear.text?.isEmpty())! || (txtYear.text!.toInt() > maxYear || txtYear.text!.toInt() < minYear)) {
            if ((txtVehicleName.text?.isEmpty()) ?? true) {
                Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_VEHICLE_NAME".localized)
                txtVehicleName.becomeFirstResponder();
            } else if ((txtVehicleModel.text?.isEmpty()) ?? true) {
                Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_VEHICLE_MODEL".localized)
                txtVehicleModel.becomeFirstResponder();
            } else if ((txtPlacteNumber.text?.isEmpty()) ?? true) {
                Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_VEHICLE_PLATE_NUMBER".localized)
                txtPlacteNumber.becomeFirstResponder()
            } else if ((txtColor.text?.isEmpty()) ?? true) {
                Utility.showToast(message: "VALIDATION_MSG_PLEASE_ENTER_VEHICLE_COLOR".localized)
                txtColor.becomeFirstResponder()
            } else if ((txtYear.text?.isEmpty()) ?? true) {
                txtYear.becomeFirstResponder();
                Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_VEHICLE_YEAR".localized)
            } else if (txtYear.text!.toInt() > maxYear || txtYear.text!.toInt() < minYear) {
                txtYear.becomeFirstResponder();
                Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_VEHICLE_YEAR".localized)
            }
            return false;
        } else {
            return true
        }
    }

    //MARK: - Web Service Call
    func checkDocumentValidation() -> Bool{
        if ((txtDocId.text?.isEmpty())! && (selectedDocument!.isUniqueCode)) {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        } else if ((txtExpDate.text?.isEmpty())! && (selectedDocument!.isExpiredDate)) {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        } else if !isPicAdded {
            Utility.showToast(message:"VALIDATION_MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        } else {
            return true
        }
    }

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
            isPicAdded = false
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
                self.stkForExpDateWithID.isHidden = true
                imgDocument.center = dialogForDocument.center
            } else {
                self.stkForExpDateWithID.isHidden = false
            }
        } else {
            imgDocument.downloadedFrom(link: (selectedDocument?.documentPicture)!, placeHolder: "asset-document-placeholder")
            isPicAdded = true
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
                self.stkForExpDateWithID.isHidden = true
            } else {
                self.stkForExpDateWithID.isHidden = false
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
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
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
            self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DateFormat.WEB)
            self.txtExpDate.text = currentDate
            datePickerDialog.removeFromSuperview()
        }
    }

    func setVehicleData() {
        self.txtVehicleModel.text = selectedVehicle?.model
        self.txtVehicleName.text = selectedVehicle?.name
        self.txtColor.text = selectedVehicle?.color
        self.txtPlacteNumber.text = selectedVehicle?.plateNo
        self.txtYear.text = selectedVehicle?.passingYear
        wsGetDocumentList()
    }

    @IBAction func onClickBtnCancelPicker(_ sender: Any) {
        closePickerView()
    }

    @IBAction func onClickBtnSelectPicker(_ sender: Any) {
        self.txtYear.text = selectedYear
        closePickerView()
    }
}

extension VehicleDetailVC:UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            closePickerView()
            openDatePicker()
            return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }

    func closePickerView() {
        pickerOverview.isHidden = true
    }

    func openPickerView() {
        self.view.endEditing(true)
        pickerOverview.isHidden = false
    }
}

extension VehicleDetailVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForVehicleDocuments.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:DocumentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DocumentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentdocument:ProviderDocument = arrForVehicleDocuments[indexPath.row]
        cell.setCellData(cellItem: currentdocument)
        return cell;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedDocument = arrForVehicleDocuments[indexPath.row]
        selectedIndex = indexPath.row
        self.openDocumentUploadDialog(selectedDoc:selectedDocument!)
    }
}

extension VehicleDetailVC:UIPickerViewDelegate,UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrForYearPicker.count
    }

    // Delegate
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrForYearPicker[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = arrForYearPicker[row]
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }else { label = UILabel() }
        label.textColor = UIColor.themeTextColor
        label.textAlignment = .center
        label.font = FontHelper.font(size: FontSize.small, type: .Regular)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = arrForYearPicker[row]
        return label
    }
}

//MARK: - Web Service Calls
extension VehicleDetailVC {

    func wsAddVehicleDetail() {
        Utility.showLoading()
        var arrForAccessiblity:[String] = []

        if btnHandicap.isSelected {
            arrForAccessiblity.append(VehicleAccessibity.HANDICAP)
        }
        if btnHotspot.isSelected {
            arrForAccessiblity.append(VehicleAccessibity.HOTSPOT)
        }
        if btnBabySeat.isSelected {
            arrForAccessiblity.append(VehicleAccessibity.BABY_SEAT)
        }
        
        let dictParam : [String : Any] = [
            PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
            PARAMS.TOKEN: preferenceHelper.getSessionToken(),
            PARAMS.VEHICLE_YEAR: txtYear.text ?? "",
            PARAMS.VEHICLE_NAME: txtVehicleName.text ?? "",
            PARAMS.VEHICLE_PLATE_NO: txtPlacteNumber.text ?? "",
            PARAMS.VEHICLE_COLOR: txtColor.text ?? "",
            PARAMS.VEHICLE_MODEL: txtVehicleModel.text ?? "",
            PARAMS.VEHICLE_ACCESSIBILITY : arrForAccessiblity
        ]
        
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_ADD_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data, error) -> (Void) in
            
            self.arrForVehicleDocuments.removeAll()
            
            if Parser.isSuccess(response: response,data: data) {
                let jsonDecoder = JSONDecoder()
                do {
                    let vehicleDetailResponse = try jsonDecoder.decode(VehicleDetailResponse.self, from: data!)
                    self.selectedVehicle = vehicleDetailResponse.vehicleDetail
                    for document in vehicleDetailResponse.documentList {
                        self.arrForVehicleDocuments.append(document)
                    }
                    
                    for accessibility in (self.selectedVehicle?.accessibility) ?? [] {
                        
                        if VehicleAccessibity.BABY_SEAT == accessibility {
                            self.btnBabySeat.isSelected = true
                        }
                        if VehicleAccessibity.HANDICAP == accessibility {
                            self.btnHandicap.isSelected = true
                        }
                        if VehicleAccessibity.HOTSPOT == accessibility {
                            self.btnHotspot.isSelected = true
                        }
                    }
                }catch {
                    print("data may be wrong")
                }
                self.updateUI(isUpdate:!self.arrForVehicleDocuments.isEmpty )
            }
            Utility.hideLoading()
        }
    }
    
    func wsUpdateVehicleDetail(){
        var arrForAccessiblity:[String] = []
        
        if btnHandicap.isSelected {
            arrForAccessiblity.append(VehicleAccessibity.HANDICAP)
        }
        if btnHotspot.isSelected {
            arrForAccessiblity.append(VehicleAccessibity.HOTSPOT)
        }
        if btnBabySeat.isSelected {
            arrForAccessiblity.append(VehicleAccessibity.BABY_SEAT)
        }
        let dictParam : [String : Any] = [PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
                                          PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                                          PARAMS.VEHICLE_ID : self.selectedVehicle?.id ?? "",
                                          PARAMS.VEHICLE_YEAR: txtYear.text ?? "",
                                          PARAMS.VEHICLE_NAME: txtVehicleName.text ?? "",
                                          PARAMS.VEHICLE_PLATE_NO: txtPlacteNumber.text ?? "",
                                          PARAMS.VEHICLE_COLOR: txtColor.text ?? "",
                                          PARAMS.VEHICLE_MODEL: txtVehicleModel.text ?? "",
                                          PARAMS.VEHICLE_ACCESSIBILITY : arrForAccessiblity]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.PROVIDER_UPDATE_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data, error) -> (Void) in
            
            if Parser.isSuccess(response: response,data: data) {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func wsGetDocumentList(){
        let dictParam: [String:Any] =
            [PARAMS.VEHICLE_ID:selectedVehicle?.id ?? "",
             PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
             PARAMS.TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.TYPE:CONSTANT.TYPE_PROVIDER]
        Utility.showLoading()
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.PROVIDER_GET_VEHICLE_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data, error) -> (Void) in
            
            self.arrForVehicleDocuments.removeAll()
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data) {
                let jsonDecoder = JSONDecoder()
                do {
                    let vehicleDetailResponse = try jsonDecoder.decode(VehicleDetailResponse.self, from: data!)
                    self.selectedVehicle = vehicleDetailResponse.vehicleDetail
                    for document in vehicleDetailResponse.documentList {
                        self.arrForVehicleDocuments.append(document)
                    }
                    
                    for accessibility in (self.selectedVehicle?.accessibility) ?? [] {
                        if VehicleAccessibity.BABY_SEAT == accessibility {
                            self.btnBabySeat.isSelected = true
                        }
                        if VehicleAccessibity.HANDICAP == accessibility {
                            self.btnHandicap.isSelected = true
                        }
                        if VehicleAccessibity.HOTSPOT == accessibility {
                            self.btnHotspot.isSelected = true
                        }
                    }
                }catch {
                    print("data may be wrong")
                }
                self.updateUI(isUpdate:!self.arrForVehicleDocuments.isEmpty )
            }
            
        }
    }
    
    func wsUploadDocuments(selectedDoc:ProviderDocument){
        
        if(checkDocumentValidation()) {
            var dictParam: [String:Any] =
                [PARAMS.VEHICLE_ID:self.selectedVehicle?.id ?? "",
                 PARAMS.TOKEN:preferenceHelper.getSessionToken(),
                 PARAMS.TYPE:CONSTANT.TYPE_PROVIDER.toString(),
                 PARAMS.DOCUMENT_ID:selectedDoc.id,
                 PARAMS.PROVIDER_ID:preferenceHelper.getUserId()
            ]
            
            dictParam.updateValue(selectedDoc.uniqueCode, forKey: PARAMS.UNIQUE_CODE);
            dictParam.updateValue(selectedDoc.expiredDate, forKey: PARAMS.EXPIRED_DATE);
            if selectedDocument!.isUniqueCode {
                dictParam.updateValue(selectedDoc.uniqueCode, forKey: PARAMS.UNIQUE_CODE);
                
            }
            if selectedDocument!.isExpiredDate {
                dictParam.updateValue(selectedDoc.expiredDate, forKey: PARAMS.EXPIRED_DATE);
            }
            print(dictParam)
            
            Utility.showLoading()
            let alamoFire:AlamofireHelper = AlamofireHelper.init();
            alamoFire.getResponseFromURL(url: WebService.PROVIDER_UPLOAD_VEHICLE_DOCUMENT, paramData: dictParam, image: imgDocument.image!, block: { (response,data, error) -> (Void) in
                
                if Parser.isSuccess(response: response,data: data) {
                    
                    let jsonDecoder = JSONDecoder()
                    do {
                        let documentRespons:UploadVehicleDocumentResponse = try jsonDecoder.decode(UploadVehicleDocumentResponse.self, from: data!)
                        self.arrForVehicleDocuments[self.selectedIndex] = documentRespons.documentDetail!
                        
                    }catch {
                        print("Wrong Response")
                        
                    }
                    self.tblVehicleDocument.reloadData()
                    self.closeDocumentUploadDialog()
                }
                Utility.hideLoading()
            })
        }
    }
}
