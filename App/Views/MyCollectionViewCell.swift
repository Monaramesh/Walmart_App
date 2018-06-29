//
//  MyCollectionViewCell.swift
//  App
//
//  Created by Mona Ramesh on 6/23/18.
//  Copyright © 2018 Mona Ramesh. All rights reserved.
//

import Foundation
import UIKit


//Collection Cell which is having a collection which in turn have cells of recommended products
class MyCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    private let cellId = "cellId"
    var recArray: [Item]?
    var item: Item?
    var id: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Recommended Products"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recColView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    func setUpViews(){
        self.backgroundColor = UIColor.green
        addSubview(recColView)
        addSubview(headerLabel)
        recColView.delegate = self
        recColView.dataSource = self
        recColView.register(NewCell.self, forCellWithReuseIdentifier: cellId)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":recColView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":recColView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":headerLabel]))
        headerLabel.bottomAnchor.constraint(equalTo: recColView.topAnchor, constant: 20)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if((recArray?.count)!<=10){
            return (recArray?.count)!
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recColView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewCell
        self.id = self.recArray?[indexPath.row].itemId
        cell.nameLabel.text = self.recArray?[indexPath.row].name
        let url_image = URL(string: (self.recArray?[indexPath.row].thumbnailImage!)!)
        cell.thumbnailImageView.downloadimageUsingcacheWithLink((self.recArray?[indexPath.row].thumbnailImage)!)
        cell.priceLabel.text = "$ \((self.recArray?[indexPath.row].salePrice)!)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2, height: frame.height-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(14, 14, 10, 14)
    }
    
    
}

//
class NewCell: UICollectionViewCell{
    var item: Item?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    //let imageCache=NSCache<NSString,AnyObject>()
    let seperatorLine : UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor.lightGray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    
    func setUpViews(){
        self.backgroundColor = UIColor.white
        addSubview(thumbnailImageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(seperatorLine)
        thumbnailImageView.leftAnchor.constraint(equalTo:  self.leftAnchor, constant: 10).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        thumbnailImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        
        seperatorLine.leftAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        seperatorLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        seperatorLine.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -15).isActive = true
        seperatorLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
