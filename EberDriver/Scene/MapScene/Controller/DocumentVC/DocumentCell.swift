//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DocumentCell: TblVwCell {

    //MARK:- OUTLET
    @IBOutlet weak var stkDocID: UIStackView!
    @IBOutlet weak var stkExpDate: UIStackView!
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var lblIDNumber: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblIDNumberValue: UILabel!
    @IBOutlet weak var lblExpDateValue: UILabel!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblMandatory: UILabel!
    @IBOutlet weak var bgView: UIView!

    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()

        //LOCALIZED
        lblMandatory.text = "*"
        lblMandatory.textColor = UIColor.themeErrorTextColor
        lblMandatory.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblIDNumber.text = "TXT_ID_NUMBER".localized
        lblExpDate.text = "TXT_EXP_DATE".localized
        bgView.setRound(withBorderColor: UIColor.white, andCornerRadious: 3)
        bgView.setShadow()

        //COLORS
        lblDocumentName.textColor = UIColor.themeTextColor
        lblIDNumberValue.textColor = UIColor.themeTextColor
        lblExpDateValue.textColor = UIColor.themeTextColor
        lblIDNumber.textColor = UIColor.themeLightTextColor
        lblExpDate.textColor = UIColor.themeLightTextColor

        //Font
        lblDocumentName.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblIDNumberValue.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblExpDateValue.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblIDNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblExpDate.font = FontHelper.font(size: FontSize.regular, type: .Regular)

        //Make View Hidden
        stkDocID.isHidden = true
        lblIDNumber .isHidden = true
        lblIDNumberValue.isHidden = true
        stkExpDate.isHidden = true
        lblExpDateValue.isHidden = true
        lblExpDate.isHidden = true
    }

    //MARK:- SET CELL DATA
    func setCellData(cellItem:ProviderDocument) {
        imgDocument.setRound()
        imgDocument.isHidden = false
        lblDocumentName.text = cellItem.name
        
        imgDocument.image = UIImage.init(named: "asset-document-placeholder")

        if((cellItem.documentPicture.isEmpty())) {
            if (cellItem.isExpiredDate) {
                lblExpDateValue.text = ""
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
            } else {
                stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }

            if (cellItem.isUniqueCode) {
                lblIDNumberValue.text = ""
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            } else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
            }
        } else {
            imgDocument.downloadedFrom(link: cellItem.documentPicture, placeHolder: "asset-document-placeholder")
            if (cellItem.isExpiredDate) {
                lblExpDateValue.text = ""
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.init(identifier: preferenceHelper.getLanguageCode())
                dateFormatter.dateFormat = DateFormat.WEB
                if let currentDate = dateFormatter.date(from: cellItem.expiredDate) {
                    dateFormatter.dateFormat = DateFormat.DATE_FORMAT
                    lblExpDateValue.text = dateFormatter.string(from: currentDate)
                }
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
            } else {
                stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }

            if (cellItem.isUniqueCode) {
                lblIDNumberValue.text = cellItem.uniqueCode
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            } else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
            }
        }

        if (cellItem.option == TRUE) {
            lblMandatory.isHidden = false
        } else {
            lblMandatory.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
