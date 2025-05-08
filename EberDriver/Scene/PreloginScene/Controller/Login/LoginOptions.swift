//
//  LoginOptions.swift
//  EberDriver
//
//  Created by elluminati on 08/08/23.
//  Copyright © 2023 Elluminati. All rights reserved.
//

import UIKit

protocol LoginOptionsDatasource: AnyObject {
   func setOptions(in view: LoginOptions) -> [String]
}

protocol LoginOptionsDelegate: AnyObject {
    func didSelectOption(at index: Int, text: String, loginOption: LoginOptions)
}

class LoginOptions: UIView {
        
    let colletionOption: UICollectionView = {
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        let colletionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return colletionView
    }()
    
    var delegate: LoginOptionsDelegate?
    var height: NSLayoutConstraint?
    
    var dataSource: LoginOptionsDatasource? {
        didSet {
            setUp()
        }
    }
    
    private var arrOptions = [String]()
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addColletionView()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
        guard let dataSource = dataSource else {
            return
        }
        arrOptions = dataSource.setOptions(in: self)
        colletionOption.showsVerticalScrollIndicator = false
        colletionOption.delegate = self
        colletionOption.dataSource = self
        colletionOption.register(OptionsCell.self, forCellWithReuseIdentifier: "OptionsCell")
        colletionOption.reloadData()
        colletionOption.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        colletionOption.contentInset = UIEdgeInsets.zero
    }
    
    func addColletionView() {
        self.addSubview(colletionOption)
        colletionOption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colletionOption.topAnchor.constraint(equalTo: self.topAnchor),
            colletionOption.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colletionOption.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colletionOption.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let height = height {
            height.constant = colletionOption.contentSize.height
        } else {
            height = NSLayoutConstraint(item: self as Any, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: colletionOption.contentSize.height)
            height?.isActive = true
        }
    }
    
    deinit {
        colletionOption.removeObserver(self, forKeyPath: "contentSize")
    }
}

extension LoginOptions: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as! OptionsCell
        let data = arrOptions[indexPath.row]
        cell.configCell(data: data)
        cell.selectedOption = selectedIndex == indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectOption(at: indexPath.row,text: arrOptions[indexPath.row] , loginOption: self)
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}

class OptionsCell: UICollectionViewCell {
    
    let lblOption: UILabel = {
        let label = UILabel()
        label.font = FontHelper.font(size: FontSize.small, type: FontType.Regular)
        label.textColor = .themeTextColor
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var selectedOption: Bool = false {
        didSet {
            if selectedOption {
                contentView.backgroundColor = .themeButtonBackgroundColor
                lblOption.textColor = .white
            } else {
                contentView.backgroundColor = .themeLightDividerColor
                lblOption.textColor = .white
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(lblOption)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.addSubview(lblOption)
        customInit()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let preferredSize = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let updatedAttributes = layoutAttributes
        updatedAttributes.size.width = preferredSize.width
        return updatedAttributes
    }
    
    func customInit() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        lblOption.translatesAutoresizingMaskIntoConstraints = false
        let spacing: CGFloat = 8
        NSLayoutConstraint.activate([
            lblOption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            lblOption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            lblOption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            lblOption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing)])
    }
    
    func configCell(data: String) {
        lblOption.text = data
    }
}
