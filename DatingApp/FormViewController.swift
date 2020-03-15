//
//  FormViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 09/08/019.
//  Copyright © 2019 Dzmitry Zhuk All rights reserved.
//

import UIKit

class FormViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,hideMenu {

    @IBOutlet var mainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var uplaodBtn: UIButton!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var menuBtn: UIButton!
    var imagePicker = UIImagePickerController()
    var selectImageIndex = -1
    
    var driverProImage:UIImage?
    var paasPortProImage:UIImage?
    var ageProImage:UIImage?
    
    @IBOutlet var driverLicenseTxtField: UITextField!
    @IBOutlet var passportTxtField: UITextField!
    @IBOutlet var ageTxtField: UITextField!
    
    var PickerView = UIPickerView()
    var selectedPickerIndex = -1
    var valArr = ["Yes","No"]
    
    @IBOutlet var driverSelectedImgBtn: UIButton!
    @IBOutlet var passportSelectedImgBtn: UIButton!
    @IBOutlet var ageSelectedImgBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        PickerView.delegate = self
        driverSelectedImgBtn.isEnabled = false
        passportSelectedImgBtn.isEnabled = false
        ageSelectedImgBtn.isEnabled = false
       // saveBtn.isEnabled = false
    }
    
    //INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = saveBtn.frame.origin.y + saveBtn.frame.size.height + 15
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func driversSelectImageBtnPressed(_ sender: Any) {
         selectImageIndex = 0
         openImageFrame()
    }
    @IBAction func passportSelectImageBtnPressed(_ sender: Any) {
         selectImageIndex = 1
         openImageFrame()
    }
    @IBAction func ageSelectImageBtnPressed(_ sender: Any) {
         selectImageIndex = 2
         openImageFrame()
    }
    @IBAction func menuBtnPressed(_ sender: Any) {

        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.hideMenus = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    func hide() {
       menuBtn.isEnabled = true
    }
    
    func goNext(){
        UserDefaults.standard.setValue("1", forKey: "UserExist")
       // UserDefaults.standard.setValue("1", forKey: "Guild")
        let view: UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        self.view.window?.rootViewController = view
    }
    
    func openImageFrame(){
        
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        // self.presentViewController(pickerView, animated: true, completion: nil)
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        // photoPicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        
        var Authorization_key:String = ""
        var imagesArr:[String:UIImage] = [:]
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (driverProImage == nil && paasPortProImage == nil && ageProImage == nil){
            Utilities.alertView(controller: self, title: "", msg: "Please choose one document")
        }
        
        else {
        
        if (driverProImage != nil){
            imagesArr["driver_license"] = driverProImage
        }
        
        if (paasPortProImage != nil){
            imagesArr["passport_pic"] = paasPortProImage
        }
        
        if (ageProImage != nil){
            imagesArr["id_proof"] = ageProImage
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            
            ApIManager.sharedInstance.uploadUserDocumentApi(images: imagesArr, auth_key: Authorization_key, completion: { (success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    print("success")
                    
                    if (self.selectedPickerIndex == 0){
                        self.driverSelectedImgBtn.isEnabled = false
                        self.driverSelectedImgBtn.setTitle("file attached", for: .normal)
                    }
                    else if (self.selectedPickerIndex == 1){
                        self.passportSelectedImgBtn.isEnabled = false
                        self.passportSelectedImgBtn.setTitle("file attached", for: .normal)
                    }
                    else if (self.selectedPickerIndex == 2){
                        self.ageSelectedImgBtn.isEnabled = false
                        self.ageSelectedImgBtn.setTitle("file attached", for: .normal)
                    }
                    
                    Utilities.toasterView(msg: "Document Uploaded Successfully")
                    //self.goNext()
                    //self.saveBtn.isEnabled = true
                }
                else {
                    print("failer")
                }
            })
            
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        }
        
        
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        if (driverProImage == nil && paasPortProImage == nil && ageProImage == nil){
            Utilities.alertView(controller: self, title: "Please Upload", msg: "Please upload one document")
        }
        else {
        goNext()
        }
    }
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK:- TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == driverLicenseTxtField){
            selectedPickerIndex = 0
            driverLicenseTxtField.inputView = PickerView
        }
        else if (textField == passportTxtField){
            selectedPickerIndex = 1
            passportTxtField.inputView = PickerView
        }
        else if (textField == ageTxtField){
            selectedPickerIndex = 2
            ageTxtField.inputView = PickerView
        }
        print("begin")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == driverLicenseTxtField){
            if (textField.text == "Yes"){
                driverSelectedImgBtn.isEnabled = true
            }
            else {
                driverSelectedImgBtn.isEnabled = false
            }
        }
        else if (textField == passportTxtField){
            if (textField.text == "Yes"){
                passportSelectedImgBtn.isEnabled = true
            }
            else {
                passportSelectedImgBtn.isEnabled = false
            }
            
        }
        else if (textField == ageTxtField){
            if (textField.text == "Yes"){
                ageSelectedImgBtn.isEnabled = true
            }
            else {
                ageSelectedImgBtn.isEnabled = false
            }
            
        }
        print("end")
        
    }
    
    
    //MARK:- PICKERVIEW METHODS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return valArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return valArr[row] as? String
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (selectedPickerIndex == 0){
            driverLicenseTxtField.text = valArr[row]
            self.view.endEditing(true)
        }
        else if (selectedPickerIndex == 1){
            passportTxtField.text = valArr[row]
            self.view.endEditing(true)
        }
        else{
            ageTxtField.text = valArr[row]
            self.view.endEditing(true)
        }
        
    }
    
    //MARK: - IMAGEPICKER METHODS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print(image)
        
        if (selectImageIndex == 0){
            driverProImage = image
            driverLicenseTxtField.text = "Yes"
        }
        else if (selectImageIndex == 1){
            paasPortProImage = image
            passportTxtField.text = "Yes"
        }
        else {
            ageProImage = image
            ageTxtField.text = "Yes"
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"Cancel")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker
            
            , animated: true, completion: nil)
    }
    
    
    
}
