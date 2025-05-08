//
//  MyBookingVC.swift
//  EberDriver
//
//  Created by Rohit on 14/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class MyBookingVC: UIViewController {
    @IBOutlet weak var tableTrip : UITableView!
    var listPendingTrip = [PendingTrip]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTrip.register(PendingTripCell.NIB, forCellReuseIdentifier: PendingTripCell.identifier)
        self.getScheduleTrip()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionBack (_ sender : UIButton){
        self.dismiss(animated: true)
    }
    
    func getScheduleTrip(){
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] =  preferenceHelper.getUserId()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SCHEDULE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response,data, error)  -> (Void) in
            Utility.hideLoading()
            if (error != nil) {
                if self.listPendingTrip.count == 0{
//                    self.imgEmpaty.isHidden = false
                }else{
//                    self.imgEmpaty.isHidden = true
                }
            } else {
                self.listPendingTrip = [PendingTrip]()
               
                if let data = response["accepted_trips"] as? [JSONType]{
                    self.listPendingTrip.append(contentsOf: data.compactMap(PendingTrip.init))
                    self.tableTrip.reloadData()
                }
                if let data = response["pending_trips"] as? [JSONType]{
                    self.listPendingTrip.append(contentsOf: data.compactMap(PendingTrip.init))
                    self.tableTrip.reloadData()
                }
            }
        }
    }

    func acceptTrip(isProvider : Int,tripId : String){
        //ACCEPT_REJECT_SCHEDULE_TRIP
        /*
         trip_id
         provider_id
         is_provider_accepted : 0 if rejected or 1 if accepted
         */
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] =  preferenceHelper.getUserId()
        dictParam[PARAMS.TRIP_ID] =  tripId
        dictParam[PARAMS.IS_PROVIDER_ACCEPTED] =  isProvider
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.ACCEPT_REJECT_SCHEDULE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response,data, error)  -> (Void) in
            print("response:- \(response)")
            print("error:- \(error)")
            Utility.hideLoading()
            self.getScheduleTrip()
        }
    }
    
    func rejectTrip(id : String){
        //ACCEPT_REJECT_SCHEDULE_TRIP
    }
}

extension MyBookingVC :  UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPendingTrip.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PendingTripCell.identifier) as! PendingTripCell
        let list = listPendingTrip[indexPath.row]
        cell.index = indexPath
        cell.lblTripNumber.text = "Trip Id. \(list.unique_id ?? 0)"
        cell.lblUserName.text = "\(list.user_first_name ?? "") \(list.user_last_name ?? "")"
        cell.lblStartAddress.text = list.source_address ?? ""
        cell.lblEndAddress.text = list.destination_address ?? ""
        cell.lblProviderServiceFees.text = ""
        if list.provider_service_fees! > 0{
            cell.lblProviderServiceFees.text = "\(Double(list.provider_service_fees!).toCurrencyString())"
        }
        if list.is_provider_accepted == 1{
            cell.btnAccept.isHidden = true
        }else{
            cell.btnAccept.isHidden = false
        }
        cell.onClickAccept = { (text , index) in
            print("Accept Click")
            let list = self.listPendingTrip[index.row]
            self.acceptTrip(isProvider: 1, tripId: list._id!)
        }
        cell.onClickReject = { (text , index) in
            print("Reject Click")
            let list = self.listPendingTrip[index.row]
            self.acceptTrip(isProvider: 0, tripId: list._id!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let massNotificationVC = UpcomingTripDetailsVC(nibName: "UpcomingTripDetailsVC", bundle: nil)
        massNotificationVC.modalPresentationStyle = .fullScreen
        massNotificationVC.pendingTrip = listPendingTrip[indexPath.row]
        self.present(massNotificationVC, animated: true, completion: nil)
        return indexPath
    }
}
