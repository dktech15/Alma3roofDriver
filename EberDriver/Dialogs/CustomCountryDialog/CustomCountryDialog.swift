//
//  CustomCountryDialog.swift
//  edelivery
//
//  Created by Elluminati on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCountryDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate
{
    struct Identifiers {
        static let  CountryDialog = "dialogForCountry"
        static let  CellForCountry = "CustomCountryCell"
        static let  reuseCellIdentifier = "cellForCountry"
    }
    
    //MARK: - Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForCountry: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblDivider: UILabel!
    
    //MARK: - Variables
    var coutrylist:[Country] = [];
    var country_list:[CountryList] = [];
    var filtered_country_list:[CountryList] = [];
    var filteredCountries = [Country]()
    var onCountrySelected : ((_ country:Country) -> Void)? = nil
    var on_Country_Selected : ((_ country:CountryList) -> Void)? = nil
    var isForInitialTrip = false

    override func awakeFromNib() {
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblTitle.textColor = UIColor.themeTextColor
        lblDivider.backgroundColor = UIColor.lightGray
        btnClose.titleLabel?.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
        lblTitle.text = "TXT_SELECT_COUNTRY".localized
        lblTitle.font = FontHelper.font(size: FontSize.large, type: FontType.Regular)
        lblTitle.textColor = UIColor.themeTitleColor
        txtSearch.font = FontHelper.font(size: FontSize.medium, type: FontType.Regular)
    }
    
    public static func showCustomCountryDialog(withDataSource:NSMutableArray = [],isForInitialTrip:Bool = false) -> CustomCountryDialog {
        let view = UINib(nibName: Identifiers.CountryDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCountryDialog
        view.alertView.setShadow()
        view.alertView.setRound(withBorderColor: UIColor.lightText, andCornerRadious: 10.0, borderWidth: 0.5)
        view.tableForCountry.delegate = view;
        view.tableForCountry.dataSource = view;
        view.txtSearch.delegate = view;
        view.isForInitialTrip = isForInitialTrip
        view.txtSearch.placeholder = "TXT_SEARCH_COUNTRY".localized
        if isForInitialTrip {
            view.country_list = withDataSource as! [CountryList]
            view.filtered_country_list = withDataSource as! [CountryList]
        } else {
            view.coutrylist = withDataSource as! [Country]
            view.filteredCountries = withDataSource as! [Country]
        }
        view.tableForCountry.register(UINib.init(nibName: Identifiers.CellForCountry, bundle: nil), forCellReuseIdentifier: Identifiers.reuseCellIdentifier)
        view.tableForCountry.tableFooterView = UIView.init()
        let frame = (UIApplication.shared.keyWindow?.frame)!;
        view.frame = frame
        UIApplication.shared.keyWindow?.addSubview(view)
        UIApplication.shared.keyWindow?.bringSubviewToFront(view);
        return view;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isForInitialTrip {
            let country:CountryList = filtered_country_list[indexPath.row]
            if self.on_Country_Selected != nil {
                self.on_Country_Selected!(country)
            }
        } else {
            let country:Country = filteredCountries[indexPath.row]
            if self.onCountrySelected != nil {
                self.onCountrySelected!(country)
            }
        }
        self.removeFromSuperview();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isForInitialTrip {
            if filtered_country_list.count > 0 {
                return filtered_country_list.count
            }
        } else {
            if filteredCountries.count > 0 {
                return filteredCountries.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Identifiers.reuseCellIdentifier, for: indexPath) as! CustomCountryCell;
        if isForInitialTrip {
            let country:CountryList = filtered_country_list[indexPath.row]
            cell.lblCountryName.text = country.countryName
            cell.lblCountryPhoneCode.text = country.countryPhoneCode
            cell.lblCountryPhoneCode.textAlignment = .right
        } else {
            let country:Country = filteredCountries[indexPath.row]
            cell.lblCountryName.text = country.countryname
            cell.lblCountryPhoneCode.text = country.countryphonecode
            cell.lblCountryPhoneCode.textAlignment = .right
        }
        return cell
    }
    
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.removeFromSuperview();
    }
    
    @IBAction func searching(_ sender: Any) {
        let text = txtSearch.text!.lowercased()
        if text.isEmpty {
            if isForInitialTrip{
                filtered_country_list.removeAll()
                filtered_country_list.append(contentsOf: country_list)
            } else {
                filteredCountries.removeAll()
                filteredCountries.append(contentsOf: coutrylist)
            }
        } else {
            filteredCountries.removeAll()
            filtered_country_list.removeAll()
            if isForInitialTrip{
                for country in country_list {
                    if country.countryName.lowercased().hasPrefix(text) {
                        filtered_country_list.append(country)
                    }
                }
            } else {
                for country in coutrylist {
                    if country.countryname.lowercased().hasPrefix(text) {
                        filteredCountries.append(country)
                    }
                }
            }
        }
        tableForCountry.reloadData()
    }
}

class CustomCountryCell:TblVwCell {
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    
    override func awakeFromNib() {
        lblCountryPhoneCode.textColor = UIColor.themeTextColor
        lblCountryName.textColor = UIColor.themeLightTextColor
        lblCountryPhoneCode.font = FontHelper.font(size: FontSize.regular, type: FontType.Bold)
        lblCountryName.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
    }
}
