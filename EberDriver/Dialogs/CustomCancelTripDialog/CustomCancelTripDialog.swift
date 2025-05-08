//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//



import Foundation
import UIKit

public class CustomCancelTripDialog: CustomDialog, UITextFieldDelegate
{
   //MARK:- OUTLETS
 
    @IBOutlet weak var lblCancellationCharge: UILabel!
    @IBOutlet weak var rbCancelReasonOne: UIButton!
    @IBOutlet weak var rbCancelReasonTwo: UIButton!
    @IBOutlet weak var rbCancelReasonThree: UIButton!
    @IBOutlet weak var rbCancelReasonOther: UIButton!

    
    @IBOutlet var lblCancelReasonOne: UILabel!
    @IBOutlet var lblCancelReasonTwo: UILabel!
    @IBOutlet var lblCancelReasonOther: UILabel!
    @IBOutlet weak var lblCancelReasonThree: UILabel!
    
    @IBOutlet weak var scrDialog: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCancellationReason: ACFloatingTextfield!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblCancellationChargeMessage: UILabel!
    
    @IBOutlet weak var tblReason: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!


  //MARK:Variables
    var onClickRightButton : ((_ cancelReason:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  cancelDialog = "dialogForCancelTrip"
    var strCancelationReason:String = "";
    
    var arrReason = [String]() {
        didSet {
            arrReason.append("TXT_OTHER".localized)
            setUpTableView()
            tblReason.reloadData()
            setReasonAt(index: 0)
        }
    }
    var selectedIndex = 0

    public static func  showCustomCancelTripDialog
        (title:String,
         message:String,
         cancelationCharge:String,
         titleLeftButton:String,
         titleRightButton:String) ->
        CustomCancelTripDialog
     {
        let view = UINib(nibName: cancelDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCancelTripDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.capitalized, for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
      
        view.lblCancellationChargeMessage.isHidden = true
        view.lblCancellationCharge.isHidden = true
      
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }

    //MARK:- Set Localization
    func setLocalization() {
        lblTitle.textColor = UIColor.themeTextColor
        lblCancellationChargeMessage.text = "TXT_CANCELLATION_CHARGE_APPLY".localized
        lblCancellationCharge.text = ""
        lblCancellationCharge.isHidden = true
        lblCancellationChargeMessage.isHidden = true
        txtCancellationReason.placeholder = "TXT_CANCEL_TRIP_REASON".localized
        txtCancellationReason.delegate = self
        rbCancelReasonOne.isSelected = true;
        txtCancellationReason.isHidden = true;
        txtCancellationReason.textColor  = UIColor.themeTextColor

        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setupButton()
        lblCancellationCharge.textColor = UIColor.themeTextColor
        lblCancellationChargeMessage.textColor = UIColor.themeTextColor

        rbCancelReasonOne.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        rbCancelReasonTwo.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        rbCancelReasonOther.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        rbCancelReasonThree.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)

        rbCancelReasonOne.setTitleColor(UIColor.themeTextColor, for: UIControl.State.selected)
        rbCancelReasonTwo.setTitleColor(UIColor.themeTextColor, for: UIControl.State.selected)
        rbCancelReasonOther.setTitleColor(UIColor.themeTextColor, for: UIControl.State.selected)
        rbCancelReasonThree.setTitleColor(UIColor.themeTextColor, for: UIControl.State.selected)

        lblCancelReasonOne.textColor = UIColor.themeTextColor
        lblCancelReasonOne.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblCancelReasonOne.text = "TXT_CANCEL_TRIP_REASON1".localized
        strCancelationReason = lblCancelReasonOne.text!//rbCancelReasonOne.title(for: UIControl.State.normal)!

        lblCancelReasonTwo.textColor = UIColor.themeTextColor
        lblCancelReasonTwo.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblCancelReasonTwo.text = "TXT_CANCEL_TRIP_REASON2".localized

        lblCancelReasonThree.textColor = UIColor.themeTextColor
        lblCancelReasonThree.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblCancelReasonThree.text = "TXT_CANCEL_TRIP_REASON3".localized

        lblCancelReasonOther.textColor = UIColor.themeTextColor
        lblCancelReasonOther.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblCancelReasonOther.text = "TXT_OTHER".localized

//        rbCancelReasonOne.setTitle(FontAsset.icon_radio_box_normal, for: UIControl.State.normal)
//        rbCancelReasonTwo.setTitle(FontAsset.icon_radio_box_normal, for: UIControl.State.normal)
//        rbCancelReasonOther.setTitle(FontAsset.icon_radio_box_normal, for: UIControl.State.normal)
//        rbCancelReasonThree.setTitle(FontAsset.icon_radio_box_normal, for: UIControl.State.normal)
//
//        rbCancelReasonOne.setTitle(FontAsset.icon_radio_box_selected, for: UIControl.State.selected)
//        rbCancelReasonTwo.setTitle(FontAsset.icon_radio_box_selected , for: UIControl.State.selected)
//        rbCancelReasonOther.setTitle(FontAsset.icon_radio_box_selected, for: UIControl.State.selected)
//        rbCancelReasonThree.setTitle(FontAsset.icon_radio_box_selected, for: UIControl.State.selected)
        
        rbCancelReasonOne.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        rbCancelReasonTwo.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        rbCancelReasonThree.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        rbCancelReasonOther.setImage(UIImage(named: "asset-radio-normal"), for: .normal)
        
        rbCancelReasonOne.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
        rbCancelReasonTwo.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
        rbCancelReasonThree.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
        rbCancelReasonOther.setImage(UIImage(named: "asset-radio-selected"), for: .selected)
        
        /* Set Font */
//        rbCancelReasonOne.setSimpleIconButton(color: UIColor.themeTextColor)
//        rbCancelReasonTwo.setSimpleIconButton(color: UIColor.themeTextColor)
//        rbCancelReasonOther.setSimpleIconButton(color: UIColor.themeTextColor)
//        rbCancelReasonThree.setSimpleIconButton(color: UIColor.themeTextColor)
//        
//        rbCancelReasonOne.titleLabel?.font = FontHelper.assetFont(size: 25)
//        rbCancelReasonTwo.titleLabel?.font = FontHelper.assetFont(size: 25)
//        rbCancelReasonOther.titleLabel?.font = FontHelper.assetFont(size: 25)
//        rbCancelReasonThree.titleLabel?.font = FontHelper.assetFont(size: 25)

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 30.0, borderWidth: 1.0)
        
        setUpTableView()
    }
    
    func setUpTableView() {
        tblReason.delegate = self
        tblReason.dataSource = self
        tblReason.separatorColor = .clear
        tblReason.register(UINib(nibName: "ReasonCell", bundle: nil), forCellReuseIdentifier: "ReasonCell")
        tblReason.addObserver(self, forKeyPath: "contentSize", options: .new ,context: nil)
    }

    func setCancellationCharge(cancellationCharge:Double){
        lblCancellationCharge.isHidden = false
        lblCancellationChargeMessage.isHidden = false
        lblCancellationCharge.text = cancellationCharge.toString(places: 2)
    }

    //MARK:- TextField Delegate Methods
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtCancellationReason
        {
            textField.resignFirstResponder()
        }
        return true
    }

    //MARK:- ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any){
        if self.onClickLeftButton != nil
        {
            self.onClickLeftButton!();
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any)
    {
        if selectedIndex == arrReason.count - 1 {
            if txtCancellationReason.text!.isEmpty {
                txtCancellationReason.showErrorWithText(errorText: "VALIDATION_MSG_INVALID_REASON".localized)
            } else {
                strCancelationReason = txtCancellationReason.text!
                self.onClickRightButton!(strCancelationReason);
            }
        } else {
            strCancelationReason = arrReason[selectedIndex]
            self.onClickRightButton!(strCancelationReason);
        }
    }

    @IBAction func onClickRadioButton(_ sender: UIButton) {
        rbCancelReasonOne.isSelected = false
        rbCancelReasonTwo.isSelected = false
        rbCancelReasonOther.isSelected = false
        rbCancelReasonThree.isSelected = false
        sender.isSelected = true
        if  (sender.tag == rbCancelReasonOne.tag)
        {
            txtCancellationReason.isHidden = true;
            strCancelationReason = lblCancelReasonOne.text!
        }
        else if (sender.tag == rbCancelReasonTwo.tag)
        {
            txtCancellationReason.isHidden = true;
            strCancelationReason = lblCancelReasonTwo.text!
        }
        else if (sender.tag == rbCancelReasonThree.tag)
        {
            txtCancellationReason.isHidden = true;
            strCancelationReason = lblCancelReasonThree.text!
        }
        else
        {
            txtCancellationReason.isHidden = false;
            strCancelationReason = txtCancellationReason.text ?? ""
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblHeight.constant = tblReason.contentSize.height
    }
        
}

extension CustomCancelTripDialog: UITableViewDelegate, UITableViewDataSource, ReasonCellDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReason.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonCell", for: indexPath) as! ReasonCell
        let obj = arrReason[indexPath.row]
        cell.delegate = self
        if selectedIndex == indexPath.row {
            cell.imgReason.image = UIImage(named: "asset-radio-selected")
        } else {
            cell.imgReason.image = UIImage(named: "asset-radio-normal")
        }
        cell.lblName.text = obj
        cell.selectionStyle = .none
        return cell
    }
    
    func onClickButton(cell: ReasonCell, sender: UIButton) {
        if let index = tblReason.indexPath(for: cell) {
            setReasonAt(index: index.row)
        }
     }
    
    func setReasonAt(index: Int) {
        if index == arrReason.count - 1 {
            txtCancellationReason.isHidden = false
        } else {
            txtCancellationReason.isHidden = true
        }
        selectedIndex = index
        tblReason.reloadData()
    }
}

