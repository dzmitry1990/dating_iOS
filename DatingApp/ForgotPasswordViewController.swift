//
//  ForgotPasswordViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhukon 21/11/17.
//  Copyright © 2017 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var otpView: UIView!
    @IBOutlet var otpTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.setBottomBorder()
        otpTextField.setBottomBorder()
    }
    
    //MARK: - IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        if (emailTextField.text != ""){
            
            if (Reachability.isConnectedToNetwork()){
                Utilities.showProgressView(view: self.view)
                ApIManager.sharedInstance.forgotPasswordApi(email: emailTextField.text!, completion: { (success,error) in
                    Utilities.hideProgressView(view: self.view)
                    if (success){
                        if (error == ""){
                        self.otpView.isHidden = false
                        }
                        else {
                         Utilities.alertView(controller: self, title: "Please Check", msg: error)
                        }
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Please Check", msg: "Please enter correct email")
                    }
                })
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
            
        }
        else {
            Utilities.alertView(controller: self, title: "Enter Email", msg: "Please enter email.")
        }
        
    }
    
    @IBAction func resendOtpBtnPressed(_ sender: Any) {
        Utilities.showProgressView(view: self.view)
        if let Authorization_key = UserDefaults.standard.object(forKey: "Authorization_key") as? String{
            
            if (Reachability.isConnectedToNetwork()){
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
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
        
    }
    @IBAction func otpVarifyBtnPressed(_ sender: Any) {
        
        if (otpTextField.text != ""){
            
            if (Reachability.isConnectedToNetwork()){
                Utilities.showProgressView(view: self.view)
                ApIManager.sharedInstance.verifyOtpApi(userInfo: ["otp":otpTextField.text as AnyObject]) { (success,error) in
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
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Enter Otp", msg: "Please enter otp")
        }
        
    }
    
    @IBAction func crossOtpBtnPressed(_ sender: Any) {
        otpView.isHidden = true
    }
    //MARK: - FUNCTIONS
    func goNext(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK: - TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        if textField == emailTextField {
            if resultString.characters.count == 0 {
                emailLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                emailLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        if textField == otpTextField {
            if resultString.characters.count == 0 {
                textField.setBottomBorder()
            }else {
                textField.setWithTextBottomBorder()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
