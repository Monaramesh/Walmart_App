//
//  DetailsViewController.swift
//  App
//
//  Created by Mona Ramesh on 6/20/18.
//  Copyright © 2018 Mona Ramesh. All rights reserved.
//

import Foundation
import UIKit


class DetailsViewController: UIViewController{
    
    //To show details of selected product
    let containerView = UIView()
    let lookupView = UIView()
    
    //To show recommended list
    let containerView2 = UIView()
    let collectionView = CollectionViewController()
    
    var item: Item?
    var recProducts = [Item]()
    private let api=""
    private let prodDetailUrl = "http://api.walmartlabs.com/v1/items/"
    private let recommendUrl = "http://api.walmartlabs.com/v1/nbp?apiKey="
    
    //Details view labels
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()
    let descView: UITextView = {
        let tview = UITextView()
        tview.translatesAutoresizingMaskIntoConstraints = false
        tview.isEditable = false
        return tview
    }()
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    let imageCache=NSCache<NSString,AnyObject>()
    let cusRatingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    let numReviews: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        return label
    }()
    
    var passedValue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView.itemId = self.passedValue
        getDetails(){
            self.setUpDetailsView()
            print("Detail successful")
        }
        getRecommendations(){
            self.setUpRecommendedViews()
            print("Recommendations Successful")
        }
    }
    
    func getDetails(completed: @escaping () -> ()){
        guard let searchUrl = URL(string: "\(prodDetailUrl)\(self.passedValue!)?apiKey=\(api)&format=json") else { return }
        URLSession.shared.dataTask(with: searchUrl){(data, response, err) in
            guard let data = data else { return }
            do{
                self.item = try JSONDecoder().decode(Item.self, from: data)
                DispatchQueue.main.async{
                    completed()
                }
            }
            catch let jsoonErr{
                print(jsoonErr)
            }
            }.resume()
    }
    
    func getRecommendations(completed: @escaping () -> ()){
        guard let searchUrl = URL(string: "\(recommendUrl)\(api)&itemId=\(self.passedValue!)") else { return }
        URLSession.shared.dataTask(with: searchUrl){(data, response, err) in
            guard let data = data else { return }
            do{
                self.recProducts = try JSONDecoder().decode([Item].self, from: data)
                self.collectionView.recArray = self.recProducts
                DispatchQueue.main.async{
                    completed()
                }
            }
            catch let jsoonErr{
                print(jsoonErr)
            }
            }.resume()
    }
    
    
    func setUpDetailsView(){
        //Adding details container
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier:0.6).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        //adding labels and images in details subview
        containerView.addSubview(lookupView)
        lookupView.translatesAutoresizingMaskIntoConstraints = false
        lookupView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        lookupView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        lookupView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        lookupView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    
        lookupView.addSubview(nameLabel)
        lookupView.addSubview(priceLabel)
        lookupView.addSubview(descView)
        lookupView.addSubview(thumbnailImageView)
        lookupView.addSubview(cusRatingImage)
        lookupView.addSubview(numReviews)
        lookupView.addSubview(stockLabel)
        
        thumbnailImageView.leftAnchor.constraint(equalTo: lookupView.leftAnchor, constant: 10).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: lookupView.topAnchor, constant: 10).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: lookupView.widthAnchor, multiplier: 0.4).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        if let image_string = self.item?.thumbnailImage{
        //let url_image = URL(string: image_string)
        thumbnailImageView.downloadimageUsingcacheWithLink(image_string)
        }
        else{
            thumbnailImageView.image = #imageLiteral(resourceName: "noimage.png")
        }
        
        nameLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: lookupView.rightAnchor, constant: -10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: lookupView.topAnchor, constant: 10).isActive = true
        nameLabel.text = self.item?.name
        nameLabel.sizeToFit()
        
        priceLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 10).isActive = true
        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: lookupView.rightAnchor, constant: -10).isActive = true
        if let price = self.item?.salePrice{
            priceLabel.text = "$ \(price)"
        }
        else{
            priceLabel.text = " "
        }
        
        cusRatingImage.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 1).isActive = true
        cusRatingImage.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10).isActive = true
        cusRatingImage.widthAnchor.constraint(equalTo: lookupView.widthAnchor, multiplier: 0.3).isActive = true
        cusRatingImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        if let urlstring = self.item?.customerRatingImage{
            cusRatingImage.downloadimageUsingcacheWithLink(urlstring)
        }
        else{
            cusRatingImage.backgroundColor = UIColor.gray
        }
       
        numReviews.leftAnchor.constraint(equalTo: cusRatingImage.rightAnchor, constant: 5).isActive = true
        numReviews.rightAnchor.constraint(equalTo: lookupView.rightAnchor, constant: -5).isActive = true
        numReviews.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10).isActive = true
        if let rev = self.item?.numReviews{
        numReviews.text = "\(rev) reviews"
        }
        else{
            numReviews.text = "No reviews"
        }
        numReviews.textAlignment = .left
        
        stockLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 10).isActive = true
        stockLabel.rightAnchor.constraint(equalTo: lookupView.rightAnchor, constant: -10).isActive = true
        stockLabel.topAnchor.constraint(equalTo: numReviews.bottomAnchor, constant: 10).isActive = true
        if let stock = self.item?.stock{
        stockLabel.text = "Stock: \(stock)"
        }
        else{
            stockLabel.text = "Stock: "
        }
        
        descView.leftAnchor.constraint(equalTo: lookupView.leftAnchor, constant: 10).isActive = true
        descView.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 5).isActive = true
        descView.rightAnchor.constraint(equalTo: lookupView.rightAnchor, constant: -10).isActive = true
        descView.bottomAnchor.constraint(equalTo: lookupView.bottomAnchor, constant: -5).isActive = true
        if let desc = self.item?.shortDescription{
        descView.text = "DESCRIPTION: \(desc)"
        }
        else{
            descView.text = "DESCRIPTION: \(nameLabel.text)"
        }
    }
    
    func setUpRecommendedViews(){
        //Adding recommendations container
        view.addSubview(containerView2)
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        containerView2.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier:0.4).isActive = true
        containerView2.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        containerView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        containerView2.addSubview(collectionView.view)
        collectionView.view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.view.widthAnchor.constraint(equalTo: containerView2.widthAnchor).isActive = true
        collectionView.view.heightAnchor.constraint(equalTo: containerView2.heightAnchor).isActive = true
        collectionView.view.centerXAnchor.constraint(equalTo: containerView2.centerXAnchor).isActive = true
        collectionView.view.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor).isActive = true
    }
}
