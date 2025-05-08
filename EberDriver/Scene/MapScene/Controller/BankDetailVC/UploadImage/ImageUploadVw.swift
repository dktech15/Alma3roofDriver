//
//  DocumentVw.swift
//  Eber Driver
//
//  Created by Ketan on 14/10/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import UIKit
import MobileCoreServices

class RootVw: UIView {
    var shadow: Shadow = Shadow()
}

class Shadow: NSObject {

    var enabled = true
    var path = CGRect.zero
    var offset = CGSize.zero
    var radius: CGFloat = 0.0
    var opacity: Float = 1.0
    var color = UIColor.black
    weak var vw: UIView?

    override init() {
        super.init()
    }

    init(toVw vw: UIView?) {
        super.init()
        self.vw = vw
    }

    func draw() {
        if self.enabled {
            self.show()
        }
        else {
            self.hide()
        }
    }

    func show() {
        if self.vw != nil {
            self.vw?.layer.shadowPath = UIBezierPath(rect: self.path).cgPath
            self.vw?.layer.shadowOffset = self.offset
            self.vw?.layer.shadowOpacity = self.opacity
            self.vw?.layer.shadowRadius = self.radius
            self.vw?.layer.shadowColor = self.color.cgColor
            self.vw?.layer.rasterizationScale = Common.screenScale
            self.vw?.clipsToBounds = false
        }
    }

    func hide() {
        self.vw?.layer.shadowOpacity = 0.0
        self.vw?.layer.shadowRadius = 0.0
    }

    func vwWillRotate() {
        self.vw?.layer.shadowPath = nil
        self.vw?.layer.shouldRasterize = true
    }

    func vwDidRotate() {
        self.draw()
        self.vw?.layer.shouldRasterize = false
    }
}

class RootPopUpVw: RootVw {

    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var hVwContent: NSLayoutConstraint!
    @IBOutlet weak var cyVwContent: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    var isHit: Bool = true

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.vwBg.backgroundColor = UIColor.black
        self.vwBg.alpha = Common.alphaVwBg
        let tG = UITapGestureRecognizer(target: self, action: #selector(self.vwBgTapped(_:)))
        self.vwBg.addGestureRecognizer(tG)
        self.vwContent.layer.cornerRadius = 10.0
    }

    /*override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
     let vw = super.hitTest(point, with: event)

     if self.isHit {
     if vw == self.vwBg {
     self.hide()
     }
     }

     return vw
     }*/

    @objc func vwBgTapped(_ tG: UITapGestureRecognizer) {
        if self.isHit && (tG.view == self.vwBg) {
            self.hide()
        }
    }

    func add(into supervw: UIView, _ isHit: Bool = true) {
        self.isHit = isHit
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        supervw.addSubview(self)

        var bottom: CGFloat = 0.0
        var top: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            bottom = Common.safeAreaInsets.bottom
            top = Common.safeAreaInsets.top
        } else {
            // Fallback on earlier versions
        }
        let vws: [String: Any] = ["self": self]
        var constraints: [String] = []
        constraints.append("H:|-0-[self]-0-|")
        constraints.append(String(format: "V:|-(%lf)-[self]-(%lf)-|", -top, -bottom))
        constraints.forEach { (constraintsStr: String) in
            var activateConstraints: [NSLayoutConstraint] = []
            var opts: NSLayoutConstraint.FormatOptions = []
            opts = [NSLayoutConstraint.FormatOptions(rawValue: 159)]
            activateConstraints += NSLayoutConstraint.constraints(withVisualFormat: constraintsStr,
                                                                  options: opts,
                                                                  metrics: nil,
                                                                  views: vws)
            NSLayoutConstraint.activate(activateConstraints)
        }
    }

    func show() {
        UIView.transition(with: self,
                          duration: Common.animationDuration,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.isHidden = false
                            self?.superview?.layoutIfNeeded()
        }) { [weak self] (bl: Bool) in
            guard let self = self else { return }

            if bl {
                print("\(self) \(#function)")
            }
        }
    }

    func hide() {
        self.endEditing(true)
        UIView.transition(with: self,
                          duration: Common.animationDuration,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.isHidden = true
                            self?.superview?.layoutIfNeeded()
        }) { [weak self] (bl: Bool) in
            guard let self = self else { return }
            if bl {
                print("\(self) \(#function)")
            }
        }
    }

    // MARK: - IBAction
    @IBAction func btnCloseTapped(_ btn: UIButton = UIButton()) {
        self.hide()
    }
}

class ImageUploadVw: RootPopUpVw, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var iVPhoto: UIImageView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!

    var imgDocument: ImageDocument = ImageDocument(imageName: "",image: UIImage())
    weak var vC: BankDetailVC!
    let imgPkrC = UIImagePickerController()
    var onImageSelected: ((UIImage?) -> Void)? = nil
    var imageSelected: UIImage? = nil
    var dialogForImage:CustomPhotoDialog?;

    //MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()

        self.imgPkrC.delegate = self
        self.imgPkrC.mediaTypes = [kUTTypeImage as String]
        self.imgPkrC.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        self.imgPkrC.allowsEditing = true

        let str: String = "DOCUMENT_ENTER_EXPIRY_DATE".localized+"*"
        let attrbStr = NSMutableAttributedString(string: str)
        let opt = String.EnumerationOptions.byComposedCharacterSequences

        str.enumerateSubstrings(in: str.startIndex..<str.endIndex, options: opt)
        { (substr, substrRange, _, _) in
            if substr == "*" {
                attrbStr.addAttribute(NSAttributedString.Key.foregroundColor, 
                                      value: UIColor.themeErrorTextColor,
                                      range: NSRange(substrRange, in: str))
            }
        }
        self.lblDocumentName.font = FontHelper.font(size: FontSize.medium, type: .Bold)
        self.lblDocumentName.textColor = UIColor.themeLightTextColor

        self.btnClose.setTitle("TXT_CANCEL".localized, for: .normal)
        self.btnClose.setTitleColor(UIColor.themeLightTextColor, for: UIControl.State.normal)
        self.btnClose.titleLabel?.font = FontHelper.font(type: FontType.Regular)

        self.btnSubmit.setTitle("TXT_SUBMIT".localized, for: .normal)
        self.btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnSubmit.titleLabel?.font = FontHelper.font(size: FontSize.medium, type: .Regular)
        self.btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        self.btnSubmit.setupButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - IBAction
    @IBAction func btnChooseTapped(_ btn: UIButton = UIButton()) {
//        self.vC?.present(self.imgPkrC, animated: true, completion: {})
        openImageDialog()
    }

    @IBAction func btnSubmitTapped(_ btn: UIButton = UIButton()) {
        self.endEditing(true)
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            if self.imageSelected == nil {
                Utility.showToast(message: "VALIDATION_MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            } else {
                self.onImageSelected?(self.imageSelected)
            }
        }
    }

    // MARK: - ImgPkrCDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {}
        guard let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageSelected = img
        self.iVPhoto.image = img
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }

    // MARK: -
    func reload(_ imgDocument: ImageDocument , _ vC: BankDetailVC) {
        self.imageSelected = imgDocument.image
        self.imgDocument = imgDocument
        self.vC = vC
        if imgDocument.image != nil {
            self.iVPhoto.image = imgDocument.image
        } else {
            self.iVPhoto.image = UIImage.init(named: "asset-add-bank-detail-image")
        }
        self.show()
    }

    func openImageDialog() {
        self.dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self.vC)
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
            self.imageSelected = image
            self.iVPhoto.image = image
            dialogForImage?.removeFromSuperview()
        }
    }
}
