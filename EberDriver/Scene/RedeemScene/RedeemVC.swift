//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class RedeemVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewForCreditCards: UIView!
    
    @IBOutlet weak var btnAddRedeem: UIButton!
    
    
    @IBOutlet weak var lblRedeemValue: UILabel!
    @IBOutlet weak var lblRedeemValue2: UILabel!
    
    
    @IBOutlet weak var txtAddRedeem: ACFloatingTextfield!
    @IBOutlet weak var lblRedeemPoints: UILabel!
    @IBOutlet weak var lblValidationMsg: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var walletCurrencyCode:String = ""
    var totalRedeemPoints: Int = 0
    var driverMinimumRedeemPointRequired: Int = 0
    var driverRedeemPointValue: Double = 0.0
    
    var arrForWalletHistory = NSMutableArray()
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }
    func initialViewSetup() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = "TXT_REDEEM".localized
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        lblRedeemPoints.text = "TXT_REDEEM".localized
        lblRedeemPoints.textColor = UIColor.themeTitleColor
        lblRedeemPoints.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        btnAddRedeem.setTitle("TXT_REDEEM".localizedCapitalized, for: .normal)
        btnAddRedeem.setTitle("TXT_SUBMIT".localizedCapitalized, for: .selected)
        btnAddRedeem.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnAddRedeem.setTitleColor(UIColor.themeButtonBackgroundColor, for: .selected)
        btnAddRedeem.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: .Bold)
        print("Redeem Points",preferenceHelper.getTotalRedeemPoints())
        
        self.txtAddRedeem.isHidden = true
        self.txtAddRedeem.placeholder = "TXT_ENTER_POINTS".localized
        
        lblRedeemValue.textColor = UIColor.themeButtonBackgroundColor
        lblRedeemValue.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        
        
        lblRedeemValue2.textColor = UIColor.themeButtonBackgroundColor
        lblRedeemValue2.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        lblRedeemValue2.isHidden = true
        lblRedeemValue2.adjustsFontSizeToFitWidth = true
        
        lblValidationMsg.textColor = UIColor.themeErrorTextColor
        lblValidationMsg.font = FontHelper.font(size: FontSize.small, type: .Regular)
        lblValidationMsg.isHidden = true
        lblValidationMsg.numberOfLines = 0
        
        
        lblNoData.textColor = UIColor.themeTextColor
        lblNoData.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblNoData.isHidden = true
        lblNoData.adjustsFontSizeToFitWidth = true
        lblNoData.numberOfLines = 0
        lblNoData.text = "MSG_REDEEM_DATA_NOT_FOUND".localized
        self.wsGetRedeemHistory()
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }
    
    @IBAction func onClickBtnRedeem(_ sender: UIButton) {
        self.view.endEditing(true)
        if btnAddRedeem.isSelected
        {
            
            
            let enteredRedeemPoints = self.txtAddRedeem.text ?? ""
            if enteredRedeemPoints == "" {
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = "VALIDATION_MSG_VALID_AMOUNT".localized
                
            } else if self.totalRedeemPoints == 0  ||  enteredRedeemPoints.toInt() > self.totalRedeemPoints {
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = "VALIDATION_MSG_INSUFFICIENT_BALANCE".localized
                
            } else if enteredRedeemPoints.toInt() < self.driverMinimumRedeemPointRequired {
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = String(format: "VALIDATION_MSG_POINT_LIMIT".localized,self.driverMinimumRedeemPointRequired.toString())
                
            } else {
                let pointsToValue = (enteredRedeemPoints.toDouble() * self.driverRedeemPointValue)//preferenceHelper.getDriverRedeemPointValue())
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = String(format: "MSG_POINT_TO_VALUE".localized,enteredRedeemPoints,pointsToValue.toString(),preferenceHelper.getWalletCurrencyCode())
                self.txtAddRedeem.isHidden = true
                self.lblRedeemValue.isHidden = false
                self.wsGetWithdrawRedeemPointToWallet()
                
            }
        }
        else {
            self.lblRedeemValue2.isHidden = true
            self.txtAddRedeem.isHidden = false
            self.lblRedeemValue.isHidden = true
            self.lblRedeemValue2.isHidden = false
            btnAddRedeem.isSelected = !btnAddRedeem.isSelected
        }
        
    }
    @IBAction func onClickBtnMenu(_ sender: Any) {
        if btnAddRedeem.isSelected {
            self.txtAddRedeem.isHidden = true
            self.lblRedeemValue.isHidden = false
            self.lblRedeemValue2.isHidden = true
            self.txtAddRedeem.text = ""
            self.btnAddRedeem.isSelected = false
            self.lblValidationMsg.isHidden = true
        }else {
            if let navigationVC: UINavigationController  = self.revealViewController()?.mainViewController as? UINavigationController {
                navigationVC.popToRootViewController(animated: true)
            }
        }
    }
    func setUpLayout()  {
        viewForCreditCards.navigationShadow()
    }
    func wsGetWithdrawRedeemPointToWallet() {
        Utility.showLoading()
        
        
        let dictParam : [String : Any] = [ PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                                           PARAMS.USER_ID: preferenceHelper.getUserId(),
                                           PARAMS.REDEEM_POINT: self.txtAddRedeem.text!.toInt(),
                                           PARAMS.TYPE: CONSTANT.TYPE_PROVIDER];
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.GET_WITHDRAW_REDEEM_POINT_TO_WALLET, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { response, data, error in
            
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response,data: data) {
                self.btnAddRedeem.isSelected = !self.btnAddRedeem.isSelected
                self.tableView.reloadData()
                self.updateUI(isUpdate: true)
                self.txtAddRedeem.isHidden = true
                self.lblRedeemValue.isHidden = false
                self.lblRedeemValue2.isHidden = true
                self.txtAddRedeem.text = ""
                self.btnAddRedeem.isSelected = false
                self.lblValidationMsg.isHidden = true
                self.wsGetRedeemHistory()
                    
                
            }
        }
    }
    func wsGetRedeemHistory() {
        Utility.showLoading()
        let dictParam:[String:String] =
        [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
         PARAMS.USER_ID : preferenceHelper.getUserId(),
         PARAMS.TYPE :CONSTANT.TYPE_PROVIDER.toString()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_REDEEM_POINT_HISTORY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {(response,data,error) -> (Void) in
            if (Parser.isSuccess(response: response,data: data, withSuccessToast: false, andErrorToast: true)) {
                Parser.parseRedeemHistory(response , data: data, toArray: self.arrForWalletHistory, completion: { [unowned self] (result) in
                    if result {
                        self.tableView.reloadData()
                        self.updateUI(isUpdate: true)
                        let jsonDecoder = JSONDecoder()
                        do {
                            let redeemListResponse:RedeemHistoryResponse = try jsonDecoder.decode(RedeemHistoryResponse.self, from: data!)
                            self.totalRedeemPoints = redeemListResponse.total_redeem_point ?? 0
                            self.driverMinimumRedeemPointRequired = redeemListResponse.driver_minimum_point_require_for_withdrawal ?? 0
                            self.driverRedeemPointValue = Double(redeemListResponse.driver_redeem_point_value ?? 0)
                            lblRedeemValue.text = "TXT_POINTS".localized + ": \(totalRedeemPoints)"
                            lblRedeemValue2.text = "\(totalRedeemPoints)"
                            print("VALUES ====>", self.totalRedeemPoints, self.driverMinimumRedeemPointRequired,self.driverRedeemPointValue)
                            if totalRedeemPoints == 0 {
                                self.btnAddRedeem.isHidden  = true
                            } else {
                                self.btnAddRedeem.isHidden  = false
                            }
                        }catch {
                            
                        }
                    }else {
                        self.updateUI(isUpdate: false)
                        self.btnAddRedeem.isHidden  = true
                    }
                    Utility.hideLoading()
                })
            } else {
                self.updateUI(isUpdate: false)
                self.btnAddRedeem.isHidden  = true
            }
        }
    }
    func updateUI(isUpdate: Bool = false) {
        tableView.isHidden = !isUpdate
        lblNoData.isHidden = isUpdate
    }
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForWalletHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletHistoryCell", for: indexPath) as! WalletHistoryCell
        let walletData = (arrForWalletHistory[indexPath.row] as! RedeemHistory)
        cell.setRedeemCell()
        cell.setRedeemHistoryData(redeemRequestData: walletData)
        return cell
    }
}
extension RedeemVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       /* if textField == txtAddRedeem {
            let textFieldString = textField.text! as NSString;
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
        } */
        let previousText:NSString = textField.text! as NSString
        let enteredRedeemPoints =  previousText.replacingCharacters(in: range, with: string)
        
        if (string == "") && enteredRedeemPoints == "" {
            self.lblValidationMsg.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewForCreditCards.navigationShadow(isReload: true)
            }            
            return true
        } else {
            
            if enteredRedeemPoints == "" {
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = "VALIDATION_MSG_VALID_AMOUNT".localized
                self.lblValidationMsg.textColor  = UIColor.themeErrorTextColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewForCreditCards.navigationShadow(isReload: true)
                }
                
                
            } else if self.totalRedeemPoints == 0  ||  enteredRedeemPoints.toInt() > totalRedeemPoints {
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = "VALIDATION_MSG_INSUFFICIENT_BALANCE".localized
                self.lblValidationMsg.textColor  = UIColor.themeErrorTextColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewForCreditCards.navigationShadow(isReload: true)
                }
                
            } else if enteredRedeemPoints.toInt() < self.driverMinimumRedeemPointRequired {
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.text = String(format: "VALIDATION_MSG_POINT_LIMIT".localized,self.driverMinimumRedeemPointRequired.toString())
                self.lblValidationMsg.textColor  = UIColor.themeErrorTextColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewForCreditCards.navigationShadow(isReload: true)
                }
                
            } else {
                let pointsToValue = (enteredRedeemPoints.toDouble() * self.driverRedeemPointValue)// preferenceHelper.getDriverRedeemPointValue())
                self.lblValidationMsg.isHidden = false
                self.lblValidationMsg.textColor  = UIColor.themeWalletAddedColor
                self.lblValidationMsg.text = String(format: "MSG_POINT_TO_VALUE".localized,enteredRedeemPoints,pointsToValue.toString(places: 0),preferenceHelper.getWalletCurrencyCode())
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewForCreditCards.navigationShadow(isReload: true)
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}









