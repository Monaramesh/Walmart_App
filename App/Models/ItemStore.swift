//
//  ItemStore.swift
//  App
//
//  Created by Mona Ramesh on 6/20/18.
//  Copyright © 2018 Mona Ramesh. All rights reserved.
//

import Foundation
import UIKit

struct ItemStore: Decodable{
    var items : [Item]
}

struct Item: Decodable{
    let itemId: Int?
    let name: String?
    let thumbnailImage: String?
    let salePrice: Float?
    let shortDescription: String?
    let customerRatingImage: String?
    let numReviews: Int?
    let stock: String?
}

struct ItemSearch: Decodable{
    var query: String?
    var items: [Item]
}


