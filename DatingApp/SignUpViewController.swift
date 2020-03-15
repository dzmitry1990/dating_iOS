//
//  SignUpViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 04/08/2019.
//  Copyright © 2019 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var otpMainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var nameTxtField: TextField!
    @IBOutlet var emailTxtField: TextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var phoneTxtField: TextField!
    @IBOutlet var passwordTxtField: TextField!
    @IBOutlet var confirmPasswordTxtField: TextField!
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var signInBtn: UIButton!
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var genderLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var passwordLbl: UILabel!
    @IBOutlet var confirmPasswordLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var age = "0"
    
    var genderArr = ["Male","Female"]
    var genderPickerView = UIPickerView()
    
    @IBOutlet var ageSwitchBtn: UISwitch!
    
    var checkBoxFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPickerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTxtField.setBottomBorder()
        emailTxtField.setBottomBorder()
        genderTextField.setBottomBorder()
        phoneTxtField.setBottomBorder()
        passwordTxtField.setBottomBorder()
        confirmPasswordTxtField.setBottomBorder()
        otpTextField.setBottomBorder()
        genderTextField.inputView = genderPickerView
    }
    
    //INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = signInBtn.frame.origin.y + signInBtn.frame.size.height + 15
    }
    
    //MARK: - IBACTIONS
    @IBAction func signInBtnPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        //Utilities.toasterView(msg: "Functionality Not Implemented")
        //Utilities.goBack(controller: self)
        
        if (nameTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Name", msg: "Please enter name.")
            
        }
        else if (emailTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Email", msg: "Please enter email.")
            
        }
        else if (phoneTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Phone No", msg: "Please enter phone no.")
            
        }
        else if (genderTextField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Gender", msg: "Please enter gender.")
            
        }
        else if (passwordTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Password", msg: "Please enter password.")
            
        }
        else if (confirmPasswordTxtField.text == ""){
            
            Utilities.alertView(controller: self, title: "Enter Confirm Password", msg: "Please enter confirm password.")
            
        }
        else if (confirmPasswordTxtField.text != passwordTxtField.text){
            
            Utilities.alertView(controller: self, title: "Enter Correct Password And Confirm Password", msg: "Password and confirm not match.")
        }
            
        else if (age == "0"){
            Utilities.alertView(controller: self, title: "Please Check", msg: "User age should be 18+")
        }
        else if (checkBoxFlag == false){
            Utilities.alertView(controller: self, title: "Check terms and condition", msg: "The user must click on a box next to “I agree to the terms and condition” and then must click on the “SignUp” button.")
        }
            
        else{
            
            let userDeatil:[String:AnyObject] = ["email":emailTxtField.text as AnyObject,"name":nameTxtField.text as AnyObject,"password":passwordTxtField.text as AnyObject,"phone":phoneTxtField.text as AnyObject,"gender":genderTextField.text as AnyObject]
            if (Reachability.isConnectedToNetwork()){
                callSignUpApi(userInfoDict:userDeatil)
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
            
        }
        
    }
    
    @IBAction func resendOtpBtnPressed(_ sender: Any) {
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
        if (otpTextField.text != ""){
            if (Reachability.isConnectedToNetwork()){
                callOtpApi(userInfo: ["otp":otpTextField.text as AnyObject])
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Enter Otp", msg: "Please enter Otp")
        }
    }
    
    @IBAction func crossOtpBtnPressed(_ sender: Any) {
        otpMainView.isHidden = true
    }
    
    @IBAction func ageSwitchBtnPressed(_ sender: Any) {
        if(ageSwitchBtn.isOn==true)
        {
            age = "1"
        }
        else{
            age = "0"
        }
    }
    
    @IBAction func checkBoxBtnPressed(_ sender: UIButton) {
        
        if (sender.isSelected == true){
            sender.isSelected = false
            checkBoxFlag = false
        }
        else {
            sender.isSelected = true
            checkBoxFlag = true
        }
    }
    
    @IBAction func termsAndConditionBtnPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        nextViewController.flag = 1
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK: - API CALLS
    func callSignUpApi(userInfoDict:[String:AnyObject]){
        Utilities.showProgressView(view: self.view)
        ApIManager.sharedInstance.signUpApi(userInfo: userInfoDict) { (error, Authorization_key,success) in
            Utilities.hideProgressView(view: self.view)
            if (success){
                if Authorization_key != ""{
                    UserDefaults.standard.setValue(Authorization_key, forKey: "Authorization_key")
                    //self.otpMainView.isHidden = false
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
                    self.navigationController?.pushViewController(vc!, animated: true)
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
    
    func callOtpApi(userInfo:[String:AnyObject]){
        
        if (otpTextField.text != ""){
            
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
    
    //MARK:- PICKERVIEW METHODS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return genderArr.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genderArr[row] as? String
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        genderTextField.text = genderArr[row] as? String
        genderTextField.setWithTextBottomBorder()
        
    }
    
    
    //MARK: - TEXTFIELD METHODS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
        if (textField == genderTextField){
            textField.tintColor = UIColor.clear
        }
        // scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        // scrollView.isScrollEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        if textField == nameTxtField {
            if resultString.characters.count == 0 {
                nameLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                nameLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        if textField == emailTxtField {
            if resultString.characters.count == 0 {
                emailLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                emailLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        if textField == genderTextField {
            if resultString.characters.count == 0 {
                genderLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                genderLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
        }
        if textField == phoneTxtField {
            if resultString.characters.count == 0 {
                phoneLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                phoneLbl.isHidden = false
                textField.setWithTextBottomBorder()
            }
            
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
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
        if textField == confirmPasswordTxtField {
            if resultString.characters.count == 0 {
                confirmPasswordLbl.isHidden = true
                textField.setBottomBorder()
            }else {
                confirmPasswordLbl.isHidden = false
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
