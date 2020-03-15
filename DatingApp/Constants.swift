//
//  Constants.swift
//  Amazon
//
//  Created by AJ on 21/06/1939 Saka.
//  Copyright © 1939 Saka AJ. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    
    //MARK: - CUSTOM ARRAY'S
//    static let menuArray:[String] = ["My Profile","My Payment","My Messages","Suggestions","Subscription","Message bank Setup","My Identification","Help","Log Out"]
    
    static let menuArray:[String] = ["My Profile","My Messages","Suggestions","Subscription","Message Bank And Location Setup","Help","Log Out"]
    
    static let menuImgArray:[UIImage] = [UIImage(named: "person")!,UIImage(named: "message")!,UIImage(named: "suggestion")!,UIImage(named: "suggestion")!,UIImage(named: "payment")!,UIImage(named: "faq")!,UIImage(named: "log_out")!]
    
    
    //MARK: - SCREEN SIZES
    static let screenSize = UIScreen.main.bounds.size.width
    static let iphone5s:CGFloat = 320
    
    
    //MARK: - STAGING URL
    //static let baseUrl = "http://202.164.42.226/dev/dating-folder/"
    
    
    //MARK: - PRODUCTION URL
    static let baseUrl = "http://13.211.58.29/dating/"
    
    
    //MARK:- SUBCRIPTION PLANS
    static let oneMonthAutoRenew = "com.app.Mydate.AutoRenewing.1Month"
    static let threeMonthAutoRenew = "com.app.Mydate.AutoRenewing.3Month"
    static let sixMonthAutoRenew = "com.app.Mydate.AutoRenewing.6Month"
    static let tweleveMonthAutoRenew = "com.app.Mydate.AutoRenewing.12Month"
    static let fiveYearAutoRenew = "com.app.Mydate.AutoRenewing.5Year"
    static let oneMonthNonRenew = "com.app.Mydate.NonRenewing.1Month"
    static let threeMonthNonRenew = "com.app.Mydate.NonRenewing.3Month"
    static let sixMonthNonRenew = "com.app.Mydate.NonRenewing.6Month"
    static let tweleveMonthNonRenew = "com.app.Mydate.NonRenewing.12Month"
    static let fiveYearNonRenew = "com.app.Mydate.NonRenewing.5Year"
    static let backWard = "com.app.Mydate.LifeTimeSubscription"
    
    static let subscriptions = [Constants.oneMonthNonRenew,threeMonthAutoRenew,sixMonthAutoRenew,tweleveMonthAutoRenew,fiveYearAutoRenew,oneMonthNonRenew,threeMonthNonRenew,sixMonthNonRenew,tweleveMonthNonRenew,fiveYearNonRenew,backWard]
    
    //MARK: - API URLS
    static let signUp = "users/signup_user"
    static let varifyOtp = "users/verify_otp"
    static let resendOtp = "users/resend_otp"
    static let forgotPassword = "users/forgot_password"
    static let changePassword = "users/chnage_password"
    static let login = "users/login"
    static let facebookLogin = "/users/login_with_facebook" 
    static let registration = "users/signup_user_second"
    static let getProfiles = "users/get_all_users?gender="
    static let likedislike = "users/do_like"
    static let userInfo = "users/get_infomation"
    static let getNotifications = "users/get_all_notification"
    static let faq = "users/faq"
    static let upload_UserDoc = "users/upload_doc"
    static let getSubscriptions = "subscriptions/get_plan"
    static let buySubscriptions = "subscriptions/buy_plan"
    static let question = "question/"
    static let answer = "answer"
    static let flag = "flag"
    static let result = "result/"
    static let swipe = "swipe"
    static let userDetail = "user/"
    static let item = "item/"
    static let privacy = "privacy"
    static let getChatLists = "users/last_chat"
    static let getAllChat = "users/get_message"
    static let sendChatMsgs = "users/send_message"
    static let getUserProfle = "users/get_profile?friend_id="
    static let deleteNotification = "users/delete_notification?id="
    static let messageBank = "users/chat_setting"
    static let messaheBank1 = "users/signup_user_second"
    static let getCountryState = "users/api_countries_states"
    static let blockUser = "users/block_user"
    static let deleteAccount = "users/delete_profile"
    
}
