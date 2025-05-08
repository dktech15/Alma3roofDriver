//
//  HistoryInvoiceVC.swift
//  Edelivery
//   Created by Ellumination 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryInvoiceVC: BaseVC {
    
    /*Header View*/
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPaymentIcon: UILabel!
    @IBOutlet weak var imgPaymentIcon: UIImageView!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblDistance: UILabel!

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!

    @IBOutlet weak var viewForiInvoiceDialog: UIView!
    @IBOutlet weak var lblTripId: UILabel!

    @IBOutlet weak var tblForInvoice: UITableView!
    var arrForInvoice:[[Invoice]]  = []
    var historyInvoiceResponse:HistoryDetailResponse = HistoryDetailResponse.init()
    @IBOutlet weak var lblIconDestination: UILabel!
    @IBOutlet weak var imgIconDestination: UIImageView!
    @IBOutlet weak var lblIconEta: UILabel!
    @IBOutlet weak var imgIconEta: UIImageView!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
        setupInvoice()
    }

    func initialViewSetup() {
        lblTotalTime.text = ""
        lblTotalTime.textColor = UIColor.themeTextColor
        lblTotalTime.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblDistance.text = ""
        lblDistance.textColor = UIColor.themeTextColor
        lblDistance.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblPaymentMode.text = ""
        lblPaymentMode.textColor = UIColor.themeTextColor
        lblPaymentMode.font = FontHelper.font(size: FontSize.small, type: FontType.Bold)
        
        lblTotal.text = "TXT_TOTAL".localized
        lblTotal.textColor = UIColor.themeLightTextColor
        lblTotal.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        lblTotalValue.text = ""
        lblTotalValue.textColor = UIColor.themeSelectionColor
        lblTotalValue.font = FontHelper.font(size: FontSize.doubleExtraLarge, type: FontType.Bold)
        
        lblTripId.text = ""
        lblTripId.textColor = UIColor.themeLightTextColor
        lblTripId.font = FontHelper.font(size: FontSize.regular, type: FontType.Light)
        
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.viewForiInvoiceDialog.setShadow()
        self.viewForiInvoiceDialog.setRound(withBorderColor: UIColor.clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.dismissMe))
        self.view.addGestureRecognizer(tapGesture)
        
//        lblIconDestination.text = FontAsset.icon_distance
//        lblIconDestination.setForIcon()
//        lblIconEta.text = FontAsset.icon_time
//        lblIconEta.setForIcon()
//        lblPaymentIcon.text = FontAsset.icon_payment_card
//        lblPaymentIcon.setForIcon()
        imgIconEta.tintColor = UIColor.themeImageColor
        imgPaymentIcon.image = UIImage(named: "asset-card")
        
    }

    func setupInvoice() {
        let tripDetail:InvoiceTrip = historyInvoiceResponse.trip
        lblTripId.text = tripDetail.invoiceNumber
        lblTotalValue.text = tripDetail.total.toCurrencyString()
        if tripDetail.paymentMode == PaymentMode.CASH {
            imgPayment.image = UIImage.init(named: "asset-cash")
//            lblPaymentIcon.text = FontAsset.icon_payment_cash
            imgPaymentIcon.image = UIImage(named: "asset-cash")
            lblPaymentMode.text = "TXT_PAID_BY_CASH".localized
        } else if tripDetail.paymentMode == PaymentMode.CARD {
            imgPayment.image = UIImage.init(named: "asset-card")
//            lblPaymentIcon.text = FontAsset.icon_payment_card
            imgPaymentIcon.image = UIImage(named: "asset-card")
            lblPaymentMode.text = "TXT_PAID_BY_CARD".localized
        } else {
            imgPayment.image = UIImage.init(named: "asset-apple-pay")
//            lblPaymentIcon.text = FontAsset.icon_payment_card
            imgPaymentIcon.image = UIImage(named: "asset-card")
            lblPaymentMode.text = "TXT_PAID_BY_APPLE_PAY".localized
        }

        lblDistance.text = tripDetail.totalDistance.toString(places: 2) + Utility.getDistanceUnit(unit: tripDetail.unit)
        self.lblTotalTime.text = String(format:"%.2f%@", tripDetail.totalTime, MeasureUnit.MINUTES)

        if Parser.parseInvoice(tripService: historyInvoiceResponse.tripservice, tripDetail: historyInvoiceResponse.trip, arrForInvocie: &arrForInvoice) {
            tblForInvoice.reloadData()
        }
    }

    @objc func dismissMe() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HistoryInvoiceVC :UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForInvoice[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryInvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryInvoiceCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice[indexPath.section][indexPath.row]
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! HistoryInvoiceSection
        sectionHeader.setData(title: arrForInvoice[section][0].sectionTitle)
        return sectionHeader
    }
}

class HistoryInvoiceCell:TblVwCell {

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
        lblSubTitle.baselineAdjustment = .alignCenters

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

class HistoryInvoiceSection:TblVwCell {

    @IBOutlet weak var lblSection: UILabel!

    override func awakeFromNib() {
        lblSection.textColor = UIColor.themeSelectionColor
        lblSection.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
    }

    func setData(title: String) {
        lblSection.text =  title
    }
}
