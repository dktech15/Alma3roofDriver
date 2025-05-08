//
//  MyBookingVC.swift
//  EberDriver
//
//  Created by Rohit on 14/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class MyBookingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getScheduleTrip()
        // Do any additional setup after loading the view.
    }

    func getScheduleTrip(){
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.PROVIDER_ID] =  preferenceHelper.getUserId()
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.SCHEDULE_TRIP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response,data, error)  -> (Void) in
            Utility.hideLoading()
//            if (error != nil) {
//                if self.listNotitifcations.count == 0{
//                    self.imgEmpaty.isHidden = false
//                }else{
//                    self.imgEmpaty.isHidden = true
//                }
//            } else {
//                self.listNotitifcations = [Notitifcations]()
//                if let data = response["notifications"] as? [JSONType]{
//                    self.listNotitifcations.append(contentsOf: data.compactMap(Notitifcations.init))
//                    self.tableNotification.reloadData()
//                    if self.listNotitifcations.count == 0{
//                        self.imgEmpaty.isHidden = false
//                    }else{
//                        self.imgEmpaty.isHidden = true
//                    }
//                }
//                if self.listNotitifcations.count == 0{
//                    self.imgEmpaty.isHidden = false
//                }else{
//                    self.imgEmpaty.isHidden = true
//                }
//            }
        }
    }

}
