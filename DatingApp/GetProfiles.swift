//
//  GetProfiles.swift
//  DatingApp
//
//  Created by ios-davi-4 on 06/12/17.
//  Copyright © 2017 AJ. All rights reserved.
//

import Foundation

class Category{
    
    var id:String?
    var lastRequestAmazon:String?
    var number:String?
    var parentCategoryId:String?
    var title:String?
    
    
    class func categoryDetailSaved(data:[String:Any]) -> Category{
        let categoryDetail = Category()
        
        categoryDetail.id = data["id"] as? String
        categoryDetail.lastRequestAmazon = data["lastRequestAmazon"] as? String
        categoryDetail.number = data["number"] as? String
        categoryDetail.parentCategoryId = data["parentCategoryId"] as? String
        categoryDetail.title = data["title"] as? String
        return categoryDetail
    }
    
}
