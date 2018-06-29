//
//  CollectionViewController.swift
//  App
//
//  Created by Mona Ramesh on 6/24/18.
//  Copyright © 2018 Mona Ramesh. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var recArray: [Item]?
    var itemId: Int!
    
    private let cellId = "cellId"
    var appColView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        view.backgroundColor = .white
        
        appColView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        appColView.delegate = self
        appColView.dataSource = self
        appColView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        appColView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appColView)
        print(itemId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = appColView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyCollectionViewCell
        cell.recArray = self.recArray
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! DetailsViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
}
