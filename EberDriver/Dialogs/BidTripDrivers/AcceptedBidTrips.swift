//
//  CustomPhotoDialog.swift
//  Cabtown
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

class AcceptedBidTrips:CustomDialog,UITextFieldDelegate {

    //MARK: - OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var tblTrips: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!

    //MARK: - Variables
    var onClickRightButton : ((_ dialog:AcceptedBidTrips ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var onRejectTrip : (() -> Void)? = nil
    var arrBids = [Bids]()
    
    static let  verificationDialog = "AcceptedBidTrips"

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func removeFromSuperview() {
        for obj in tblTrips.visibleCells {
            if let cell = obj as? BidTrips {
                cell.stopTimer()
            }
        }
        super.removeFromSuperview()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTable.constant = tblTrips.contentSize.height
    }

    static func showDialog(arrBids: [Bids], tag: Int = DialogTags.tripBidingDialog) -> AcceptedBidTrips {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AcceptedBidTrips
        view.alertView.setShadow()
        view.arrBids = arrBids
        
        view.reloadTrips(arrBids: view.arrBids)
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.tag = tag
        
        view.setLocalization()
        view.setTableView()
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        return view;
    }

    func setLocalization() {
        /* Set Color */
        btnLeft.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
  
        btnRight.setupButton()
        
        /* Set Font */
        btnLeft.titleLabel?.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnRight.titleLabel?.font =  FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Bold)
        lblMessage.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.white
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        btnLeft.setTitle("TXT_CLOSE".localized, for: UIControl.State.normal)
        btnRight.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        
        lblTitle.text = "txt_bidding".localized
        lblMessage.text = "".localized
        
        lblNoData.text = "ERROR_CODE_415".localized
        lblNoData.font =  FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblNoData.textColor = .themeTextColor
    }
    
    public func setTableView() {
        tblTrips.delegate = self
        tblTrips.dataSource = self
        tblTrips.separatorColor = .clear
        tblTrips.register(UINib(nibName: "BidTrips", bundle: nil), forCellReuseIdentifier: "BidTrips")
        tblTrips.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func reloadTrips(arrBids: [Bids]) {
        self.arrBids.removeAll()
        for bid in arrBids {
            self.arrBids.append(bid)
        }
        tblTrips.reloadData()
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(self)
        }
    }
}

extension AcceptedBidTrips: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBids.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidTrips", for: indexPath) as! BidTrips
        let obj = arrBids[indexPath.row]
        cell.setData(data: obj)
        cell.onClickButton = { [weak self] tblCell in
            guard let self = self else { return }
            if let index = self.tblTrips.indexPath(for: cell) {
                print(index.row)
                self.wsRejectTrip(index: index.row)
            }
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func wsRejectTrip(index: Int) {
        let obj = arrBids[index]
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TRIP_ID] = obj.trip_id ?? ""
        dictParam[PARAMS.IS_PROVIDER_ACCEPTED] = ProviderStatus.Rejected.rawValue
        dictParam[PARAMS.IS_REQUEST_TIMEOUT] = false

        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.RESPOND_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response,data, error) -> (Void) in
            Utility.hideLoading()
            guard let self = self else { return }
            if self.onRejectTrip != nil {
                self.onRejectTrip!()
            }
            if Parser.isSuccess(response: response,data: data) {
                self.arrBids.remove(at: index)
                self.tblTrips.reloadData()
                if self.arrBids.count == 0 {
                    self.removeFromSuperview()
                }
            }
        }
    }
}
