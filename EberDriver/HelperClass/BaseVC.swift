//
//  BaseVC.swift
//  Cabtown Use
//
//  Created by Elluminati iMac on 10/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import Alamofire

class BaseVC: UIViewController {
    
    //MARK: View life cycle
    deinit {
        print("\(self) \(#function)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if Bundle.main.bundleIdentifier == bundleId {
            addEdgePanGesture()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupNetworkReachability()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeLocationPermision), name: Common.locationPermisionChanged, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: APPDELEGATE.reachability)
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addEdgePanGesture() {
        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.userSwipedFromEdge(sender:)))
        edgeGestureRecognizer.edges = .right
        self.view.addGestureRecognizer(edgeGestureRecognizer)
    }
    
    func setupNetworkReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: APPDELEGATE.reachability)
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            self.networkEstablishAgain()
        }else {
            self.networklost()
        }
    }
    
    @objc func changeLocationPermision(_ ntf: Notification) {
        guard let userInfo = ntf.userInfo else { return }
        guard let status = userInfo[Common.locationKey] as? CLAuthorizationStatus else { return }
        print(status)
    }
    
    func networkEstablishAgain() {
        print("\(self.description) Network reachable")
    }
    
    func networklost() {
        print("\(self.description) Network not reachable")
    }
    
    func changed(_ language: Int) {
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        LocalizeLanguage.setAppleLanguageTo(lang: language)
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else {
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        Alamofire.Session.default.session.cancelTasks { [unowned self] in
            let appWindow: UIWindow? = APPDELEGATE.window
            var vC: UIViewController? = nil
            if ProviderSingleton.shared.tripId.isEmpty {
                vC = self.storyboard?.instantiateInitialViewController()
            } else {
                APPDELEGATE.gotoTrip()
            }
            
            appWindow?.removeFromSuperviewAndNCObserver()
            appWindow?.rootViewController?.removeFromParentAndNCObserver()
            appWindow?.rootViewController = vC
            appWindow?.makeKeyAndVisible()
            appWindow?.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            
            UIView.transition(with: appWindow ?? UIWindow(), 
                              duration: 0.5, 
                              options: transition, 
                              animations: { () -> Void in
            }) { (finished) -> Void in 
                appWindow?.backgroundColor = UIColor.clear
            }
        }
    }
    
    @objc func locationUpdate(_ ntf: Notification = Common.defaultNtf) {

    }

    @objc func locationFail(_ ntf: Notification = Common.defaultNtf) {

    }

    @objc func locationAuthorizationChanged(_ ntf: Notification = Common.defaultNtf) {
        
    }
    
    @objc func userSwipedFromEdge(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.edges == UIRectEdge.right {
            let dialog = DialogForApplicationMode.showCustomAppModeDialog()
            
            dialog.onClickLeftButton = { [unowned dialog] in
                dialog.removeFromSuperview()
            }
            
            dialog.onClickRightButton = { [unowned dialog] in
                dialog.removeFromSuperview()
            }
        }
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public class Model {
    deinit {
        print("\(self) \(#function)")
    }
}

public class ModelNSObj: NSObject {
    deinit {
        print("\(self) \(#function)")
    }
}

public class CustomDialog: UIView {
    deinit {
        print("\(self) \(#function)")
    }
}

public class TblVwCell: UITableViewCell {
    deinit {
        print("\(self) \(#function)")
    }
}

public class CltVwCell: UICollectionViewCell {
    deinit {
        print("\(self) \(#function)")
    }
}

typealias Completion = () -> Void

extension UIScrollView {
    
    var isWEqualToCW: Bool {
        return abs(ceil(self.frame.width)-ceil(self.contentSize.width)) <= 1.0
    }
    
    var isHEqualToCH: Bool {
        return abs(ceil(self.frame.height)-ceil(self.contentSize.height)) <= 1.0
    }
    
}

extension UITableView {
    
    func reloadData(_ completion: @escaping Completion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setNeedsLayout()
            self.superview?.setNeedsLayout()
            
            UIView.animate(withDuration: 0.0, 
                           animations: { [weak self] in
                            guard let self = self else { return }
                            self.reloadData()
                            self.layoutIfNeeded()
                            self.superview?.layoutIfNeeded()
                }, 
                           completion: { (Bool) in
                            DispatchQueue.main.async(execute: { 
                                completion()
                            })
            })
        }
    }
    
    func reloadData(hToFit cntrnt: NSLayoutConstraint, 
                    _ completion: @escaping Completion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentOffset = CGPoint.zero
            self.setNeedsLayout()
            self.superview?.setNeedsLayout()
            
            self.reloadData({ [weak self] in
                guard let self = self else { return }
                cntrnt.constant = self.contentSize.height
                self.layoutIfNeeded()
                self.superview?.layoutIfNeeded()
                
                if self.isHEqualToCH {
                    completion()
                } 
                else {
                    self.reloadData(hToFit: cntrnt, completion)
                }
            })
        }
    }
    
    func reloadData(hToFit completion: @escaping Completion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentOffset = CGPoint.zero
            
            self.reloadData({ [weak self] in
                guard let self = self else { return }
                self.frame.size.height = self.contentSize.height
                self.layoutIfNeeded()
                self.superview?.layoutIfNeeded()
                
                if self.isHEqualToCH {
                    completion()
                } 
                else {
                    self.reloadData(hToFit: completion)
                }
            })
        }
    }
    
    func deleteRows(at indexPaths: [IndexPath], 
                    with animation: UITableView.RowAnimation, 
                    _ completion: @escaping Completion) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.0, 
                           animations: { [weak self] in
                            guard let self = self else { return }
                            self.deleteRows(at: indexPaths, with: animation)
                            self.layoutIfNeeded()
                            self.superview?.layoutIfNeeded()
                }, 
                           completion: { (Bool) in
                            DispatchQueue.main.async(execute: { 
                                completion()
                            })
            })
        }
    }
    
}

extension UICollectionView {
    
    func reloadData(_ completion: @escaping Completion) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.0, 
                           animations: { [weak self] in
                            guard let self = self else { return }
                            self.reloadData()
                            self.layoutIfNeeded()
                            self.superview?.layoutIfNeeded()
                }, 
                           completion: { (Bool) in
                            DispatchQueue.main.async(execute: { 
                                completion()
                            })
            })
        }
    }
    
    func reloadData(wToFit cntrnt: NSLayoutConstraint, 
                    _ completion: @escaping Completion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentOffset = CGPoint.zero
            
            self.reloadData({ [weak self] in
                guard let self = self else { return }
                cntrnt.constant = self.contentSize.width
                self.layoutIfNeeded()
                self.superview?.layoutIfNeeded()
                
                if self.isWEqualToCW {
                    completion()
                } 
                else {
                    self.reloadData(wToFit: cntrnt, completion)
                }
            })
        }
    }
    
}

