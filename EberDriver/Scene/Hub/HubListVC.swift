//
//  HubListVC.swift
//  EberDriver
//
//  Created by elluminati on 17/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

class HubListVC: UIViewController {
    
    @IBOutlet weak var tblHubList: UITableView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    
    var arrHub = [Hubs]()
    var seletedHub: Hubs?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalized()
        setTableView()
        wsGetHubList()
    }
    
    func setLocalized() {
        lblTitle.text = "txt_hub".localized
        lblTitle.font = FontHelper.font(size: FontSize.medium
            , type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTitleColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationView.navigationShadow()
    }
    
    func wsGetHubList() {
        Utility.showLoading()
        
        let afh:AlamofireHelper = AlamofireHelper.init()

        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
              PARAMS.TOKEN:preferenceHelper.getSessionToken(),
              PARAMS.LATITUDE:ProviderSingleton.shared.currentCoordinate.latitude,
              PARAMS.LONGITUDE:ProviderSingleton.shared.currentCoordinate.longitude]

        afh.getResponseFromURL(url: WebService.GET_PROVIDER_HUB_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, data, error) -> (Void) in
            
            Utility.hideLoading()
            self.arrHub.removeAll()
            
            if Parser.isSuccess(response: response, data: data!) {
                let jsonDecoder = JSONDecoder()
                do {
                    let hubListResponse = try jsonDecoder.decode(HubListResponse.self, from: data!)
                    
                    if let hubs = hubListResponse.hubs {
                        self.arrHub.append(contentsOf: hubs)
                    }
                } catch {
                    print("data may be wrong")
                }
            }
            
            self.reLoadList()
        }
    }
    
    func reLoadList() {
        if self.arrHub.count > 0 {
            self.tblHubList.isHidden = false
            self.lblNoData.isHidden = true
        } else {
            self.tblHubList.isHidden = true
            self.lblNoData.isHidden = false
        }
        tblHubList.reloadData()
    }
    
    func setTableView() {
        tblHubList.delegate = self
        tblHubList.dataSource = self
        tblHubList.separatorColor = .clear
        tblHubList.register(HubListCell.NIB, forCellReuseIdentifier: HubListCell.identifier)
        tblHubList.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func openNavigationOption() {
        let alertDialog = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let googleMap = UIAlertAction(title: NSLocalizedString("TXT_GOOGLE_MAP".localized, comment: ""), style: .default, handler: { [unowned self] action in
            self.gotoGoogleMap()
        })
        let WazeMap = UIAlertAction(title: NSLocalizedString("TXT_WAZE_MAP".localized, comment: ""), style: .default, handler: { [unowned self] action in
            self.gotoWazeMap()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("TXT_CANCEL".localized, comment: ""), style: .destructive, handler: { _ in
        })
        
        alertDialog.addAction(googleMap)
        alertDialog.addAction(WazeMap)
        alertDialog.addAction(cancel)
        self.present(alertDialog, animated: true) {
            //
        }
    }
    
    func gotoGoogleMap() {
        guard let seletedHub = seletedHub else { return }
        guard let locations = seletedHub.location else { return }
        let wazeLat = locations[0].toString(places: 6)
        let wazeLong = locations[1].toString(places: 6)
        var strUrl = "daddr=\(wazeLat),\(wazeLong)&directionsmode=driving"

        let escapedString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        strUrl = escapedString?.replacingOccurrences(of: "%20", with: "+") ?? ""
        
        if let url = URL(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(url) {
                if let url = URL(string: "comgooglemaps://?" + (strUrl)) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                Utility.showToast(message: "VALIDATION_MSG_GOOGLE_MAP_NOT_AVAILABLE".localized)
            }
        }
    }
    
    func gotoWazeMap() {
        guard let seletedHub = seletedHub else { return }
        guard let locations = seletedHub.location else { return }
        if let url = URL(string: "waze://") {
            if UIApplication.shared.canOpenURL(url) {
                let wazeLat = locations[0].toString(places: 6)
                let wazeLong = locations[1].toString(places: 6)
                let strUrl = "waze://?ll=\(Double(wazeLat) ?? 0.0),\(Double(wazeLong) ?? 0.0)&navigate=yes"
                if let url = URL(string: strUrl) {
                    UIApplication.shared.open(url, completionHandler: { (success) in
                        
                    })
                }
            } else {
                Utility.showToast(message: "VALIDATION_MSG_WAZE_MAP_NOT_AVAILABLE".localized)
            }
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionMap(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Hub", bundle: nil).instantiateViewController(withIdentifier: "HubMapListVC") as! HubMapListVC
        vc.arrHub  = arrHub
        self.navigationController?.pushViewController(vc, animated: true)
//        navigationVC.pushViewController(vc, animated: true)
    }
}

extension HubListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHub.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HubListCell.identifier, for: indexPath) as! HubListCell
        let obj = arrHub[indexPath.row]
        cell.setData(data: obj)
        cell.onClickButton = { objCell in
            if let index = self.tblHubList.indexPath(for: objCell) {
                self.openMapNavigation(index: index.row)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func openMapNavigation(index: Int) {
        let obj = arrHub[index]
        seletedHub = obj
        openNavigationOption()
    }
}
