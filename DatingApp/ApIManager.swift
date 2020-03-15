import UIKit
import Alamofire

class ApIManager: NSObject {
    
    // MARK: - Shared Instance
    
    static let sharedInstance: ApIManager = {
        let instance = ApIManager()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    // MARK: - All Api's Calls
    func signUpApi(userInfo:[String:AnyObject],completion: ((_ error:String,_ Authorization_key:String,_ success:Bool) -> Void)?){
        let url = Constants.baseUrl + Constants.signUp
        
        var parameters: [String: Any] = userInfo
        //        parameters["deivce_token"] = "43797be6dd544a240c6882d70332bb3243a463128ea59bf735b85c4bf6161979"
        print(parameters)
        if let deviceId = UserDefaults.standard.object(forKey: "DeviceToken") as? String{
            parameters["device_token"] = deviceId
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let value = json as? [String:Any]{
//                                let dict:[String:Any] = ["authorization_key":value["authorization_key"] ?? "","birthday":value["birthday"] ?? "","city":value["city"] ?? "","country":value["country"] ?? "","created":value["created"] ?? "","email":value["email"] ?? "","first_name":value["first_name"] ?? "","gender":value["gender"] ?? "","id":value["id"] ?? "","id_facebook":value["id_facebook"] ?? "","id_google":value["id_google"] ?? "","id_twitter":value["id_twitter"] ?? "","last_name":value["last_name"] ?? "","modified":value["modified"] ?? "","phone":value["phone"] ?? "","photo":value["photo"] ?? "","photo_facebook":value["photo_facebook"] ?? "","photo_google":value["photo_google"] ?? "","photo_twitter":value["photo_twitter"] ?? "","status":value["status"] ?? "","status_google":value["status_google"] ?? "","subscription_id":value["subscription_id"] ?? "","user_type":value["user_type"] ?? ""
                                let dict:[String:Any] = ["authorization_key":value["authorization_key"] ?? ""]
                                UserDefaults.standard.setValue(dict, forKey: "userInfo")
                                if let value = value["authorization_key"] as? String{
                                    completion!("",value, true)
                                }
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
                    else {
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let key = json as? [String:Any]{
                                if let value = key["message"] as? String{
                                    completion!(value,"", true)
                                }
                            }
                        } catch {
                        }
                    }
                    break
                case .failure(_):
                    completion!("","", false)
                    break
                }
        }
        
    }
    
    func verifyOtpApi(userInfo:[String:AnyObject],completion: ((_ success:Bool,_ error:String) -> Void)?){
        
        let url = Constants.baseUrl + Constants.varifyOtp
        
        var parameters: [String: Any] = userInfo
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if let deviceId = UserDefaults.standard.object(forKey: "DeviceToken") as? String{
            parameters["device_token"] = deviceId
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization-key":Authorization_key])
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    
                    if (response.response?.statusCode == 200){
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let value = json as? [String:Any]{
                                UserProfile.current.firstname = value["first_name"] as? String
                                UserProfile.current.lastname = value["last_name"] as? String
                                var userInfo = value["0"] as? [String:Any]
                                if let UserSubscription = value["UserSubscription"] as? [[String:Any]]{
                                    for items in UserSubscription{
                                        let subscriptionId = items["subscription_id"] as? String
                                        if (subscriptionId == "25"){
                                            userInfo!["backWardSubscription"] = subscriptionId
                                            userInfo!["backWardSubscriptionExpireDate"] = items["expire_time"] as? String
                                        }
                                        else {
                                            userInfo!["messageSubscription"] = subscriptionId
                                            userInfo!["messageSubscriptionExpireDate"] = items["expire_time"] as? String
                                        }
                                        
                                        let autoRenew = items["auto_renew"] as? String
                                        if (autoRenew == "1"){
                                            userInfo!["autoRenew"] = "1"
                                        }
                                        else {
                                            userInfo!["autoRenew"] = "0"
                                        }
                                        
                                    }
                                }
                                
                                
                                UserDefaults.standard.setValue(userInfo, forKey: "userInfo")
//                                let dict:[String:Any] = ["authorization_key":value["authorization_key"] ?? "","birthday":value["birthday"] ?? "","city":value["city"] ?? "","country":value["country"] ?? "","created":value["created"] ?? "","email":value["email"] ?? "","first_name":value["first_name"] ?? "","gender":value["gender"] ?? "","id":value["id"] ?? "","id_facebook":value["id_facebook"] ?? "","id_google":value["id_google"] ?? "","id_twitter":value["id_twitter"] ?? "","last_name":value["last_name"] ?? "","modified":value["modified"] ?? "","phone":value["phone"] ?? "","photo":value["photo"] ?? "","photo_facebook":value["photo_facebook"] ?? "","photo_google":value["photo_google"] ?? "","photo_twitter":value["photo_twitter"] ?? "","status":value["status"] ?? "","status_google":value["status_google"] ?? "","subscription_id":value["subscription_id"] ?? "","user_type":value["user_type"] ?? ""]
                                //UserDefaults.standard.setValue(dict, forKey: "userInfo")
                                //                                if let value = value["authorization_key"] as? String{
                                //                                    completion!("",value, true)
                                //                                }
                            }
                        } catch {
                        }
                        completion!(true,"")
                    }
                    else {
                        if let value = response.result.value {
                            let dic = response.result.value as? [String:Any]
                            let successMsg = dic!["message"] as! String
                            completion!(true,successMsg)
                        }
                        
                    }
                    break
                case .failure(_):
                    completion!(false,"")
                    break
                }
        }
        
    }
    
    func resendOtpApi(Authorization_key:String,completion: ((_ success:Bool) -> Void)?){
        let url = Constants.baseUrl + Constants.resendOtp
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization-key":Authorization_key])
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        completion!(true)
                    }
                    break
                case .failure(_):
                    completion!(false)
                    break
                }
        }
        
    }
    
    
    func forgotPasswordApi(email:String,completion: ((_ success:Bool,_ error:String) -> Void)?){
        let url = Constants.baseUrl + Constants.forgotPassword
        
        Alamofire.request(url, method: .post, parameters: ["email":email], encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let key = json as? [String:Any]{
                                if let value = key["Authorization-key"] as? String{
                                    UserDefaults.standard.setValue(value, forKey: "Authorization_key")
                                    completion!(true,"")
                                }
                            }
                        } catch {
                        }
                        
                    }
                    else {
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let key = json as? [String:Any]{
                                if let value = key["message"] as? String{
                                    completion!(true,value)
                                }
                            }
                        }
                        catch {
                        }
                    }
                    break
                case .failure(_):
                    completion!(false, "")
                    break
                }
        }
        
    }
    
    func changePasswordApi(password:String,completion: ((_ success:Bool) -> Void)?){
        let url = Constants.baseUrl + Constants.changePassword
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        Alamofire.request(url, method: .post, parameters: ["password":password], encoding: JSONEncoding.default, headers: ["Authorization-key":Authorization_key])
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        completion!(true)
                    }
                    break
                case .failure(_):
                    completion!(false)
                    break
                }
        }
        
    }
    
    
    
    func loginApi(userInfo:[String:AnyObject],completion: ((_ msg:String,_ success:Bool) -> Void)?){
        let url = Constants.baseUrl + Constants.login
        
        var parameters: [String: Any] = userInfo
        //         parameters["deivce_token"] = "43797be6dd544a240c6882d70332bb3243a463128ea59bf735b85c4bf6161979"
        if let deviceId = UserDefaults.standard.object(forKey: "DeviceToken") as? String{
            parameters["device_token"] = deviceId
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let value = json as? [String:AnyObject]{
                                let values = json["body"] as? [String:Any]
                                var userInfo = values!["0"] as? [String:Any]
                                UserProfile.current.firstname = userInfo!["first_name"] as? String
                                UserProfile.current.lastname = userInfo!["last_name"] as? String
//                                let dict:[String:AnyObject] = ["authorization_key":value["authorization_key"] as AnyObject,"birthday":value["birthday"] as AnyObject,"city":value["city"] as AnyObject,"country":value["country"] as AnyObject,"created":value["created"] as AnyObject,"email":value["email"] as AnyObject,"first_name":value["first_name"] as AnyObject,"gender":value["gender"] as AnyObject,"id":value["id"] as AnyObject,"id_facebook":value["id_facebook"] as AnyObject,"id_google":value["id_google"] as AnyObject,"id_twitter":value["id_twitter"] as AnyObject,"last_name":value["last_name"] as AnyObject,"modified":value["modified"] as AnyObject,"phone":value["phone"] as AnyObject,"photo":value["photo"] as AnyObject,"photo_facebook":value["photo_facebook"] as AnyObject,"photo_google":value["photo_google"] as AnyObject,"photo_twitter":value["photo_twitter"] as AnyObject,"status":value["status"] as AnyObject,"status_google":value["status_google"] as AnyObject,"subscription_id":value["subscription_id"] as AnyObject,"user_type":value["user_type"] as AnyObject,"seeking":value["seeking"] as AnyObject,"state":value["state"] as AnyObject,"height":value["height"] as AnyObject as AnyObject as AnyObject as AnyObject as AnyObject,"wight":value["wight"] as AnyObject,"skin":value["skin"] as AnyObject,"eyes":value["eyes"] as AnyObject,"children":value["children"] as AnyObject,"many":value["many"] as AnyObject,"religion":value["religion"] as AnyObject,"message_time":value["message_time"] as AnyObject,"message_limit":value["message_limit"] as AnyObject]
                                
                                if let UserSubscription = values!["UserSubscription"] as? [[String:Any]]{
                                 for items in UserSubscription{
                                     let subscriptionId = items["subscription_id"] as? String
                                      if (subscriptionId == "25"){
                                        userInfo!["backWardSubscription"] = subscriptionId
                                        userInfo!["backWardSubscriptionExpireDate"] = items["expire_time"] as? String
                                      }
                                    else {
                                        userInfo!["messageSubscription"] = subscriptionId
                                        userInfo!["messageSubscriptionExpireDate"] = items["expire_time"] as? String
                                    }
                                    
                                    let autoRenew = items["auto_renew"] as? String
                                    if (autoRenew == "1"){
                                        userInfo!["autoRenew"] = "1"
                                    }
                                    else {
                                        userInfo!["autoRenew"] = "0"
                                    }
                                    
                                  }
                                }
                                
                                
                                UserDefaults.standard.setValue(userInfo, forKey: "userInfo")
                                //print(dict)
                            }
                        } catch {
                        }
                        completion!("",true)
                    }
                    else {
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let key = json as? [String:Any]{
                                if let value = key["message"] as? String{
                                    completion!(value,true)
                                }
                            }
                        } catch {
                        }
                    }
                    break
                case .failure(_):
                    completion!((response.result.error?.localizedDescription)!,false)
                    break
                }
        }
        
    }
    
    
    func facebookLoginApi(userInfo:[String:AnyObject],completion: ((_ error:String,_ success:Bool) -> Void)?){
        let url = Constants.baseUrl + Constants.facebookLogin
        
        var parameters: [String: Any] = userInfo
        //        parameters["deivce_token"] = "43797be6dd544a240c6882d70332bb3243a463128ea59bf735b85c4bf6161979"
        if let deviceId = UserDefaults.standard.object(forKey: "DeviceToken") as? String{
            parameters["device_token"] = deviceId
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        do {
                            if let data = response.data,
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let value = json as? [String:AnyObject]{
                                var dict = value["0"] as? [String:AnyObject]
                                UserProfile.current.firstname = dict!["first_name"] as? String
                                UserProfile.current.lastname = dict!["last_name"] as? String
//                                let dict:[String:AnyObject] = ["authorization_key":value["authorization_key"] as AnyObject,"birthday":value["birthday"] as AnyObject,"city":value["city"] as AnyObject,"country":value["country"] as AnyObject,"created":value["created"] as AnyObject,"email":value["email"] as AnyObject,"first_name":value["first_name"] as AnyObject,"gender":value["gender"] as AnyObject,"id":value["id"] as AnyObject,"id_facebook":value["id_facebook"] as AnyObject,"id_google":value["id_google"] as AnyObject,"id_twitter":value["id_twitter"] as AnyObject,"last_name":value["last_name"] as AnyObject,"modified":value["modified"] as AnyObject,"phone":value["phone"] as AnyObject,"photo":value["photo"] as AnyObject,"photo_facebook":value["photo_facebook"] as AnyObject,"photo_google":value["photo_google"] as AnyObject,"photo_twitter":value["photo_twitter"] as AnyObject,"status":value["status"] as AnyObject,"status_google":value["status_google"] as AnyObject,"subscription_id":value["subscription_id"] as AnyObject,"user_type":value["user_type"] as AnyObject,"seeking":value["seeking"] as AnyObject,"state":value["state"] as AnyObject,"height":value["height"] as AnyObject as AnyObject as AnyObject as AnyObject as AnyObject,"wight":value["wight"] as AnyObject,"skin":value["skin"] as AnyObject,"eyes":value["eyes"] as AnyObject,"children":value["children"] as AnyObject]
                                if let UserSubscription = value["UserSubscription"] as? [[String:Any]]{
                                    for items in UserSubscription{
                                        let subscriptionId = items["subscription_id"] as? String
                                        if (subscriptionId == "25"){
                                            dict!["backWardSubscription"] = subscriptionId as AnyObject
                                            dict!["backWardSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                        }
                                        else {
                                            dict!["messageSubscription"] = subscriptionId as AnyObject
                                            dict!["messageSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                        }
                                        
                                        let autoRenew = items["auto_renew"] as? String
                                        if (autoRenew == "1"){
                                            dict!["autoRenew"] = "1" as AnyObject
                                        }
                                        else {
                                            dict!["autoRenew"] = "0" as AnyObject
                                        }
                                        
                                    }
                                }
                                    
                                    
                                    
                                UserDefaults.standard.setValue(value, forKey: "userInfo")
                                //print(dict)
                            }
                        } catch {
                        }
                        completion!("",true)
                    }
                    else {
                        completion!("",false)
                    }
                    break
                case .failure(_):
                    completion!((response.result.error?.localizedDescription)!,false)
                    break
                }
        }
        
    }
    
    func userInfoDetailApi(param:[String:Any],images:UIImage,auth_key:String,completion: ((_ success:Bool) -> Void)?) {
        
        let url = Constants.baseUrl + Constants.registration
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if  let imageData = UIImageJPEGRepresentation(images, 0.5) {
                let timeStamp = Date().timeIntervalSince1970 * 1000
                let fileName = "image\(timeStamp).png"
                multipartFormData.append(imageData, withName: "photo", fileName: fileName, mimeType: "image/jpeg")
            }
            
            for (key, value) in param {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to:url,method: .post,headers:["Authorization-key": auth_key])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if (response.response?.statusCode == 200){
                        do {
                            let json = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) as! String
                            print(json)
                            
                            
                            if let data = response.data,
                                
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let value = json["body"] as? [String:Any]{
                                var dict = value["0"] as? [String:AnyObject]
                                UserProfile.current.firstname = dict!["first_name"] as? String
                                UserProfile.current.lastname = dict!["last_name"] as? String
//                                let dict:[String:Any] = ["authorization_key":value["authorization_key"] ?? "","birthday":value["birthday"] ?? "","city":value["city"] ?? "","country":value["country"] ?? "","created":value["created"] ?? "","email":value["email"] ?? "","first_name":value["first_name"] ?? "","gender":value["gender"] ?? "","id":value["id"] ?? "","id_facebook":value["id_facebook"] ?? "","id_google":value["id_google"] ?? "","id_twitter":value["id_twitter"] ?? "","last_name":value["last_name"] ?? "","modified":value["modified"] ?? "","phone":value["phone"] ?? "","photo":value["photo"] ?? "","photo_facebook":value["photo_facebook"] ?? "","photo_google":value["photo_google"] ?? "","photo_twitter":value["photo_twitter"] ?? "","status":value["status"] ?? "","status_google":value["status_google"] ?? "","subscription_id":value["subscription_id"] ?? "","user_type":value["user_type"] ?? "","message_time":value["message_time"] ?? "","message_limit":value["message_limit"] ?? ""]
                                
                                if let UserSubscription = value["UserSubscription"] as? [[String:Any]]{
                                    for items in UserSubscription{
                                        let subscriptionId = items["subscription_id"] as? String
                                        if (subscriptionId == "25"){
                                            dict!["backWardSubscription"] = subscriptionId as AnyObject
                                            dict!["backWardSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                        }
                                        else {
                                            dict!["messageSubscription"] = subscriptionId as AnyObject
                                            dict!["messageSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                        }
                                        
                                        let autoRenew = items["auto_renew"] as? String
                                        if (autoRenew == "1"){
                                            dict!["autoRenew"] = "1" as AnyObject
                                        }
                                        else {
                                            dict!["autoRenew"] = "0" as AnyObject
                                        }
                                        
                                    }
                                }
                                
                                UserDefaults.standard.setValue(dict, forKey: "userInfo")
                               // print(dict)
                            }
                        } catch {
                        }
                        completion!(true)
                    }
                    else {
                        completion!(false)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                DispatchQueue.main.async {
                    completion!(false)
                }
            }
            
        }
        
    }
    
    
    func getuserInfo(auth_key:String,completion: ((_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.userInfo
        
        Alamofire.request(url, method: .get,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let value = json as? [String:AnyObject]{
                            var dict = value["0"] as? [String:AnyObject]
//                            let dict:[String:AnyObject] = ["authorization_key":value["authorization_key"] as AnyObject,"birthday":value["birthday"] as AnyObject,"city":value["city"] as AnyObject,"country":value["country"] as AnyObject,"created":value["created"] as AnyObject,"email":value["email"] as AnyObject,"first_name":value["first_name"] as AnyObject,"gender":value["gender"] as AnyObject,"id":value["id"] as AnyObject,"id_facebook":value["id_facebook"] as AnyObject,"id_google":value["id_google"] as AnyObject,"id_twitter":value["id_twitter"] as AnyObject,"last_name":value["last_name"] as AnyObject,"modified":value["modified"] as AnyObject,"phone":value["phone"] as AnyObject,"photo":value["photo"] as AnyObject,"photo_facebook":value["photo_facebook"] as AnyObject,"photo_google":value["photo_google"] as AnyObject,"photo_twitter":value["photo_twitter"] as AnyObject,"status":value["status"] as AnyObject,"status_google":value["status_google"] as AnyObject,"subscription_id":value["subscription_id"] as AnyObject,"user_type":value["user_type"] as AnyObject,"seeking":value["seeking"] as AnyObject,"state":value["state"] as AnyObject,"height":value["height"] as AnyObject as AnyObject as AnyObject as AnyObject as AnyObject,"wight":value["wight"] as AnyObject,"skin":value["skin"] as AnyObject,"eyes":value["eyes"] as AnyObject,"children":value["children"] as AnyObject,"many":value["many"] as AnyObject,"religion":value["religion"] as AnyObject,"comment":value["comment"] as AnyObject,"message_Time":value["message_time"] as AnyObject,"message_limit":value["message_limit"] as AnyObject]
                            
                            if let UserSubscription = value["UserSubscription"] as? [[String:Any]]{
                                for items in UserSubscription{
                                    let subscriptionId = items["subscription_id"] as? String
                                    if (subscriptionId == "25"){
                                        dict!["backWardSubscription"] = subscriptionId as AnyObject
                                        dict!["backWardSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                    }
                                    else {
                                        dict!["messageSubscription"] = subscriptionId as AnyObject
                                        dict!["messageSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                    }
                                    
                                    let autoRenew = items["auto_renew"] as? String
                                    if (autoRenew == "1"){
                                        dict!["autoRenew"] = "1" as AnyObject
                                    }
                                    else {
                                        dict!["autoRenew"] = "0" as AnyObject
                                    }
                                    
                                }
                            }
                            
                            
                            UserDefaults.standard.setValue(dict, forKey: "userInfo")
                            print(dict)
                        }
                    } catch {
                    }
                    
                    completion!(true);
                }
                
                break
                
            case .failure(_):
                completion!(false);
                break
                
            }
        }
    }
    
    
    func getProfileApi(gender:String,completion: ((_ value:[Profiles],_ error:String,_ success:Bool) -> Void)?){
        
        var profilesArr:[Profiles] = []
        let url = Constants.baseUrl + Constants.getProfiles + gender
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        Alamofire.request(url, method: .get,headers: ["Authorization-key":Authorization_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]{
                            print(json)
                            for profile in json{
                                let userInfo = profile["User"] as? [String:Any]
                                let value =  Profiles.ProfilesDetailSaved(data: userInfo!)
                                profilesArr.append(value)
                            }
                            
                        }} catch {
                    }
                    
                    completion!(profilesArr,"",true);
                }
                
                break
                
            case .failure(_):
                completion!(profilesArr,(response.result.error?.localizedDescription)!,false);
                break
                
            }
        }
        
    }
    
    func userLikeStatusApi(userInfo:[String:Any],completion: ((_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.likedislike
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        let parameters: [String: Any] = userInfo
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization-key":Authorization_key])
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        completion!(true)
                    }
                    break
                case .failure(_):
                    completion!(false)
                    break
                }
        }
    }
    
    func getFaqQusAns(completion: ((_ value:[faq],_ success:Bool) -> Void)?){
        
        var faqArr:[faq] = []
        let url = Constants.baseUrl + Constants.faq
        
        
        Alamofire.request(url, method: .get).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]{
                            print(json)
                            for faqAns in json{
                                let value =  faq.faqDetailSaved(data:faqAns)
                                faqArr.append(value)
                            }
                            
                        }} catch {
                    }
                    
                    completion!(faqArr,true);
                }
                
                break
                
            case .failure(_):
                completion!(faqArr,false);
                break
                
            }
        }
        
    }
    
    func getSubscriptionPlan(authKey:String,completion: ((_ value:[Subscription],_ success:Bool) -> Void)?){
        
        var subscriptionArr:[Subscription] = []
        let url = Constants.baseUrl + Constants.getSubscriptions
        
        Alamofire.request(url, method: .post,headers: ["Authorization-key":authKey]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]{
                            print(json)
                            for Subscrip in json{
                                let value =  Subscription.SubscriptionDetailSaved(data:Subscrip)
                                subscriptionArr.append(value)
                            }
                            
                        }} catch {
                    }
                    
                    completion!(subscriptionArr,true);
                }
                
                break
                
            case .failure(_):
                completion!(subscriptionArr,false);
                break
                
            }
        }
    }
    
    
    func buySubscriptionPlan(buyInfo:[String:Any],completion: ((_ error:String,_ values:[ [String:Any]],_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.buySubscriptions
        
        let parameters: [String: Any] = buyInfo
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        
        var valuesDic:[[String:Any]] = []
        
        Alamofire.request(url, method: .post,parameters: parameters,headers: ["Authorization-key":Authorization_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            print(json)
                            let msg = json["message"] as? String
                            if (msg == "successfully"){
                                
                                let values = json["UserSubscription"] as? [[String:Any]]
                                valuesDic = values!
                                
                                
                                completion!("",valuesDic,true);
                            }
                            else {
                                completion!(msg!,valuesDic,true);
                            }
                        }} catch {
                    }
                    
                    
                }
                
                break
                
            case .failure(_):
                completion!((response.result.error?.localizedDescription)!,valuesDic,false);
                break
                
            }
        }
    }
    
    
    
    
    
    
    func uploadUserDocumentApi(images:[String:UIImage],auth_key:String,completion: ((_ success:Bool) -> Void)?) {
        
        let url = Constants.baseUrl + Constants.upload_UserDoc
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in images {
                if  let imageData = UIImageJPEGRepresentation(value, 0.5) {
                    let timeStamp = Date().timeIntervalSince1970 * 1000
                    let fileName = "image\(timeStamp).png"
                    multipartFormData.append(imageData, withName: key, fileName: fileName, mimeType: "image/jpeg")
                }
                
            }
            
            //            for (key, value) in param {
            //
            //                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            //            }
            
        }, to:url,method: .post,headers:["Authorization-key": auth_key])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if (response.response?.statusCode == 200){
                        do {
                            let json = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) as! String
                            print(json)
                            
                            
                            if let data = response.data,
                                
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let valueStr = json["message"] as? String{
                                print(valueStr)
                                
                            }
                        } catch {
                        }
                        completion!(true)
                    }
                    else {
                        completion!(false)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                DispatchQueue.main.async {
                    completion!(false)
                }
            }
            
        }
        
    }
    
    
    func getAllNotifications(auth_key:String,completion: ((_ value:[Notifications],_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.getNotifications
        var notificationArr:[Notifications] = []
        Alamofire.request(url, method: .get,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]{
                        
                            for notifications in json{
                                let value =  Notifications.notificationsDetailSaved(data: notifications)
                                notificationArr.append(value)
                            }
                        }
                            
                            completion!(notificationArr,true);
                        
                    } catch {
                        completion!(notificationArr,false);
                    }
                    
                    
                }
                break
                
            case .failure(_):
                completion!(notificationArr,false);
                break
                
            }
        }
    }
    
    
    func getChatLists(auth_key:String,completion: ((_ value:[ChatLists],_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.getChatLists
        var chatlists:[ChatLists] = []
        Alamofire.request(url, method: .get,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                            let value = json as? [[String:Any]]{
                            print(value)
                            for chats in value{
                                let value =  ChatLists.ChatListsDetailSaved(data: chats)
                                chatlists.append(value)
                            }
                        }
                    } catch {
                    }
                    completion!(chatlists,true);
                }
                
                break
                
            case .failure(_):
                completion!(chatlists,false);
                break
                
            }
        }
        
    }
    
    
    
    func getAllChats(userInfo:[String:Any],completion: ((_ value:[Chats],_ friendPhoto:String,_ error:String,_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.getAllChat
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        let parameters: [String: Any] = userInfo
        var chatArr:[Chats] = []
        var friendPhoto = ""
        
        Alamofire.request(url, method: .post, parameters: parameters,headers: ["Authorization-key":Authorization_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            
                            let chats = json["chat"] as? [[String:Any]]
                            if (chats != nil){
                            for chat in chats!{
                                let value =  Chats.ChatsDetailSaved(data: chat)
                                chatArr.append(value)
                            }
                                let friendInfo = json["friend_info"] as? [String:Any]
                                friendPhoto = (friendInfo!["photo"] as? String)!
                            }
                            
                        }
                        
                        completion!(chatArr,friendPhoto,"",true);
                        
                    } catch {
                        completion!(chatArr,"","",false);
                    }
                    
                    
                }
                break
                
            case .failure(_):
                completion!(chatArr,"","",false);
                break
                
            }
        }
    }
    
    
    
    func sendChatMessages(chatInfo:[String:Any],completion: ((_ error:String,_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.sendChatMsgs
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        let parameters: [String: Any] = chatInfo
        
        Alamofire.request(url, method: .post, parameters: parameters,headers: ["Authorization-key":Authorization_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            print(json)
                            completion!("",true);
                        }
                        
                    } catch {
                        completion!("",false);
                    }
                    
                }
                break
                
            case .failure(_):
                completion!("",false);
                break
                
            }
        }
    }
    
    
    func sendChatImageApi(chatInfo:[String:Any],image:UIImage,completion: ((_ success:Bool) -> Void)?) {
        
        let url = Constants.baseUrl + Constants.sendChatMsgs
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
                if  let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    let timeStamp = Date().timeIntervalSince1970 * 1000
                    let fileName = "image\(timeStamp).png"
                    multipartFormData.append(imageData, withName: "message", fileName: fileName, mimeType: "image/jpeg")
                }
            
                for (key, value) in chatInfo {
            
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            
        }, to:url,method: .post,headers:["Authorization-key": Authorization_key])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if (response.response?.statusCode == 200){
                        do {
                            let json = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) as! String
                            print(json)
                            
                            if let data = response.data,
                                
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                let valueStr = json["message"] as? String{
                                print(valueStr)
                                
                            }
                        } catch {
                        }
                        completion!(true)
                    }
                    else {
                        completion!(false)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                DispatchQueue.main.async {
                    completion!(false)
                }
            }
            
        }
        
    }
    
    
    func getUserProfile(id:String,auth_key:String,completion: ((_ error:String,_ dic:[String:Any],_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.getUserProfle + id
        var userInfo:[String:Any] = [:]
        Alamofire.request(url, method: .get,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let value = json as? [String:Any]{
                            userInfo = value
                            print(value)
                        }
                    } catch {
                    }
                    completion!("",userInfo,true);
                }
                
                break
                
            case .failure(_):
                completion!("",userInfo,false);
                break
                
            }
        }
        
    }
    
    func deleteNotification(Id:String,auth_key:String,completion: ((_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.deleteNotification + Id
        
        Alamofire.request(url, method: .delete,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            if (response.response?.statusCode == 200){
                completion!(true)
            }
            else {
                completion!(false)
            }
        }
        
    }
    
    func messageBank(messageInfo:[String:Any],completion: ((_ error:String,_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.messageBank
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        let parameters: [String: Any] = messageInfo
        
        Alamofire.request(url, method: .post, parameters: parameters,headers: ["Authorization-key":Authorization_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                            print(json)
                            //UserDefaults.standard.setValue(json, forKey: "userInfo")
                            completion!("",true);
                        }
                        
                    } catch {
                        completion!("",false);
                    }
                    
                }
                break
                
            case .failure(_):
                completion!((response.result.error?.localizedDescription)!,false);
                break
                
            }
        }
    }
    
    func messageBankPosition(messageInfo:[String:Any],completion: ((_ error:String,_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.messaheBank1
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        let parameters: [String: Any] = messageInfo
        
        Alamofire.request(url, method: .post, parameters: parameters,headers: ["Authorization-key":Authorization_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let value = json as? [String:AnyObject]{
                            let body = value["body"] as? [String:Any]
                            print(json)
                            var userInfo = body!["0"] as? [String:Any]
                            
                            if let UserSubscription = body!["UserSubscription"] as? [[String:Any]]{
                                for items in UserSubscription{
                                    let subscriptionId = items["subscription_id"] as? String
                                    if (subscriptionId == "25"){
                                        userInfo!["backWardSubscription"] = subscriptionId as AnyObject
                                        userInfo!["backWardSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                    }
                                    else {
                                        userInfo!["messageSubscription"] = subscriptionId as AnyObject
                                        userInfo!["messageSubscriptionExpireDate"] = items["expire_time"] as AnyObject
                                    }
                                    
                                    let autoRenew = items["auto_renew"] as? String
                                    if (autoRenew == "1"){
                                        userInfo!["autoRenew"] = "1" as AnyObject
                                    }
                                    else {
                                        userInfo!["autoRenew"] = "0" as AnyObject
                                    }
                                    
                                }
                            }
                            
                            
                            
                            UserDefaults.standard.setValue(userInfo, forKey: "userInfo")
                            completion!("",true);
                        }
                        
                    } catch {
                        completion!("",false);
                    }
                    
                }
                break
                
            case .failure(_):
                completion!((response.result.error?.localizedDescription)!,false);
                break
                
            }
        }
    }
    
    
    func getCountryState(auth_key:String,completion: ((_ value:[Countrys],_ error:String,_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.getCountryState
         var countrysArr:[Countrys] = []
        Alamofire.request(url, method: .get,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    do {
                        if let data = response.data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
                            let value = json as? [[String:Any]]{
                            print(value)
                            for items in value{
                                let value = Countrys.CountrysDetailSaved(data: items)
                                countrysArr.append(value)
                            }
                            
                        }
                    } catch {
                    }
                    completion!(countrysArr,"",true);
                }
                
                break
                
            case .failure(_):
                completion!(countrysArr,(response.result.error?.localizedDescription)!,false);
                break
                
            }
        }
        
    }
    
    
    func blockUser(userInfo:[String:Any],completion: ((_ error:String,_ success:Bool) -> Void)?){
        let url = Constants.baseUrl + Constants.blockUser
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        let parameters: [String: Any] = userInfo
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization-key":Authorization_key])
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if (response.response?.statusCode == 200){
                        let value = response.result.value as? [String:Any]
                        if let key = value!["message"] as? String{
                            completion!(key,true)
                        }
                    }
                    if (response.response?.statusCode == 403){
                        let value = response.result.value as? [String:Any]
                        if let key = value!["message"] as? String{
                           completion!(key,true)
                        }
                        
                    }
                
                    break
                case .failure(_):
                    completion!("",false)
                    break
                }
        }
        
    }
    
    func deleteAccount(auth_key:String,completion: ((_ success:Bool) -> Void)?){
        
        let url = Constants.baseUrl + Constants.deleteAccount
        
        Alamofire.request(url, method: .delete,headers: ["Authorization-key":auth_key]).responseJSON { response  in
            if (response.response?.statusCode == 200){
                completion!(true)
            }
            else {
                completion!(false)
            }
        }
        
    }
    
}
