//
//  Chats.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 22/01/18.
//  Copyright © 2018 AJ. All rights reserved.
//

import Foundation
class Chats{
    
    var constant_id:String = ""
    var id:String = ""
    var friend_id:String = ""
    var message:String = ""
    var read:String = ""
    var message_type:String = ""
    var sender_id:String = ""
    var thumb_img:String = ""
    var is_send:String = ""
    var created:String = ""
    var modified:String = ""
    var photo:String = ""
    
    
    class func ChatsDetailSaved(data:[String:Any]) -> Chats{
        
        let ChatsDetail = Chats()
        ChatsDetail.id = (data["id"] as? String)!
        ChatsDetail.constant_id = (data["constant_id"] as? String)!
        ChatsDetail.friend_id = (data["friend_id"] as? String)!
        ChatsDetail.message = (data["message"] as? String)!
        ChatsDetail.read = (data["read"] as? String)!
        ChatsDetail.message_type = (data["message_type"] as? String)!
        ChatsDetail.sender_id = (data["sender_id"] as? String)!
        ChatsDetail.thumb_img = (data["thumb_img"] as? String)!

        let is_send = data["is_send"] as! Int
        
        ChatsDetail.is_send = String(is_send)
        ChatsDetail.created = (data["created"] as? String)!
        ChatsDetail.modified = (data["modified"] as? String)!
        return ChatsDetail
    }
    
}
