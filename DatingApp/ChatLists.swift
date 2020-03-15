//
//  ChatLists.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 23/01/18.
//  Copyright © 2018 AJ. All rights reserved.
//

import Foundation

class ChatLists{
    
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
    var friend_age:String = ""
    var friend_photo:String = ""
    var friend_name:String = ""
    
    
    class func ChatListsDetailSaved(data:[String:Any]) -> ChatLists{
        
        let ChatsDetail = ChatLists()
        ChatsDetail.id = (data["id"] as? String)!
        ChatsDetail.constant_id = (data["constant_id"] as? String)!
        ChatsDetail.friend_id = (data["friend_id"] as? String)!
        ChatsDetail.message = (data["message"] as? String)!
        ChatsDetail.read = (data["read"] as? String)!
        ChatsDetail.message_type = (data["message_type"] as? String)!
        ChatsDetail.sender_id = (data["sender_id"] as? String)!
        ChatsDetail.thumb_img = (data["thumb_img"] as? String)!
        ChatsDetail.created = (data["created"] as? String)!
        ChatsDetail.modified = (data["modified"] as? String)!
        let age = data["friend_age"] as? String
        if (age != nil){
           ChatsDetail.friend_age = (data["friend_age"] as? String)!
        }
        else {
            ChatsDetail.friend_age = ""
        }
        
        let photo = data["friend_photo"] as? String
        if (photo != nil){
            ChatsDetail.friend_photo = (data["friend_photo"] as? String)!
        }
        else {
            ChatsDetail.friend_photo = ""
        }
        
        //ChatsDetail.friend_photo = (data["friend_photo"] as? String)!
        ChatsDetail.friend_name = (data["friend_name"] as? String)!
        
        //ChatsDetail.photo = (data["photo"] as? String)!
        return ChatsDetail
    }
    
}
