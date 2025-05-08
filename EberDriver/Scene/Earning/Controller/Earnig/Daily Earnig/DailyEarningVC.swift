//
//  DailyEarningVC.swift
//  Eber
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class DailyEarningVC: BaseVC {

    @IBOutlet weak var lblTripId: UILabel!
    @IBOutlet weak var lblPaidBy: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblProfit: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblEarn: UILabel!

    //Outlets For Earning
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var scrDailyEarning: UIScrollView!
    @IBOutlet weak var mainViewForEarning: UIView!
    @IBOutlet weak var lblTotalProviderEarning: UILabel!
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var lblPaymentToProvider: UILabel!

    @IBOutlet weak var collectionViewForAnalytic: UICollectionView!
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblEmptyMsg: UILabel!

    var arrForEarning = NSMutableArray()
    var arrForAnalytic = NSMutableArray()
    var arrForOrders = NSMutableArray()
    var strDateOfEarning:String = "";
    var strDateOfEarningForParam:String = "";

    @IBOutlet weak var heightForTblEarning: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionAnalytic: NSLayoutConstraint!
    @IBOutlet weak var heightForTblOrder: NSLayoutConstraint!

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmptyMsg.isHidden = true
        strDateOfEarning = Utility.dateToString(date: Date(), withFormat: DateFormat.EARNING)
        strDateOfEarningForParam = Utility.dateToString(date: Date(), withFormat: DateFormat.EARNING, isForceEnglish: true)
        btnDate.setTitle(Utility.convertDateFormate(date: Date()), for: .normal)
        self.setLocalization()
        self.tblEarning.estimatedRowHeight = 44
        self.tblEarning.rowHeight = UITableView.automaticDimension
        wsGetDailyEarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionViewForAnalytic?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    //MARK: - Set localized layout
    func setLocalization() {
        updateUI(isUpdate: false)
        //LOCALIZED
        self.title = "TXT_EARNING".localized
        lblPaymentToProvider.text = "TXT_STATISTIC".localized
        lblOrders.text = "TXT_TRIP_EARNING".localized
        
        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblEarning.backgroundColor = UIColor.themeViewBackgroundColor
        self.collectionViewForAnalytic.backgroundColor = UIColor.themeViewBackgroundColor
        scrDailyEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        mainViewForEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblOrders.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        btnDate.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        lblPaymentToProvider.textColor = UIColor.themeSelectionColor
        lblOrders.textColor = UIColor.themeTextColor
        lblTotalProviderEarning.textColor = UIColor.themeSelectionColor
        
        /*Set Font*/
        btnDate.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        
        lblPaymentToProvider.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        
        lblTotalProviderEarning.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)

        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblEmptyMsg.text = "TXT_DAILY_EARNING_LIST_EMPTY".localized
        
        lblTripId.textColor = UIColor.themeTextColor
        lblTripId.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblTripId.text = "TXT_TRIP_ID".localized
        
        lblPaidBy.textColor = UIColor.themeTextColor
        lblPaidBy.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblPaidBy.text = "TXT_PAYMENT_BY".localized
        
        lblTotal.textColor = UIColor.themeTextColor
        lblTotal.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblTotal.text = "TXT_TOTAL".localized
        
        lblProfit.textColor = UIColor.themeTextColor
        lblProfit.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblProfit.text = "TXT_PROFIT".localized
        
        lblCash.textColor = UIColor.themeTextColor
        lblCash.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblCash.text = "TXT_CASH".localized
        
        lblWallet.textColor = UIColor.themeTextColor
        lblWallet.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblWallet.text = "TXT_WALLET".localized
        
        lblEarn.textColor = UIColor.themeTextColor
        lblEarn.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblEarn.text = "TXT_EARN".localized
    }

    func setupLayout() {
        collectionViewForAnalytic.layer.borderColor = UIColor.gray.cgColor
        collectionViewForAnalytic.layer.borderWidth = 0.5
    }

    @IBAction func onClickDate(_ sender: UIButton) {
        openDatePicker()
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    //MARK: - Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - User Define Function
    func updateUI(isUpdate: Bool = false) {
        heightForTblEarning.constant = tblEarning.contentSize.height
        heightCollectionAnalytic.constant = 300
        heightForTblOrder.constant = tblOrders.contentSize.height
        imgEmpty.isHidden = isUpdate

        mainViewForEarning.isHidden = !isUpdate
        self.view.layoutIfNeeded()
    }

    //MARK: - wsGetEarning
    func wsGetDailyEarning() {
        Utility.showLoading()

        let dictParam:[String:String] =
            [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.DATE : strDateOfEarningForParam]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_DAILY_EARNING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data,error) -> (Void) in
            Parser.parseEarning(response,data: data, arrayListForEarning: self.arrForEarning, arrayListForAnalytic: self.arrForAnalytic, arrayListForOrders: self.arrForOrders, completetion: { [unowned self] (result) in
                if result {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let dailyEarningResponse:EarningResponse = try jsonDecoder.decode(EarningResponse.self, from: data!)
                        self.lblTotalProviderEarning.text = (dailyEarningResponse.providerDailyEarning?.totalProviderServiceFees.toCurrencyString())!
                        self.collectionViewForAnalytic.reloadData()
                        self.tblEarning.reloadData()
                        self.tblOrders.reloadData()
                        self.updateUI(isUpdate: true)
                    } catch {}
                } else {
                    self.updateUI(isUpdate: false)
                }
            })
            Utility.hideLoading()
        }
    }

    func openDatePicker() {
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMaxDate(maxdate: Date())
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] (selectedDate:Date) in
            self.strDateOfEarning = Utility.dateToString(date: selectedDate, withFormat: DateFormat.DATE_MM_DD_YYYY)
            self.strDateOfEarningForParam = Utility.dateToString(date: selectedDate, withFormat: DateFormat.DATE_MM_DD_YYYY, isForceEnglish: true)
            self.btnDate.setTitle(Utility.convertDateFormate(date: selectedDate), for: .normal)
            self.wsGetDailyEarning()
            datePickerDialog.removeFromSuperview()
        }
    }
}

class EarningSectionCell: TblVwCell {

    @IBOutlet weak var lblSection: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSection.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblSection.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }

    func setData(title: String) {
        lblSection.text = title.uppercased()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class EarningCell: TblVwCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor

        lblTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblPrice.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        lblPrice.textColor = UIColor.themeTextColor
        lblTitle.textColor = UIColor.themeTitleColor
    }

    //MARK: - SET CELL DATA
    func setCellData(cellItem:Earning) {
        lblTitle.text = cellItem.title!
        lblPrice.text = cellItem.price!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DailyEarningVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForAnalytic.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollection
        cell.lblTitle.text = (arrForAnalytic.object(at: indexPath.row) as! Analytic).title!
        cell.lblValu.text = (arrForAnalytic.object(at: indexPath.row) as! Analytic).value!
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.25
        return cell
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {}

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.bounds.size.width) / CGFloat(2))
        return CGSize(width: itemWidth, height: 60)
    }
}

extension DailyEarningVC:UITableViewDelegate,UITableViewDataSource {
    //MARK: - Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblOrders {
            return 1
        } else {
            return self.arrForEarning.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblOrders {
            return arrForOrders.count
        } else {
            return (((arrForEarning.object(at: section)) as! [Earning]).count)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblOrders {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderCell
            let orderPayment:EarningTrip = (arrForOrders .object(at: indexPath.row) as! EarningTrip)
            cell.setCellData(cellItem:orderPayment)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EarningCell
            let earning:Earning = ((arrForEarning .object(at: indexPath.section)) as! [Earning])[indexPath.row]
            cell.setCellData(cellItem:earning)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblOrders {
            if #available(iOS 14.0, *) {
                return 10
            } else {
                return 30
            }
        }
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblOrders {
            return 30
        }
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblOrders {
            return UIView()
        } else {
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! EarningSectionCell
            sectionHeader.setData(title: ((arrForEarning.object(at: section) as! [Earning])[0].sectionTitle!))
            return sectionHeader
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class CustomCollection:CltVwCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValu: UILabel!

    override func awakeFromNib() {
        lblTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblValu.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblTitle.textColor = UIColor.themeLightTextColor
        lblValu.textColor = UIColor.themeTextColor
    }
}

class OrderCell: TblVwCell {
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblPayBy: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblProfit: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblEarn: UILabel!
    @IBOutlet weak var lblDivider: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblDivider.backgroundColor = UIColor.lightGray

        lblOrderNo.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblTotal.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblProfit.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblPaid.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblCash.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblEarn.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)
        lblPayBy.font = FontHelper.font(size: FontSize.tiny, type: FontType.Regular)

        lblOrderNo.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeTextColor
        lblProfit.textColor = UIColor.themeTextColor
        lblPaid.textColor = UIColor.themeTextColor
        lblCash.textColor = UIColor.themeTextColor
        lblEarn.textColor = UIColor.themeTextColor
        lblPayBy.textColor = UIColor.themeTextColor
    }

    //MARK: - SET CELL DATA
    func setCellData(cellItem:EarningTrip) {
        lblOrderNo.text = cellItem.uniqueId.toString()
        lblTotal.text = cellItem.total.toString()
        lblProfit.text = cellItem.providerServiceFees.toString()
        lblPaid.text = cellItem.providerIncomeSetInWallet.toString()
        lblCash.text = cellItem.providerHaveCash.toString()
        lblEarn.text = cellItem.payToProvider.toString()

        if cellItem.paymentMode == 1 {
            lblPayBy.text = "TXT_CASH".localized
        } else {
            lblPayBy.text = "TXT_CARD".localized
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
