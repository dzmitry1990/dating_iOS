//
//  UserProfile.swift
//  Amazon
//
//  Created by Dzmitry Zhuk on 22/06/2019 Saka.
//  Copyright © 2019 Dzmitry Zhuk. All rights reserved.
//

import Foundation

class UserProfile: NSObject {
    lazy var userInfo : [String:AnyObject]=[:]
    
    static let current = UserProfile()
    
    var firstname:String?{
        get{
            return userInfo["firstname"] as? String
        }
        set{
            userInfo["firstname"] = newValue as AnyObject?
        }
    }
    
    var lastname:String?{
        get{
            return userInfo["lastname"] as? String
        }
        set{
            userInfo["lastname"] = newValue as AnyObject?
            
        }
    }
    
    var age:String?{
        get{
            return userInfo["age"] as? String
        }
        set{
            userInfo["age"] = newValue as AnyObject?
        }
    }
    
    var city:String?{
        get{
            return userInfo["city"] as? String
        }
        set{
            userInfo["city"] = newValue as AnyObject?
            
        }
    }
    
    var state:String?{
        get{
            return userInfo["state"] as? String
        }
        set{
            userInfo["state"] = newValue as AnyObject?
        }
    }
    
    var country:String?{
        get{
            return userInfo["country"] as? String
        }
        set{
            userInfo["country"] = newValue as AnyObject?
        }
    }
    
    var gender:String?{
        get{
            return userInfo["gender"] as? String
        }
        set{
            userInfo["gender"] = newValue as AnyObject?
        }
    }
    
    
    var seeking:String? {
        get{
            return userInfo["seeking"] as? String
        }
        set{
            userInfo["seeking"] = newValue as AnyObject?
        }
    }
    
    var height:String? {
        get{
            return userInfo["height"] as? String
        }
        set{
            userInfo["height"] = newValue as AnyObject?
        }
    }
    
    var weight:String? {
        get{
            return userInfo["weight"] as? String
        }
        set{
            userInfo["weight"] = newValue as AnyObject?
        }
    }
    
    var skin:String? {
        get{
            return userInfo["skin"] as? String
        }
        set{
            userInfo["skin"] = newValue as AnyObject?
        }
    }
    
    var eyes:String? {
        get{
            return userInfo["eyes"] as? String
        }
        set{
            userInfo["eyes"] = newValue as AnyObject?
        }
    }
    
    var childern:String? {
        get{
            return userInfo["childern"] as? String
        }
        set{
            userInfo["childern"] = newValue as AnyObject?
        }
    }
    
    var many:String? {
        get{
            return userInfo["many"] as? String
        }
        set{
            userInfo["many"] = newValue as AnyObject?
        }
    }
    
    var religion:String? {
        get{
            return userInfo["religion"] as? String
        }
        set{
            userInfo["religion"] = newValue as AnyObject?
        }
    }
    
    var comment:String? {
        get{
            return userInfo["comment"] as? String
        }
        set{
            userInfo["comment"] = newValue as AnyObject?
        }
    }
    var accessToken:String? {
        get{
            return userInfo["accessToken"] as? String
        }
        set{
            userInfo["accessToken"] = newValue as AnyObject?
        }
    }
    
}
