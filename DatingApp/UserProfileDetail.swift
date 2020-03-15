//
//  UserProfileDetail.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 07/12/19.
//  Copyright © 2019 AJ. All rights reserved.
//

import Foundation
import UIKit

class UserProfileDetail{
    
    var imagedata:NSData? = nil
    var first_name:String = ""
    var last_name:String = ""
    var age:String = ""
    var city:String = ""
    var state:String = ""
    var country:String = ""
    var gender:String = ""
    var maleSekking:String = ""
    var femaleSekking:String = ""
    var height:String = ""
    var weight:String = ""
    var skin:String = ""
    var eyes:String = ""
    var children:String = ""
    var childrenHowMany:String = ""
    
    class func UserProfileDetailSaved(data:[String:Any]) -> UserProfileDetail{
        let ProfilesDetail = UserProfileDetail()
        
        ProfilesDetail.imagedata = (data["imagedata"] as? NSData)!
        ProfilesDetail.first_name = (data["first_name"] as? String)!
        ProfilesDetail.last_name = (data["last_name"] as? String)!
        ProfilesDetail.age = (data["age"] as? String)!
        ProfilesDetail.city = (data["city"] as? String)!
        ProfilesDetail.state = (data["state"] as? String)!
        ProfilesDetail.country = (data["country"] as? String)!
        ProfilesDetail.gender = (data["gender"] as? String)!
        ProfilesDetail.maleSekking = (data["maleSekking"] as? String)!
        ProfilesDetail.femaleSekking = (data["femaleSekking"] as? String)!
        ProfilesDetail.height = (data["height"] as? String)!
        ProfilesDetail.weight = (data["weight"] as? String)!
        ProfilesDetail.skin = (data["skin"] as? String)!
        ProfilesDetail.eyes = (data["eyes"] as? String)!
        ProfilesDetail.children = (data["children"] as? String)!
        ProfilesDetail.childrenHowMany = (data["childrenHowMany"] as? String)!
        return ProfilesDetail
    }
    
}
