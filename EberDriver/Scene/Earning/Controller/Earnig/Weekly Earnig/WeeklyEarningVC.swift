//
//  DailyEarningVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import Charts

class WeeklyEarningVC: BaseVC,ChartViewDelegate {

    //Outlets For Earning
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var scrMonthlyEarning: UIScrollView!
    @IBOutlet weak var mainViewForEarning: UIView!
    @IBOutlet weak var lblTotalProviderEarning: UILabel!
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var lblPaymentToProvider: UILabel!
    @IBOutlet weak var lblProviderEarning: UILabel!
    @IBOutlet weak var collectionViewForAnalytic: UICollectionView!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblEmptyMsg: UILabel!

    var arrForEarning = NSMutableArray()
    var arrForAnalytic = NSMutableArray()
    var arrForOrders = NSMutableArray()
    var strStartDateOfEarning:String = "";
    var strEndDateOfEarning:String = "";
    
    var strStartDateOfEarningForParam:String = "";

    @IBOutlet weak var heightForTblEarning: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionAnalytic: NSLayoutConstraint!
    @IBOutlet weak var heightForTblOrder: NSLayoutConstraint!
    @IBOutlet weak var barChartView: BarChartView!

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmptyMsg.isHidden = true
        strEndDateOfEarning = Utility.dateToString(date: Date(), withFormat: DateFormat.DATE_MM_DD_YYYY)

        self.setLocalization()

        self.strStartDateOfEarning = Utility.dateToString(date: self.startOfWeek(), withFormat: DateFormat.EARNING)
        self.strStartDateOfEarningForParam = Utility.dateToString(date: self.startOfWeek(), withFormat: DateFormat.EARNING, isForceEnglish: true)
        
        self.strEndDateOfEarning = Utility.dateToString(date: self.endOfWeek(), withFormat: DateFormat.EARNING)

        setDateTitle()
        self.tblEarning.estimatedRowHeight = 30
        self.tblEarning.rowHeight = UITableView.automaticDimension
        setupChart()
        wsGetWeeklyEarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    //MARK: - Set localized layout
    func setLocalization() {
        updateUI(isUpdate: false)
        //LOCALIZED
        self.title = "TXT_EARNING".localized
        lblPaymentToProvider.text = "TXT_STATISTIC".localized
        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblEarning.backgroundColor = UIColor.themeViewBackgroundColor
        self.collectionViewForAnalytic.backgroundColor = UIColor.themeViewBackgroundColor
        scrMonthlyEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        mainViewForEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        btnDate.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        lblProviderEarning.textColor = UIColor.themeSelectionColor
        lblPaymentToProvider.textColor = UIColor.themeSelectionColor
        lblTotalProviderEarning.textColor = UIColor.themeSelectionColor
        
        /*Set Font*/
        btnDate.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblTotalProviderEarning.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblPaymentToProvider.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblProviderEarning.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblEmptyMsg.text = "TXT_WEEKLY_EARNING_LIST_EMPTY".localized
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionViewForAnalytic?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
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
    
    //MARK:
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: User Define Function
    
    func updateUI(isUpdate: Bool = false) {
        heightForTblEarning.constant = tblEarning.contentSize.height
        heightCollectionAnalytic.constant = 300
        imgEmpty.isHidden = isUpdate
        mainViewForEarning.isHidden = !isUpdate
        self.view.layoutIfNeeded()
    }
    
    //MARK: wsGetEarning
    func wsGetWeeklyEarning() {
        Utility.showLoading()
        
        let dictParam:[String:String] = [PARAMS.TOKEN : preferenceHelper.getSessionToken(),
                                         PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                                         PARAMS.DATE : strStartDateOfEarningForParam]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_WEEKLY_EARNING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response,data, error) -> (Void) in
            
            Parser.parseEarning(response,data: data, arrayListForEarning: self.arrForEarning, arrayListForAnalytic: self.arrForAnalytic, arrayListForOrders: self.arrForOrders,isWeeklyEarning: true, completetion: { [unowned self] (result) in
                if result {
                    var dayArrays:[String] = []
                    for i in 0..<self.arrForOrders.count {
                        let strDate = (self.arrForOrders.object(at: i) as! Analytic).title ?? ""
                        let xLabelDate:String =  Utility.stringToString(strDate: strDate, fromFormat: DateFormat.WEB, toFormat: "dd \n MMM");
                        dayArrays.append(xLabelDate)
                    }
                    
                    self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dayArrays)
                    self.setChartData()
                    let jsonDecoder = JSONDecoder()
                    do {
                        let dailyEarningResponse:EarningResponse = try jsonDecoder.decode(EarningResponse.self, from: data!)
                        self.lblProviderEarning.text = dailyEarningResponse.providerDailyEarning?.totalPayToProvider.toString()
                        self.lblTotalProviderEarning.text = (dailyEarningResponse.providerWeeklyEarning?.totalProviderServiceFees.toCurrencyString())!
                        
                        self.collectionViewForAnalytic.reloadData()
                        self.tblEarning.reloadData()
                        self.updateUI(isUpdate: true)
                    }catch {
                        print("wrong response")
                    }
                }else {
                    self.updateUI(isUpdate: false)
                }
            })
            Utility.hideLoading()
        }
    }
    
    func openDatePicker() {
        let datePickerDialog:CustomPicker = CustomPicker.showCustomPicker(title: "TXT_SELECT_WEEK".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog]
            (selectedDate:(Date,Date)) in
            self.strStartDateOfEarning = Utility.dateToString(date: selectedDate.0, withFormat: DateFormat.EARNING)
            self.strStartDateOfEarningForParam = Utility.dateToString(date: selectedDate.0, withFormat: DateFormat.EARNING, isForceEnglish: true)
            
            self.strEndDateOfEarning = Utility.dateToString(date: selectedDate.1, withFormat: DateFormat.EARNING)
            self.setDateTitle()
            self.wsGetWeeklyEarning()
            datePickerDialog.removeFromSuperview()
        }
    }
}

extension WeeklyEarningVC {
    
    func setChartData() {
        barChartView.noDataText = "You need to provide data for the provider earning."
        var minValue:Double = 0.0
        var maxValue:Double = 0.0
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<self.arrForOrders.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: (self.arrForOrders.object(at: Int(i)) as! Analytic).value?.toDouble() ?? 0.0)
            let value = (self.arrForOrders.object(at: Int(i)) as! Analytic).value?.toDouble() ?? 0.0
            dataEntries.append(dataEntry)
            if value > maxValue {
                maxValue = value
            }
            if value < minValue {
                minValue = value
            }
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.highlightAlpha = 0.0
        let dataSets: [BarChartDataSet] = [chartDataSet]
        chartDataSet.colors = [UIColor(red: 151/255, green: 231/255, blue: 255/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: dataSets)
        if minValue < 0 {
            self.barChartView.leftAxis.axisMinimum = minValue - 10
        }else {
            self.barChartView.leftAxis.axisMinimum = minValue
        }
        self.barChartView.leftAxis.axisMaximum = maxValue + 10
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.8
        let groupCount = self.arrForOrders.count
        chartData.barWidth = barWidth;
        barChartView.xAxis.axisMinimum = -1
        
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChartView.xAxis.axisMaximum = gg * Double(groupCount)
        barChartView.gridBackgroundColor = UIColor.clear
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        
        barChartView.backgroundColor = UIColor.clear
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.description)
        let index = Int(entry.x.roundTo(places: 0))
        let date = (arrForOrders .object(at: Int(index)) as! Analytic).title
        let currentDate = Date()
        let selectedDate:Date = Utility.stringToDate(strDate: date!, withFormat: DateFormat.WEB)
        if selectedDate > currentDate {
            Utility.showToast(message: "MSG_NO_EARNING_FOR_FUTURE_DATE".localized)
        }else {
            let parent:EarningVC = ((self.parent) as! EarningVC)
            parent.tabBar(parent.tabBar, didSelect: parent.tabBar.items![0])
            parent.dailyVC?.strDateOfEarning = Utility.stringToString(strDate: date!, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_MM_DD_YYYY)
            parent.dailyVC?.strDateOfEarningForParam = Utility.stringToString(strDate: date!, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_MM_DD_YYYY, isForceEnglish: true)
            parent.dailyVC?.btnDate.setTitle(Utility.convertDateFormate(date:Utility.stringToDate(strDate: date!, withFormat: DateFormat.WEB)), for: .normal)
            parent.dailyVC?.wsGetDailyEarning();
        }
    }
    
    func setupChart() {
        barChartView.delegate = self
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.backgroundColor = UIColor.clear
        barChartView.xAxis.gridColor = .clear
        barChartView.leftAxis.gridColor = .clear
        barChartView.rightAxis.gridColor = .clear
        barChartView.rightAxis.labelTextColor = .clear
        barChartView.doubleTapToZoomEnabled = false
        barChartView.setScaleEnabled(false)
        barChartView.dragEnabled = false
        barChartView.extraTopOffset = 20
        
        let xaxis = barChartView.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.labelCount = 7
        xaxis.spaceMax = 10
        xaxis.spaceMin = 10
        let lengends = barChartView.legend
        lengends.enabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.20
        yaxis.drawGridLinesEnabled = false
    }
}

extension WeeklyEarningVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
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
    
    //MARK: UICollectionViewDelegateFlowLayout
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.bounds.size.width) / CGFloat(2))
        return CGSize(width: itemWidth, height: 60)
    }
}

extension WeeklyEarningVC:UITableViewDelegate,UITableViewDataSource {

    //MARK: - Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrForEarning.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (((arrForEarning.object(at: section)) as! [Earning]).count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EarningCell
        let earning:Earning = ((arrForEarning .object(at: indexPath.section)) as! [Earning])[indexPath.row]
        cell.setCellData(cellItem:earning)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! EarningSectionCell
        sectionHeader.setData(title: ((arrForEarning.object(at: section) as! [Earning])[0].sectionTitle!))
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - User Define Method
    func startOfWeek() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return Date() }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)!
    }

    func endOfWeek() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else { return Date() }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)!
    }

    func setDateTitle() {
        let title:String = strStartDateOfEarning + " - " + strEndDateOfEarning
        btnDate.setTitle(title, for: .normal)
    }
}

class WeeklyEarningCell:TblVwCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEarning: UILabel!

    override func awakeFromNib() {
        lblDate.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblEarning.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblDate.textColor = UIColor.themeTextColor
        lblEarning.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }

    func setCellData(date:String, total:String) {
        lblDate.text = Utility.stringToString(strDate: date, fromFormat: DateFormat.WEB, toFormat: DateFormat.WEEK_FORMAT)
        lblEarning.text = total
    }
}
