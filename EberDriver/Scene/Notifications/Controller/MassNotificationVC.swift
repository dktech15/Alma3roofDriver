//
//  MassNotificationVC.swift
//  EberDriver
//
//  Created by Rohit on 08/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class MassNotificationVC: UIViewController {
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableNotification : UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgEmpaty : UIImageView!
    @IBOutlet weak var lblNoNotification: UILabel!
    var listNotitifcations = [Notitifcations]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationView.navigationShadow()
        tableNotification.register(MassNotificationCell.NIB, forCellReuseIdentifier: MassNotificationCell.identifier)
        imgEmpaty.isHidden = true
        lblNoNotification.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalization()
//        navigationView.navigationShadow()
        self.getNotifications()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    func setupLayout() {
//        navigationView.navigationShadow()
    }
    func setLocalization(){
        lblTitle.text = "TXT_NOTIFICATION".localizedCapitalized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor

    }
    
    @IBAction func actionBack (_ sender : UIButton){
        self.dismiss(animated: true)
    }
    func getNotifications(){
        Utility.showLoading()
        var  dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] =  preferenceHelper.getUserId() 
        dictParam[PARAMS.DEVICE_TYPE] = CONSTANT.IOS
        dictParam[PARAMS.user_type] = 2//CONSTANT.TYPE_PROVIDER.toString()
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.MASS_NOTIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [self]
            (response,data, error)  -> (Void) in
            Utility.hideLoading()
            if (error != nil) {
                if self.listNotitifcations.count == 0{
                    self.imgEmpaty.isHidden = false
                    lblNoNotification.isHidden = false
                }else{
                    lblNoNotification.isHidden = true
                    self.imgEmpaty.isHidden = true
                }
            } else {
                self.listNotitifcations = [Notitifcations]()
                if let data = response["notifications"] as? [JSONType]{
                    self.listNotitifcations.append(contentsOf: data.compactMap(Notitifcations.init))
                    self.tableNotification.reloadData()
                    if self.listNotitifcations.count == 0{
                        lblNoNotification.isHidden = false
                        self.imgEmpaty.isHidden = false
                    }else{
                        lblNoNotification.isHidden = true
                        self.imgEmpaty.isHidden = true
                    }
                }
                if self.listNotitifcations.count == 0{
                    self.imgEmpaty.isHidden = false
                }else{
                    self.imgEmpaty.isHidden = true
                }
            }
        }
    }
}

extension MassNotificationVC :  UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listNotitifcations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MassNotificationCell.identifier) as! MassNotificationCell
        cell.lblMessage.text = listNotitifcations[indexPath.row].message
        cell.lblTime.text = Utility.stringToString(strDate: listNotitifcations[indexPath.row].updated_at!, fromFormat: DateFormat.WEB, toFormat: DateFormat.DATE_TIME_FORMAT_AM_PM) //
        return cell
    }
}
