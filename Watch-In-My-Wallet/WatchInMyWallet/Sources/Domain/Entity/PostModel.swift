//
//  Model.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//
import UIKit

public struct Category {
    let id: Int
    let categoryName: String
//    let categoryImage: UIImage?
}
//struct Account {
//    let id: Int
//    let currency: String
//}

public struct DateSet {
    let id: Int
    let setType: String
}

public struct Post {
    let id, amount: Int
    let dateSetID, categoryID: Int
    let title, memo, account, date: String
}
