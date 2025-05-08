//
//  PayStackVC.swift
//  Eber
//
//  Created by Jaydeep Vyas  on 16/08/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit
import WebKit

class PayStackVC: BaseVC {
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var htmlDataString: String!
    
    var gotPayUResopnse: ((_ message: String, _ isCallIntentAPI:Bool, _ showPaymentRetryDialog: Bool) -> Void)?
    let socketHelper:SocketHelper = SocketHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }
    func initialViewSetup()
    {
        lblTitle.text = "TXT_PAYMENTS".localized
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        //        btnBack.setupBackButton()
        imgBack.tintColor = UIColor.themeImageColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        
        if PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID{
            self.view.addSubview(self.webView)
            self.view.bringSubviewToFront(self.webView)
            self.webView.loadHTMLString(self.htmlDataString, baseURL: Bundle.main.bundleURL)
            self.webView.navigationDelegate = self
            Utility.hideLoading()
        } else if PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay{
            self.view.addSubview(self.webView)
            self.view.bringSubviewToFront(self.webView)
            self.webView.loadHTMLString(self.htmlDataString, baseURL: Bundle.main.bundleURL)
            self.webView.navigationDelegate = self
            Utility.hideLoading()
        }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID{
            wsGetStripeIntentPayStack()
        }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs{
            self.view.addSubview(self.webView)
            self.view.bringSubviewToFront(self.webView)
            if let str = self.htmlDataString, let url = URL(string: str) {
                self.webView.load(URLRequest(url: url))
                self.webView.navigationDelegate = self
            }
            Utility.hideLoading()
        }else  if  PaymentMethod.Payment_gateway_type == PaymentMethod.New_payment {
            self.socketHelper.connectSocket()
            self.registerProviderSocket(id: preferenceHelper.getUserId())
            if let url = URL(string: htmlDataString) {
                let request = URLRequest(url: url)
                self.webView.load(request)
            } else {
                print("Invalid URL")
            }
            Utility.hideLoading()
        } else {
        }
    }
    
    func registerProviderSocket(id:String) {
        let myUserId = "'tdsp_wallet_\(id)'"
        self.socketHelper.socket?.emit("room", myUserId)
        self.socketHelper.socket?.on(myUserId) {
            [weak self] (data, ack) in
            guard let `self` = self else { return }
            guard let response = data.first as? [String:Any] else
            { return }
            self.navigationController?.popViewController(animated: true)
            print("Soket Response\(response)")
        
        }
    }
    
    @IBAction func onClickBtnMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PayStackVC: WKNavigationDelegate {
    
    //MARK:- Get Stripe Intent
    func wsGetStripeIntentPayStack()
    {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
         PARAMS.TOKEN  : preferenceHelper.getSessionToken(),
         PARAMS.TYPE : CONSTANT.TYPE_PROVIDER,
         PARAMS.PAYMENT_GATEWAY_TYPE : PaymentMethod.Payment_gateway_type ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.GET_STRIPE_ADD_CARD_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,data, error) -> (Void) in
            if Parser.isSuccess(response: response, data: data) {
                Utility.hideLoading()
                print(response["authorization_url"] as? String ?? "")
                let pstkUrl = response["authorization_url"] as? String
                let urlRequest = URLRequest.init(url: URL.init(string: pstkUrl!)!)
                self.view.addSubview(self.webView)
                self.view.bringSubviewToFront(self.webView)
                self.webView.load(urlRequest)
                self.webView.navigationDelegate = self
                
            } else {
                Utility.hideLoading()
            }
        }
    }
    
    //This is helper to get url params
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void))  {
        if let url = navigationAction.request.url {
            
            /*
             We control here when the user wants to cancel a payment.
             By default a cancel action redirects to http://cancelurl.com/.
             Based on our workflow we can for example remove the webview or push
             another view to the user.
             */
            
            
            print("reference url \(url)")
            
            if PaymentMethod.Payment_gateway_type == PaymentMethod.PayStack_ID{
                if url.absoluteString.contains("add_card_success"){
                    self.navigationController?.popViewController(animated: true)
                    decisionHandler(.cancel)
                }
                else{
                    decisionHandler(.allow)
                }
            }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayU_ID{
                if url.absoluteString.contains("\(WebService.BASE_URL)provider_payments"){
                    self.gotPayUResopnse?("MSG_CODE_91".localized, true, false)
                    self.navigationController?.popViewController(animated: true)
                    decisionHandler(.cancel)
                }else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/fail_payment"){
                    self.gotPayUResopnse?("TXT_PAYMENT_FAILED".localized, false, false)
                    self.navigationController?.popViewController(animated: true)
                    decisionHandler(.cancel)
                }
                else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)fail_stripe_intent_payment"){
                    self.gotPayUResopnse?("TXT_PAYMENT_FAILED".localized, false, true)
                    self.navigationController?.popViewController(animated: true)
                    decisionHandler(.cancel)
                }
                else{
                    decisionHandler(.allow)
                }
            }else if PaymentMethod.Payment_gateway_type == PaymentMethod.PayTabs{
                if url.absoluteString.contains("add_card_success") {
                    decisionHandler(.cancel)
                    self.gotPayUResopnse?("".localized, true, false)
                    self.navigationController?.popViewController(animated: true)
                } else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/payment_fail"){
                    decisionHandler(.cancel)
                    self.gotPayUResopnse?("".localized, false, false)
                    self.navigationController?.popViewController(animated: true)
                } else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/fail_stripe_intent_payment"){
                    decisionHandler(.cancel)
                    self.gotPayUResopnse?("".localized, false, false)
                    self.navigationController?.popViewController(animated: true)
                } else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/success_payment"){
                    self.gotPayUResopnse?("MSG_CODE_91".localized, true, false)
                    self.navigationController?.popViewController(animated: true)
                    decisionHandler(.cancel)
                }else{
                    decisionHandler(.allow)
                }
            }else if PaymentMethod.Payment_gateway_type == PaymentMethod.RazorPay{
                if url.absoluteString.contains("add_card_success") {
                    decisionHandler(.cancel)
                    self.gotPayUResopnse?("".localized, true, false)
                    self.navigationController?.popViewController(animated: true)
                } else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/payment_fail"){
                    decisionHandler(.cancel)
                    self.gotPayUResopnse?("".localized, false, false)
                    self.navigationController?.popViewController(animated: true)
                } else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/fail_stripe_intent_payment"){
                    decisionHandler(.cancel)
                    self.gotPayUResopnse?("".localized, false, false)
                    self.navigationController?.popViewController(animated: true)
                } else if url.absoluteString.contains("\(WebService.PAYMENT_BASE_URL)payments/success_payment"){
                    self.gotPayUResopnse?("MSG_CODE_91".localized, true, false)
                    self.navigationController?.popViewController(animated: true)
                    decisionHandler(.cancel)
                }else{
                    decisionHandler(.allow)
                }
            }else{
                decisionHandler(.cancel)
            }
        }
    }
}
