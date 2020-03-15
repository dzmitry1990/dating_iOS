//
//  OtpVC.swift
//  DatingApp
//
//  Created byDzmitry Zhuk on 04/06/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class OtpVC: UIViewController {
    
    @IBOutlet var emailTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTxtField.setBottomBorder()
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resendBtnPressed(_ sender: Any) {
        if (Reachability.isConnectedToNetwork()){
            if let Authorization_key = UserDefaults.standard.object(forKey: "Authorization_key") as? String{
                callResendOtpApi(Authorization_key: Authorization_key)
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if (emailTxtField.text != ""){
            if (Reachability.isConnectedToNetwork()){
                callOtpApi(userInfo: ["otp":emailTxtField.text as AnyObject])
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Enter Otp", msg: "Please enter Otp")
        }
    }
    
    
    //SEND OTP
    func callOtpApi(userInfo:[String:AnyObject]){
        
        if (emailTxtField.text != ""){
            
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.verifyOtpApi(userInfo: userInfo) { (success,error) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (error == ""){
                        self.goNext()
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Please Check", msg: error)
                    }
                }
                else {
                    Utilities.alertView(controller: self, title: "Try Aagin", msg: "Server Not Working")
                }
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Enter Otp", msg: "Please enter otp")
        }
    }
    
    //RESEND OTP
    func callResendOtpApi(Authorization_key:String){
        Utilities.showProgressView(view: self.view)
        
        ApIManager.sharedInstance.resendOtpApi(Authorization_key: Authorization_key) { (success) in
            
            Utilities.hideProgressView(view: self.view)
            
            if (success){
                Utilities.alertView(controller: self, title: "Please Check", msg: "Otp send to your email")
            }
            else {
                Utilities.alertView(controller: self, title: "Try Aagin", msg: "Server Not Working")
            }
        }
    }
    
    //MARK: FUNCTIONS
    func goNext(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
