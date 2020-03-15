//
//  ChangePasswordViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 21/11/17.
//  Copyright © 2017 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var newPasswordLbl: UILabel!
    @IBOutlet var confirmPasswordLbl: UILabel!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newPasswordTextField.setBottomBorder()
        confirmPasswordTextField.setBottomBorder()
    }
    
    
    //MARK:- IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        
        if (newPasswordTextField.text == ""){
            Utilities.alertView(controller: self, title: "Enter New Password", msg: "Please enter new password")
        }
        else if(confirmPasswordTextField.text == ""){
            Utilities.alertView(controller: self, title: "Enter New Confirm Password", msg: "Please enter confirm password")
        }
        else {
            if (Reachability.isConnectedToNetwork()){
                callNewPasswordApi(password: newPasswordTextField.text!)
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
    }
    
    //MARK:- FUNCTIONS
    func goNext(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func callNewPasswordApi(password:String){
        
        Utilities.showProgressView(view: self.view)
        ApIManager.sharedInstance.changePasswordApi(password: password) { (success) in
            if (success){
                self.goNext()
            }
            else {
                Utilities.alertView(controller: self, title: "Try Again", msg: "Server not working")
            }
        }
        
    }
    
    
    
    //MARK:- TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        if textField == newPasswordTextField {
            if resultString.characters.count == 0 {
                newPasswordLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                newPasswordLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        
        if textField == confirmPasswordTextField {
            if resultString.characters.count == 0 {
                confirmPasswordLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                confirmPasswordLbl.isHidden = false
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
