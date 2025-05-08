//
//  CallDialog.swift
//  EberDriver
//
//  Created by Rohit on 09/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class CallDialog: UIView {
    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblFirstNumber : UILabel!
    @IBOutlet weak var lblSecondNumber : UILabel!
    @IBOutlet weak var lblFirstName : UILabel!
    @IBOutlet weak var lblSecondName : UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    var onClickRightButton : ((_ dialog:CallDialog ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var onClickCall : ((_ number : String,_ index : Int) -> Void)? = nil
    
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func removeFromSuperview() {
//        for obj in tblTrips.visibleCells {
//            if let cell = obj as? BidTrips {
//                cell.stopTimer()
//            }
//        }
        super.removeFromSuperview()
    }
    
    static func showDialog(firstName : String,firstNumber : String, secondName : String,secondNumber : String) -> CallDialog {

        let view = UINib(nibName: "CallDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CallDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.setLocalization()
        view.lblFirstName.text = firstName
        view.lblFirstNumber.text = firstNumber
        view.lblSecondNumber.text = secondNumber
        view.lblSecondName.text = secondName
//        view.setTableView()
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }
    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        lblTitle.text = "txt_call".localized
        
        btnCancel.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnCancel.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnCancel.setTitle("TXT_CLOSE".localized, for: UIControl.State.normal)
        
        lblFirstName.textColor = UIColor.themeTextColor
        lblSecondName.textColor = UIColor.themeTextColor

        lblFirstNumber.textColor = UIColor.themeLightTextColor
        lblSecondNumber.textColor = UIColor.themeLightTextColor
        
    }

    @IBAction func actionCancel (_ senser : UIButton){
        self.onClickLeftButton!()
    }
    @IBAction func actionFirstCall (_ senser : UIButton){
        self.onClickCall!(self.lblFirstNumber.text!, 1)
        
    }
    @IBAction func actionSecondCall (_ senser : UIButton){
        self.onClickCall!(self.lblSecondNumber.text!, 2)
    }
}
