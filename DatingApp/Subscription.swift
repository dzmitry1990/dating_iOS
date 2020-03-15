//
//  Subscription.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 21/12/19.
//  Copyright © 2019 AJ. All rights reserved.
//

import Foundation

class Subscription{
    
    var status:String = ""
    var modified:String = ""
    var id:String = ""
    var created:String = ""
    var plan_day:String = ""
    var time_period:String = ""
    var type:String = ""
    var price:String = ""
    
    
    class func SubscriptionDetailSaved(data:[String:Any]) -> Subscription{
        
        let subscriptionDetail = Subscription()
        subscriptionDetail.id = (data["id"] as? String)!
        subscriptionDetail.modified = (data["modified"] as? String)!
        subscriptionDetail.status = (data["status"] as? String)!
        subscriptionDetail.created = (data["created"] as? String)!
        subscriptionDetail.plan_day = (data["plan_day"] as? String)!
        subscriptionDetail.time_period = (data["time_period"] as? String)!
        subscriptionDetail.type = (data["type"] as? String)!
        subscriptionDetail.price = (data["price"] as? String)!
        
        return subscriptionDetail
    }
    
}
