//
//  GetProfiles.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 06/12/19.
//  Copyright © 2019 AJ. All rights reserved.
//

import Foundation

class Profiles{
    
    var id:String = ""
    var first_name:String = ""
    var last_name:String = ""
    var email:String = ""
    var password:String = ""
    var gender:String = ""
    var phone:String = ""
    var city:String = ""
    var country:String = ""
    var birthday:String = ""
    var ip_address:String = ""
    var photo:String = ""
    var status:String = ""
    var email_verified:String = ""
    var phone_verified:String = ""
    var status_facebook:String = ""
    var photo_facebook:String = ""
    var authorization_key:String = ""
    var id_facebook:String = ""
    var id_twitter:String = ""
    var status_twitter:String = ""
    var photo_twitter:String = ""
    var id_google:String = ""
    var status_google:String = ""
    var photo_google:String = ""
    var forgot_password_hash:String = ""
    var remember_me_hash:String = ""
    var language_id:String = ""
    var otp:String = ""
    var newsletter_subscription:String?
    var subscription_id:String = ""
    var created:String = ""
    var modified:String = ""
    var name:String = ""
    
    
    class func ProfilesDetailSaved(data:[String:Any]) -> Profiles{
        
        let ProfilesDetail = Profiles()
        ProfilesDetail.id = (data["id"] as? String)!
        ProfilesDetail.first_name = (data["first_name"] as? String)!
        ProfilesDetail.last_name = (data["last_name"] as? String)!
        ProfilesDetail.email = (data["email"] as? String)!
        ProfilesDetail.password = (data["password"] as? String)!
        ProfilesDetail.gender = (data["gender"] as? String)!
        
        if (ProfilesDetail.gender == "1"){
            ProfilesDetail.gender = "Male"
        }
        else {
            ProfilesDetail.gender = "Female"
        }
        
        ProfilesDetail.phone = (data["phone"] as? String)!
        ProfilesDetail.city = (data["city"] as? String)!
        ProfilesDetail.country = (data["country"] as? String)!
        ProfilesDetail.birthday = (data["birthday"] as? String)!
        
        if ProfilesDetail.birthday == "0" {
            ProfilesDetail.birthday = ""
        }
        
        ProfilesDetail.ip_address = (data["ip_address"] as? String)!
        ProfilesDetail.photo = (data["photo"] as? String)!
        ProfilesDetail.status = (data["status"] as? String)!
        ProfilesDetail.email_verified = (data["email_verified"] as? String)!
        ProfilesDetail.phone_verified = (data["phone_verified"] as? String)!
        ProfilesDetail.status_facebook = (data["status_facebook"] as? String)!
        ProfilesDetail.photo_facebook = (data["photo_facebook"] as? String)!
        ProfilesDetail.authorization_key = (data["authorization_key"] as? String)!
        ProfilesDetail.id_facebook = (data["id_facebook"] as? String)!
        ProfilesDetail.id_twitter = (data["id_twitter"] as? String)!
        ProfilesDetail.status_twitter = (data["status_twitter"] as? String)!
        ProfilesDetail.photo_twitter = (data["photo_twitter"] as? String)!
        ProfilesDetail.id_google = (data["id_google"] as? String)!
        ProfilesDetail.status_google = (data["status_google"] as? String)!
        ProfilesDetail.photo_google = (data["photo_google"] as? String)!
        ProfilesDetail.forgot_password_hash = (data["forgot_password_hash"] as? String)!
        ProfilesDetail.remember_me_hash = (data["remember_me_hash"] as? String)!
        ProfilesDetail.language_id = (data["language_id"] as? String)!
        ProfilesDetail.otp = (data["otp"] as? String)!
        ProfilesDetail.newsletter_subscription = data["newsletter_subscription"] as? String
        ProfilesDetail.subscription_id = (data["subscription_id"] as? String)!
        ProfilesDetail.created = (data["created"] as? String)!
        ProfilesDetail.modified = (data["modified"] as? String)!
        ProfilesDetail.name = (data["first_name"] as? String)! + " " +  (data["last_name"] as? String)!
        
        return ProfilesDetail
    }
    
}
