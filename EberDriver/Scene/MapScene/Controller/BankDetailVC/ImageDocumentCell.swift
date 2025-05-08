//
//  DocumentCell.swift
//  HyrydeDriver
//
//  Created by Mac Pro5 on 14/10/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import UIKit

class ImageDocumentCell: UITableViewCell {
    
    @IBOutlet weak var lblNm: UILabel!
    @IBOutlet weak var yLblNm: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btn: UIButton!
    var document: ImageDocument!
    var didSelect: ((_ document: ImageDocument) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblNm.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        self.lblNm.textColor = UIColor.themeTextColor
        self.lblTitle.font = FontHelper.font(size: FontSize.regular, type: FontType.Regular)
        self.lblTitle.textColor = UIColor.themeTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setData(_ document: ImageDocument, _ idxPath: IndexPath) {
        self.document = document
        self.lblNm.text = document.imageName
        if self.document.image == nil {
            self.lblTitle.text = "DOCUMENT_UPLOADED".localized
        }
        else {
            self.lblTitle.text = "DOCUMENT_VIEW".localized
        }
    }
    // MARK: - IBAction
    @IBAction func btnTapped(_ btn: UIButton) {
        self.didSelect?(self.document)
    }
}
