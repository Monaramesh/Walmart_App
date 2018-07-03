//
//  ViewController.swift
//  App
//
//  Created by Mona Ramesh on 6/20/18.
//  Copyright © 2018 Mona Ramesh. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func downloadimageUsingcacheWithLink(_ urlLink: String){
        self.image=nil
        if urlLink.isEmpty{
            return
        }
        if let cachedImage=imageCache.object(forKey: urlLink as NSString)as? UIImage{
            self.image=cachedImage
            return
        }
        let url=URL(string:urlLink)
        URLSession.shared.dataTask(with: url!,completionHandler:{(data,response,error) in
            if let err=error{
                print("The error is:",err)
                return
            }
            DispatchQueue.main.async {
                if let newImage=UIImage(data:data!){
                    
                    imageCache.setObject(newImage, forKey: urlLink as NSString)
                    self.image=newImage
                }
            }
        }).resume()
    }
}

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var addImage: UIImageView!
    
    var itemStore : ItemStore?
    var searchItems : ItemSearch?
    var filteredItems = [Item]()
    var passValue: Int!
    
    private let api=""
    private let prodSearchUrl = "http://api.walmartlabs.com/v1/search?apiKey="
    private let prodDetailUrl = "http://api.walmartlabs.com/v1/items/"
    
    var searchString:String = "general"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.isHidden = true
        addImage.isHidden = false
        
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func addNavBarImage(){
        let navController = navigationController!
        let image = #imageLiteral(resourceName: "navbarlogo.png")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: bannerHeight )
        imageView.contentMode = .scaleAspectFit
        navController.navigationBar.isTranslucent = true
        navigationItem.titleView = imageView
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.tintColor = .white
        navigationItem.searchController?.searchBar.barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Products", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        if let textfield = navigationItem.searchController?.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = searchItems?.items.count{
            if number <= 10{
            return number
            }
            else{
                return 10
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let item = searchItems?.items[indexPath.row]{
            let cell = self.tableview.dequeueReusableCell(withIdentifier: "mycell") as! ItemCell
            let nametap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
            let imgtap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
            
            //let url_image = URL(string: item.thumbnailImage!)
            if let image_string = item.thumbnailImage{
            //let url_image = URL(string: image_string)
            cell.imageview.downloadimageUsingcacheWithLink(image_string)
            //(image_string)
            }
            else{
                cell.imageview.image = #imageLiteral(resourceName: "noimage.png")
            }
            //cell.imageview.downloadedFrom(url: url_image!)
            cell.nameLabel.isUserInteractionEnabled = true
            cell.imageview.isUserInteractionEnabled = true
            cell.nameLabel.text = item.name
            if let price = item.salePrice{
                cell.priceLabel.text = "$ \(price)"
            }
            else{
                cell.priceLabel.text = " "
            }
            //cell.priceLabel.text = "$\(String(describing: item.salePrice!))"
            //downloadImage(item.thumbnailImage)
            cell.nameLabel.addGestureRecognizer(nametap)
            cell.imageview.addGestureRecognizer(imgtap)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(searchItems?.items[indexPath.row].name!)
            let id = searchItems?.items[indexPath.row].itemId
            self.passValue = id
            //performSegue(withIdentifier: "segue", sender: self)
        }
    
    
    @objc func tapFunction(sender: UITapGestureRecognizer){
        let tapLoc = sender.location(in: self.tableview)
        let index = self.tableview.indexPathForRow(at: tapLoc)
        let item = searchItems?.items[(index?.row)!]
        self.passValue = item?.itemId
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Item Details"
         navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = .white
        let viewcontroller = segue.destination as! DetailsViewController
        viewcontroller.passedValue = self.passValue
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.text!
        searchString = searchString.replacingOccurrences(of: " ", with: "")
        getProducts{
            if (self.searchItems?.items.count)! > 0{
                self.tableview.isHidden = false
                self.addImage.isHidden = true
                self.tableview.reloadData()
            }else{
                self.tableview.isHidden = true
                
            }
        }
    }
    
    
    
    func getProducts(completed: @escaping () -> ()){
        guard let searchUrl = URL(string: "\(prodSearchUrl)\(api)&query=\(searchString)") else { return }
        print(searchUrl)
        URLSession.shared.dataTask(with: searchUrl){(data, response, err) in
            if err == nil{
                //Check JSON downloaded data
                
                guard let jsondata = data else { return }
                do{
                    self.searchItems = try JSONDecoder().decode(ItemSearch.self, from: jsondata)
                    self.searchItems?.query = self.searchString
                    print(self.searchItems)
                    DispatchQueue.main.async{
                        completed()
                    }
                }
                catch let jsoonErr{
                    print(jsoonErr)
                }
            }
            }.resume()
        
    }
}

