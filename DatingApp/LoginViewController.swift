//
//  ViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 04/08/2019.
//  Copyright © 2019 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import MBProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var userNameTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var passwordLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var checkBox = false
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.swipeItems = []
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTxtField.setBottomBorder()
        passwordTxtField.setBottomBorder()
    }
    
    //INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = signUpBtn.frame.origin.y + signUpBtn.frame.size.height + 30
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func forgotBtnPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if (userNameTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Email", msg: "Please enter Email.")
            
        }
        else if (passwordTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Password", msg: "Please enter password.")
            
        }
        else if (checkBox == false){
            Utilities.alertView(controller: self, title: "Check terms and condition", msg: "The user must click on a box next to “I agree to the terms and condition” and then must click on the “Login” button.")
        }
        else {
            
            let dict:[String:AnyObject] = ["email":userNameTxtField.text as AnyObject,"password":passwordTxtField.text as AnyObject]
             if (Reachability.isConnectedToNetwork()){
               loginApi(userInfo: dict)
            }
             else {
              Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
        
        
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        //Utilities.toasterView(msg: "Functionality Not Implemented")
        
        if (Reachability.isConnectedToNetwork()){
            
            Utilities.showProgressView(view: self.view)
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.loginBehavior = .native
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            let fbAccessToken = FBSDKAccessToken.current().tokenString
                            UserProfile.current.accessToken = fbAccessToken
                            self.getFBUserData()
                            fbLoginManager.logOut()
                        }
                        else {
                            Utilities.hideProgressView(view: self.view)
                            Utilities.alertView(controller: self, title: "Try Again", msg: "Please try again")
                        }
                    }
                    else {
                        Utilities.hideProgressView(view: self.view)
                    }
                }
                else {
                    Utilities.hideProgressView(view: self.view)
                }
            }
            
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    @IBAction func checkBtnPressed(_ sender: UIButton) {
        if (sender.isSelected == true){
            sender.isSelected = false
            checkBox = false
        }
        else {
            sender.isSelected = true
            checkBox = true
        }
    }
    
    @IBAction func termsConditionBtnPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        nextViewController.flag = 1
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK: - TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
        scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        scrollView.isScrollEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        if textField == userNameTxtField {
            if resultString.characters.count == 0 {
                userNameLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                userNameLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        if textField == passwordTxtField {
            if resultString.characters.count == 0 {
                passwordLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                passwordLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - FUNSTIONS
    // FACEBOOK LOGIN
    //fetch User Information
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    
                    if let id = dict["id"]{
                        
                        var UserDetail:[String:AnyObject] = [:]
                        
                        UserDetail["id_facebook"] = id as AnyObject
                        
                        if let name = dict["name"]{
                            
                            UserDetail["name"] = name as AnyObject
                        }
                        
                        if let email = dict["email"]{
                            
                            UserDetail["email"] = email as AnyObject
                        }
                        if let email = dict["gender"]{
                            
                            UserDetail["gender"] = email as AnyObject
                        }
                        
                        if let userImg = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String{
                            UserDetail["photo_facebook"] = userImg as AnyObject
                        }
                
                        // self.goForward()
                        if (Reachability.isConnectedToNetwork()){
                            //call Facebook Login Api
                            self.facebookLoginApi(userDetails: UserDetail)
                        }
                        else{
                            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
                        }
                        
                    }
                    
                }
                else {
                    Utilities.alertView(controller: self, title: "Alert", msg: (error?.localizedDescription)!)
                    Utilities.hideProgressView(view: self.view)
                }
                
                
            })
        }
    }
    
    
    
    func goNext(){
        
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            if let status = userInfo["status"] as? String{
                
                if (status == "1"){
                UserDefaults.standard.setValue("1", forKey: "UserExist")
                let view: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self.view.window?.rootViewController = view
                }
                    
                else {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
            else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        
        
    }
    
    func goNext1(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK: API CALLING
    func loginApi(userInfo:[String:AnyObject]){
        
        Utilities.showProgressView(view: self.view)
        ApIManager.sharedInstance.loginApi(userInfo: userInfo) { (msg,success) in
            Utilities.hideProgressView(view: self.view)
            if (success){
                
                if (msg == ""){
                  self.goNext()
                }
                else {
                    Utilities.alertView(controller: self, title: "Please Check", msg: msg)
                }
            }
            else {
                Utilities.alertView(controller: self, title: "Try Aagin", msg: msg)
            }
        }
    }
    
    func facebookLoginApi(userDetails:[String:AnyObject]){
        
        ApIManager.sharedInstance.facebookLoginApi(userInfo: userDetails) { (error,success) in
            Utilities.hideProgressView(view: self.view)
            if (success){
                self.goNext1()
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: error)
            }
        }
        
    }
    
}

