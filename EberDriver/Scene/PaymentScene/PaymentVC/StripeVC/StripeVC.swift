//
//  StripeVCViewController.swift
//  Vikres
//
//  Created by Elluminati on 17/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class StripeVC: BaseVC
{
    //MARK:- Outlets
    @IBOutlet weak var lblNoCards: UILabel!
    @IBOutlet weak var lblCreditCards: UILabel!
    @IBOutlet weak var tblCreditCards: UITableView!
    @IBOutlet weak var creditCardTableViewHeight: NSLayoutConstraint!

    //MARK:- Variables
    var paymentVC:PaymentVC!
    var arrForCardList : NSMutableArray = NSMutableArray.init()
    var arrForCard:[Card] = []
    var selectedCard:Card = Card.init()
    var didApiCalled: ((_ response: AllCardResponse) -> Void)?

    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentVC = ((storyboard?.instantiateViewController(withIdentifier: "PaymentVC"))! as! PaymentVC)
        setLocalization()
    }

    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblCreditCards.text = "TXT_CREDIT_CARD".localized
        lblCreditCards.textColor = UIColor.themeTextColor
        lblCreditCards.font = FontHelper.font(size: FontSize.small, type: .Bold)
        lblNoCards.text = "TXT_NO_CREDIT_CARD".localized
        lblNoCards.textColor = UIColor.themeTextColor
        lblNoCards.font = FontHelper.font(size: FontSize.regular, type: .Light)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetAllCards()
    }

    //MARK:- Web Service Methods
    func wsGetAllCards() {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] = [ PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                                           PARAMS.USER_ID: preferenceHelper.getUserId(),
                                           PARAMS.TYPE: CONSTANT.TYPE_PROVIDER];
        
        afh.getResponseFromURL(url: WebService.USER_GET_CARDS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data,error) -> (Void) in
            
            if (error != nil) {
                Utility.hideLoading()
            }else {
                self.selectedCard = Card.init()
                
                if Parser.isSuccess(response: response,data: data) {
                    let jsonDecoder = JSONDecoder()
                    do {
                        
                        let allCardResponse:AllCardResponse = try jsonDecoder.decode(AllCardResponse.self, from: data!)
                        self.arrForCard.removeAll()
                        self.didApiCalled?(allCardResponse)

                        PaymentMethod.Payment_gateway_type = "\(allCardResponse.paymentGateway[0].id)"

                        for card in allCardResponse.card {
                            if card.isDefault == TRUE {
                                self.selectedCard = card
                            }
                            self.arrForCard.append(card)
                        }
                        if self.arrForCard.count > 0 {
                            self.lblCreditCards.isHidden = false
                            self.tblCreditCards.isHidden = false
                            self.tblCreditCards.reloadData()
                            self.lblNoCards.isHidden = true
                            if self.tblCreditCards.contentSize.height >= self.view.frame.height - 50 {
                                self.creditCardTableViewHeight.constant = self.view.frame.height - 50
                            } else {
                                self.creditCardTableViewHeight.constant = self.tblCreditCards.contentSize.height
                            }
                        }
                        else {
                            self.lblCreditCards.isHidden = true
                            self.tblCreditCards.isHidden = true
                            self.lblNoCards.isHidden = false
                            self.creditCardTableViewHeight.constant = 100
                        }
                        Utility.hideLoading()
                    } catch {}
                    Utility.hideLoading()
                }
            }
        }
    }
        
    func wsSelectCard(card:Card) {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.USER_ID: preferenceHelper.getUserId(),
                                          PARAMS.TOKEN: preferenceHelper.getSessionToken(),
                                          PARAMS.CARD_ID: card.id,
                                          PARAMS.TYPE: CONSTANT.TYPE_PROVIDER,
                                          PARAMS.PAYMENT_GATEWAY_TYPE :PaymentMethod.Payment_gateway_type ]

        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.DEFAULT_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, data,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response,data: data) {
                DispatchQueue.main.async {
                    var newCards:[Card] = []
                    for var iterateCard in self.arrForCard {
                        if iterateCard.id == card.id {
                            iterateCard.isDefault = TRUE;
                        }else {
                            iterateCard.isDefault = FALSE;
                        }
                        newCards.append(iterateCard)
                    }
                    self.arrForCard = newCards
                    self.tblCreditCards.reloadData()
                }
            }
        }
    }
        
    func wsDeleteCard(card:Card) {
        Utility.showLoading()
        let afh:AlamofireHelper = AlamofireHelper.init()
        let dictParam : [String : Any] = [ PARAMS.TOKEN:preferenceHelper.getSessionToken(),
                                           PARAMS.USER_ID : preferenceHelper.getUserId(),
                                           PARAMS.CARD_ID : card.id,
                                           PARAMS.TYPE : CONSTANT.TYPE_PROVIDER];

        afh.getResponseFromURL(url: WebService.DELETE_CARD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            
            if (error != nil) {
                Utility.hideLoading()
            }else {
                Utility.hideLoading()
                if Parser.isSuccess(response: response,data: data) {
                    DispatchQueue.main.async {
                        
                        if let index = self.arrForCard.firstIndex(where: { (iterateCard) -> Bool in
                            card.id ==  iterateCard.id
                        }) {
                            if (card.isDefault == TRUE) {
                                self.arrForCard.remove(at: index)
                                if self.arrForCard.count == 0 {
                                    
                                }else {
                                    self.wsSelectCard(card: self.arrForCard[0])
                                }
                            }else {
                                self.arrForCard.remove(at: index)
                            }
                        }
                        self.tblCreditCards.reloadData()
                    }
                }
            }
        }
    }
}

extension StripeVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForCard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StripeCardCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StripeCardCell
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.isUserInteractionEnabled = true
        cell.setCellData(cellItem: arrForCard[indexPath.row], parent: self)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.wsSelectCard(card:arrForCard[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class StripeCardCell: UITableViewCell
{
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var imgDefault : UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgDelete: UIImageView!
    
    
    //MARK:- Variables
    weak var stripeVCObject:StripeVC?
    var currentCard:Card?
    
    @IBOutlet weak var lblCardIcon: UILabel!
    @IBOutlet weak var imgCardIcon: UIImageView!
    deinit {
        print("\(self) \(#function)")
    }
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCardNumber.font = FontHelper.font(size: FontSize.regular, type: .Regular)
        lblCardNumber.textColor = UIColor.themeTextColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
//        lblCardIcon.text = FontAsset.icon_card
        
        self.lblCardIcon.setForIcon()
        imgCardIcon.image = UIImage(named: "asset-card")
//        btnDelete.setTitle(FontAsset.icon_cancel, for: .normal)
//        btnDelete.setSimpleIconButton()
        imgDelete.tintColor = UIColor.themeImageColor
        
        
//        btnDefault.setTitle(FontAsset.icon_checked, for: .normal)
//        btnDefault.setSimpleIconButton()
        imgDefault.tintColor = UIColor.themeImageColor
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:Card, parent:StripeVC) {
        currentCard = cellItem
        stripeVCObject = parent
        lblCardNumber.text = "****" + cellItem.lastFour
        btnDefault.isHidden = !(cellItem.isDefault == TRUE)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickBtnDeleteCard(_ sender: AnyObject) {
        openConfirmationDialog()
    }
    
    func openConfirmationDialog()
    {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_DELETE_CARD".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton =
        { [/*unowned self,*/ unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton =
        { [unowned self, unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
            self.stripeVCObject?.wsDeleteCard(card: self.currentCard!)
        }
    }
}
