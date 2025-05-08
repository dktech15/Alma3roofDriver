//
//  MyCustomChatVC.swift
//  Qatch Driver
//
//  Created by Elluminati on 03/05/18.
//  Copyright © 2018 Elluminati Mini Mac 5. All rights reserved.
//

import UIKit
import FirebaseAuth
import IQKeyboardManager

class MyCustomChatVC: BaseVC,UITableViewDelegate,UITableViewDataSource,MessageRecivedDelegate,UITextViewDelegate {

    //MARK: - Outlet and Variable
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var imgBack: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var constraintForTextView: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var arrMessages:[FirebaseMessage] = []
    var deviceToken = ""
    var keyboardHeight = 60

    let ChatRef = DBProvider.Instance.dbRef.child(ProviderSingleton.shared.tripId).child(CONSTANT.DBPROVIDER.MESSAGES)

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomConstraint.constant = 10
        tblChat.estimatedRowHeight = 90
        tblChat.rowHeight = UITableView.automaticDimension
        txtMessage.autocorrectionType = UITextAutocorrectionType.no;

        preferenceHelper.setChatName(ProviderSingleton.shared.tripId)

        MessageHandler.Instace.delegate = self
        MessageHandler.Instace.removeObserver()
        MessageHandler.Instace.observeMessage()
        MessageHandler.Instace.observeUpdateMessage()

        txtMessage.delegate = self
        constraintForTextView.constant = 40

        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        txtMessage.backgroundColor = UIColor.themeViewBackgroundColor
        txtMessage.textColor = UIColor.themeTextColor
        txtMessage.tintColor = UIColor.themeTextColor
        btnSend.backgroundColor = UIColor.themeButtonBackgroundColor
        btnSend.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSend.setTitle("TXT_SEND".localizedCapitalized, for: .normal)
        txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized

        lblTitle.text = "TXT_CHAT_WITH".localized + " " + ProviderSingleton.shared.tripUser.firstName + " " + ProviderSingleton.shared.tripUser.lastName
        lblTitle.font = FontHelper.font(size: FontSize.medium, type: FontType.Bold)
        lblTitle.textColor = UIColor.themeTextColor

//        btnBack.setupBackButton()
        imgBack.tintColor = UIColor.themeImageColor
    }

    override func viewWillAppear(_ animated: Bool){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        Utility.hideLoading()
        IQKeyboardManager.shared().isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool){
        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = Int(keyboardRectangle.height)
            print("keyboardHeight\(keyboardHeight)")
           // self.view.frame.origin.y = CGFloat(-keyboardHeight)
            self.bottomConstraint.constant = CGFloat((+keyboardHeight) + 10)
            print("self.view.frame.origin.y\(self.bottomConstraint.constant)")
        }
    }

    @objc func keyboardWillHide(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = Int(keyboardRectangle.height)
            print("keyboardHeight\(keyboardHeight)")
          //  self.view.frame.origin.y = 0
            self.bottomConstraint.constant = 10
            print("self.view.frame.origin.y\(self.bottomConstraint.constant)")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSend.setRound(withBorderColor: .clear, andCornerRadious: btnSend.frame.height/2, borderWidth: 1.0)
        viewForNavigation.navigationShadow()
    }

    //MARK:- Tableview Data Source and delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let message:FirebaseMessage = arrMessages[indexPath.row]
        if message.type == CONSTANT.TYPE_PROVIDER {
            let cell:SenderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderCell
            cell.setCellData(dict: message)
            return cell
        } else {
            let cell:ReciverCell = tableView.dequeueReusableCell(withIdentifier: "reciverCell", for: indexPath) as! ReciverCell
            cell.setCellData(dict: message)
            if message.isRead == false {
                MessageHandler.Instace.readMessage(id: message.id)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    //MARK:- Message Recived Delegate
    func messageRecived(data: FirebaseMessage, tripId: String) {
        if let index = arrMessages.firstIndex(where: { (message) -> Bool in
            message.id == data.id
        }) {
            print(index)
        } else {
            arrMessages.append(data)
        }
        tblChat.reloadData()
        scrollToBottom()
    }

    func messageUpdated(data: FirebaseMessage, tripId: String) {
        if let index = arrMessages.firstIndex(where: { (message) -> Bool in
            message.id == data.id
        }) {
            arrMessages[index].isRead = true
        }
        tblChat.reloadData()
        scrollToBottom()
    }

    //MARK:- TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtMessage.text == "PLACE_HOLDER_ENTER_MESSAGE".localized {
            txtMessage.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if txtMessage.text == "" {
            txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
        }
    }

    func textViewDidChange(_ textView: UITextView) {}

    //MARK:- Tap Gesture Delegate
    @IBAction func onClickBtnMenu(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Button Click Method
    @IBAction func onClickBtnSend(_ sender: Any) {
        btnSend.isEnabled = false
        if !txtMessage.text.isEmpty() && txtMessage.text != "PLACE_HOLDER_ENTER_MESSAGE".localized {
            MessageHandler.Instace.sendMessage(text: txtMessage.text, time: Date().toString(withFormat: DateFormat.WEB, timeZone: "UTC"))
            PushNotificationSender().sendPushNotification(to: deviceToken, title: "Message", body: txtMessage.text ?? "")
            txtMessage.endEditing(true)
            txtMessage.text = "PLACE_HOLDER_ENTER_MESSAGE".localized
            if arrMessages.count > 0 {
                self.scrollToBottom()
            }
            btnSend.isEnabled = true
        } else {
            self.txtMessage.endEditing(true)
            btnSend.isEnabled = true
        }
    }

    @IBAction func onClickBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Firebase Login and Register Method
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.arrMessages).count - 1, section:0)
            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    //MARK:- Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}

    @IBAction func onClickBtnNavBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
