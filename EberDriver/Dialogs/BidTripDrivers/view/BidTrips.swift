//
//  BidTrips.swift
//  EberDriver
//
//  Created by Mayur on 08/06/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

protocol TimerDelegate: AnyObject {
    func updateTimer(for cell: BidTrips)
    func stopTimer(for cell: BidTrips)
}

class BidTrips: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTripId: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var lblRate: UILabel!
    
    var onClickButton : ((BidTrips) ->())?
    weak var delegate: TimerDelegate?
    var data: Bids?
    weak var timer: Timer?
    
    deinit {
        print("Deinit BidTrips")
        data = nil
        stopTimer()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCancel.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnCancel.titleLabel?.textColor = UIColor.themeButtonTitleColor
        btnCancel.backgroundColor = UIColor.themeButtonBackgroundColor
        btnCancel.setupButton()
        
        lblTripId.textColor = .themeLightTextColor
        lblTimer.textColor = .themeWalletDeductedColor
        lblRate.textColor = .themeTextColor
        lblPrice.textColor = .themeLightTextColor
        
        lblTimer.font = FontHelper.font(type: .Regular)
    }

    func setData(data: Bids) {
        self.data = data
        
        imgUser.downloadedFrom(link: data.picture ?? "")
        
        var name = ""
        if !(data.first_name ?? "").isEmpty {
            name += data.first_name ?? ""
        }
        if !(data.last_name ?? "").isEmpty {
            name += " "
            name += data.last_name ?? ""
        }
        lblName.text = name
        lblTripId.text = ("TXT_TRIP_ID".localized + " " + "\(data.unique_id ?? 0)")
        lblPrice.text = "txt_bidding_price".localized.replacingOccurrences(of: "****", with: (data.ask_bid_price ?? 0).toCurrencyString())
        lblRate.text = "\((data.rate ?? 0).toString())"
        handelTimer()
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        if let buttonAction = onClickButton {
            buttonAction(self)
        }
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handelTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func handelTimer() {
        if lblTimer == nil {
            stopTimer()
            return
        }
        guard let data = data else { return }
        let bidEndAt = data.bid_end_at ?? ""

        let calendar = Calendar.current

        // Define the two dates
        let utcTimeZone = TimeZone(identifier: "UTC")!
        let utcBidEndAt = Utility.stringToDate(strDate: bidEndAt, withFormat: DateFormat.WEB, timeZone: utcTimeZone)

        let currentDate = Date()
        let strCurrentDate = Utility.dateToString(date: currentDate, withFormat: DateFormat.WEB, withTimezone: utcTimeZone)
        let currentUtcDate = Utility.stringToDate(strDate: strCurrentDate, withFormat: DateFormat.WEB, timeZone: utcTimeZone)

        // Calculate the difference between the dates
        let components = calendar.dateComponents([.second], from: currentUtcDate, to: utcBidEndAt)
        let differenceInDays = components.second ?? 0

        if differenceInDays > 0 {
            if timer == nil {
                startTimer()
            }
            lblTimer.text = "\(differenceInDays)s"
        } else {
            lblTimer.text = ""
            stopTimer()
            onClickButton(btnCancel)
        }
    }
}
