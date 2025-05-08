//
//  CustomCityDialog.swift
//  edelivery
//
//  Created by Elluminati on 27/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCityDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate
{
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var tblForCity: UITableView!

    var citylist:[City] = [];
    var fiteredCity:[City] = [];
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    static let  CityyDialog = "dialogForCity"
    var onCitySelected : ((_ countryID:String, _ countryName:String) -> Void)? = nil

    override func awakeFromNib() {
        lblTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.text = "TXT_SELECT_CITY".localized

        lblDivider.backgroundColor = UIColor.lightGray

        btnClose.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        txtSearch.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
        self.backgroundColor = UIColor.themeOverlayColor
    }

    public static func  showCustomCityDialog(withDataSource:NSMutableArray = []) -> CustomCityDialog{
    let view = UINib(nibName: CityyDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCityDialog
      
        view.alertView.setShadow()
        view.alertView.setRound(withBorderColor: UIColor.lightText, andCornerRadious: 10.0, borderWidth: 0.5)
        view.tblForCity.delegate = view;
        view.tblForCity.dataSource = view;
        view.txtSearch.delegate = view;
        view.txtSearch.placeholder = "TXT_SEARCH_CITY".localized
        view.citylist = withDataSource as! [City]
        view.fiteredCity = withDataSource as! [City]
        view.tblForCity.tableFooterView = UIView.init()
        let frame = (UIApplication.shared.keyWindow?.frame)!;
        view.frame = frame
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        return view;
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let city:City = fiteredCity[indexPath.row]
        
        if self.onCitySelected != nil
        {
            self.onCitySelected!(city.id,city.fullCityname)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fiteredCity.count > 0
        {
            return fiteredCity.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
            
       let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        let city:City = fiteredCity[indexPath.row]
        cell.textLabel?.text =  city.fullCityname
       cell.textLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        return cell
    }
    
    @IBAction func onClickBtnClose(_ sender: Any){
    self.removeFromSuperview();
    }
    
    @IBAction func searching(_ sender: Any) {
        let text = txtSearch.text!.lowercased()
        if text.isEmpty
        {
            fiteredCity.removeAll()
            fiteredCity.append(contentsOf: citylist)
        }
        else
        {
            fiteredCity.removeAll()
            for city in citylist
            {
                if  city.fullCityname.lowercased().hasPrefix(text)
                {
                    fiteredCity.append(city)
                }
                
            }
        }
        tblForCity.reloadData()
        
    }
}

