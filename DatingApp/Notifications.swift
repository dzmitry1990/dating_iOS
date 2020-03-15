//
//  Notifications.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 22/12/19.
//  Copyright © 2019 AJ. All rights reserved.
//

import Foundation

class Notifications{
    
    var friend_id:String = ""
    var user_id:String = ""
    var id:String = ""
    var sender_id:String = ""
    var message:String = ""
    var read:String = ""
    var type:String = ""
    var photo:String = ""
    var age:String = ""
    var name:String = ""
    var created:String = ""
    var modified:String = ""
    
    
    class func notificationsDetailSaved(data:[String:Any]) -> Notifications{
        
        let notificationsDetail = Notifications()
        notificationsDetail.id = (data["id"] as? String)!
        notificationsDetail.user_id = (data["user_id"] as? String)!
        notificationsDetail.sender_id = (data["sender_id"] as? String)!
        notificationsDetail.message = (data["message"] as? String)!
        notificationsDetail.read = (data["read"] as? String)!
        notificationsDetail.type = (data["type"] as? String)!
        notificationsDetail.photo = (data["photo"] as? String)!
        notificationsDetail.age = (data["age"] as? String)!
        notificationsDetail.name = (data["name"] as? String)!
        notificationsDetail.created = (data["created"] as? String)!
        notificationsDetail.modified = (data["modified"] as? String)!
        //notificationsDetail.friend_id = (data["friend_id"] as? String)!
        
        return notificationsDetail
    }
    
}
