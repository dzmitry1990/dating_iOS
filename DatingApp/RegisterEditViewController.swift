//
//  RegisterEditViewController.swift
//  DatingApp
//
//  Created by Dzmitry Zhuk on 23/02/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RegisterEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var submitBtn: UIButton!
    
    @IBOutlet var howMany: UITextField!
    @IBOutlet var firstNameTxtField: UITextField!
    @IBOutlet var lastNameTxtField: UITextField!
    @IBOutlet var ageTxtField: UITextField!
    @IBOutlet var cityTxtField: UITextField!
    @IBOutlet var stateTxtField: UITextField!
    @IBOutlet var countryTxtField: UITextField!
    @IBOutlet var maleSeekingTxtField: UITextField!
    @IBOutlet var femaleSeekingTxtField: UITextField!
    @IBOutlet var heightTxtField: UITextField!
    @IBOutlet var weightTxtField: UITextField!
    @IBOutlet var skinTxtField: UITextField!
    @IBOutlet var eyesTxtField: UITextField!
    @IBOutlet var religionTxtField: UITextField!
    
    @IBOutlet var aboutUsTextView: UITextView!
    @IBOutlet var maleBtn: UIButton!
    @IBOutlet var femaleBtn: UIButton!
    @IBOutlet var childrenYesBtn: UIButton!
    @IBOutlet var childrenNoBtn: UIButton!
    @IBOutlet var profileImgView: UIImageView!
    
    
    @IBOutlet var maleSekkingBtn: UIButton!
    @IBOutlet var femaleSekkingBtn: UIButton!
    var gender:String = ""
    var childrenVal:String = "0"
    var seeking:String = ""
    var imagePicker = UIImagePickerController()
    var profileImg:UIImage? = nil
    var imagesArr:[UIImage] = []
    var backButtonFlag = false
    var imagePick = false
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    @IBOutlet var backBtn: UIButton!
    var countrysArr:[Countrys] = []
    var statesArr:[States] = []
    var countryPickerView = UIPickerView()
    var statePickerView = UIPickerView()
    var selectedPickerIndex = -1
    
    var currentLatitude = ""
    var currentLongitude = ""
    var countryId = ""
    var stateId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        firstNameTxtField.text = UserProfile.current.firstname
        lastNameTxtField.text =  UserProfile.current.lastname
        nameLbl.text = firstNameTxtField.text! + " " +  lastNameTxtField.text!
        
        countryPickerView.delegate = self
        statePickerView.delegate = self
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location
            //print(currentLocation.coordinate.latitude)
            //print(currentLocation.coordinate.longitude)
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //SHOW CURRENT LAT & LONG
        determineMyCurrentLocation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if (backButtonFlag == true){
            backBtn.isHidden = false
            if (imagePick == true){
            }
            else {
                self.userInfo()
            }
        }
        else {
            backBtn.isHidden = true
        }
        
        
        firstNameTxtField.setColorBottomBorder()
        lastNameTxtField.setColorBottomBorder()
        ageTxtField.setColorBottomBorder()
        cityTxtField.setColorBottomBorder()
        stateTxtField.setColorBottomBorder()
        countryTxtField.setColorBottomBorder()
        maleSeekingTxtField.setColorBottomBorder()
        femaleSeekingTxtField.setColorBottomBorder()
        heightTxtField.setColorBottomBorder()
        weightTxtField.setColorBottomBorder()
        skinTxtField.setColorBottomBorder()
        eyesTxtField.setColorBottomBorder()
        religionTxtField.setColorBottomBorder()
        
        getCountryStates()
        
    }
    
    //COUNTRYS&STATES
    func getCountryStates(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            if let authKey = userInfo["authorization_key"] as? String{
                Authorization_key = authKey
            }
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getCountryState(auth_key: Authorization_key) { (values, error, success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (values.count > 0){
                        self.countrysArr = values
                        let country = self.countrysArr.filter({$0.country_id == self.countryId})
                        print(country)
                        if (country.count > 0){
                            self.countryTxtField.text = country[0].country_name
                            let states = country[0].states
                            let state = states.filter({$0.id == self.stateId})
                            if (states.count > 0){
                                self.stateTxtField.text = state[0].state_name
                            }
                        }
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Please Check", msg: error)
                    }
                }
                else {
                    Utilities.alertView(controller: self, title: "Please Check", msg: error)
                }
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
    }
    
    //INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = submitBtn.frame.origin.y + submitBtn.frame.size.height + 30
    }
    
    //MARK: MAPVIEW FUNCTIONS
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        currentLatitude = String(userLocation.coordinate.latitude)
        currentLongitude = String(userLocation.coordinate.longitude)
        print("user longitude = \(userLocation.coordinate.longitude)")
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //MARK: - IBACTIONS
    @IBAction func submitBtnPressed(_ sender: Any) {
        if (profileImg == nil){
            Utilities.alertView(controller: self, title: "Upload Photo", msg: "Please upload photo.")
        }
        else if (ageTxtField.text == ""){
            Utilities.alertView(controller: self, title: "Enter Age", msg: "Please enter age.")
        }
        else if (countryTxtField.text == ""){
            Utilities.alertView(controller: self, title: "Select Country", msg: "Please select country.")
        }
        else if (stateTxtField.text == ""){
            Utilities.alertView(controller: self, title: "Select State", msg: "Please select state.")
        }
        else if (cityTxtField.text == ""){
            Utilities.alertView(controller: self, title: "Select City", msg: "Please select city.")
        }
        else if (gender == ""){
            Utilities.alertView(controller: self, title: "Select Gender", msg: "Please select gender.")
        }
        else if (seeking == ""){
            Utilities.alertView(controller: self, title: "Select Sekking", msg: "Please select sekking.")
        }
        else if (childrenVal == "1" && howMany.text == ""){
            Utilities.alertView(controller: self, title: "Enter Children", msg: "Please enter no of childrens.")
        }
        else if (currentLatitude == "" && currentLongitude == ""){
            checkMyCurrentLocation()
        }
            
        else {
            saveUserInfo()
        }
        
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func selectedImgBtnPressed(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        imagePick = true
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
    
    @IBAction func femaleBtnPressed(_ sender: Any) {
        femaleBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        maleBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        gender = "2"
    }
    
    @IBAction func maleBtnPressed(_ sender: Any) {
        maleBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        femaleBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        gender = "1"
        
    }
    
    @IBAction func childrenYesBtnPressed(_ sender: Any) {
        childrenYesBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        childrenNoBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        childrenVal = "1"
        UserProfile.current.childern = "1"
        
    }
    
    @IBAction func childrenNoBtnPressed(_ sender: Any) {
        childrenNoBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        childrenYesBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        childrenVal = "2"
        UserProfile.current.childern = "2"
        
    }
    @IBAction func maleSekkingBtnPressed(_ sender: Any) {
        maleSekkingBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        femaleSekkingBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        seeking = "1"
    }
    @IBAction func femaleSekkingBtnPressed(_ sender: Any) {
        femaleSekkingBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        maleSekkingBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        seeking = "2"
    }
    @IBAction func menuBtnPressed(_ sender: Any) {
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
    
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    //MARK: - IMAGEPICKER METHODS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImg = image
        profileImgView.image = image
        imagesArr.append(image)
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
    
    //MARK:- PICKERVIEW METHODS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (selectedPickerIndex == 0){
            return countrysArr.count
        }
        else {
            return statesArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (selectedPickerIndex == 0){
            return countrysArr[row].country_name as? String
        }
        else {
            return statesArr[row].state_name as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (selectedPickerIndex == 0){
            statesArr = countrysArr[row].states
            countryTxtField.text = countrysArr[row].country_name
            countryId = countrysArr[row].country_id!
        }
        else  {
            stateTxtField.text = statesArr[row].state_name
            stateId = statesArr[row].id!
        }
        
    }
    
    
    //MARK: - TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == countryTxtField){
            selectedPickerIndex = 0
            countryTxtField.inputView = countryPickerView
        }
        else if (textField == stateTxtField){
            if (statesArr.count == 0){
                Utilities.alertView(controller: self, title: "", msg: "Please select the country first")
            }
            else {
                selectedPickerIndex = 1
                stateTxtField.inputView = statePickerView
            }
        }
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        let text: NSString = (textField.text ?? "") as NSString
    //        let resultString = text.replacingCharacters(in: range, with: string)
    //
    //        return true
    //    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:- TEXTFEILD METHODS
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("begin")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        if (textField == firstNameTxtField){
        //            UserProfile.current.firstname = textField.text
        //        }
        //        else if (textField == lastNameTxtField){
        //            UserProfile.current.lastname = textField.text
        //        }
        //        else if (textField == ageTxtField){
        //            UserProfile.current.age = textField.text
        //        }
        //        else if (textField == cityTxtField){
        //            UserProfile.current.city = textField.text
        //        }
        //        else if (textField == stateTxtField){
        //            UserProfile.current.state = textField.text
        //        }
        //        else if (textField == countryTxtField){
        //            UserProfile.current.country = textField.text
        //        }
        //        else if (textField == maleSeekingTxtField){
        //            UserProfile.current.seeking = textField.text
        //            seeking = "1"
        //        }
        //        else if (textField == femaleSeekingTxtField){
        //            UserProfile.current.seeking = textField.text
        //            seeking = "2"
        //        }
        //        else if (textField == heightTxtField){
        //            UserProfile.current.height = textField.text
        //        }
        //        else if (textField == weightTxtField){
        //            UserProfile.current.weight = textField.text
        //        }
        //        else if (textField == eyesTxtField){
        //            UserProfile.current.eyes = textField.text
        //        }
        //        else if (textField == skinTxtField){
        //            UserProfile.current.skin = textField.text
        //        }
        //        else if (textField == howMany){
        //            UserProfile.current.many = textField.text
        //        }
        //        else if (textField == religionTxtField){
        //            UserProfile.current.religion = textField.text
        //        }
        
    }
    
    //MARK:- TEXTVIEW METHODS
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 100
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        UserProfile.current.comment = textView.text
    }
    
    
    //MARK: - FUNCTIONS
    func callRegistartionApi(dict:[String:AnyObject],auth_key:String){
        Utilities.showProgressView(view: self.view)
        
        ApIManager.sharedInstance.userInfoDetailApi(param: dict, images: profileImgView.image!,auth_key: auth_key) {(succces) in
            
            if (succces){
                var Authorization_key:String = ""
                if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                    Authorization_key = (userInfo["authorization_key"] as? String)!
                }
                self.getUserInfo(auth:Authorization_key)
            }
            else {
                Utilities.hideProgressView(view: self.view)
                Utilities.alertView(controller: self, title: "Server Issue", msg: "Please try again server not working.")
            }
        }
        
    }
    
    func getUserInfo(auth:String){
        ApIManager.sharedInstance.getuserInfo(auth_key: auth) { (succces) in
            Utilities.hideProgressView(view: self.view)
            if (succces){
                if (self.backButtonFlag == true){
                    Utilities.goBack(controller: self)
                }
                else {
                    self.goNext()
                }
            }
            else {
                Utilities.alertView(controller: self, title: "Server Issue", msg: "Please try again server not working.")
            }
        }
        
    }
    
    func goNext(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    
    func userInfo(){
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            
            if let photo = userInfo["photo"] as? String{
                self.profileImgView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "placeholderImg"))
                profileImg = self.profileImgView.image
            }
            
            if let firstName = userInfo["first_name"] as? String{
                self.firstNameTxtField.text = firstName
                let last_name = userInfo["last_name"] as? String
                nameLbl.text = firstName + " " + last_name!
            }
            
            if let last_name = userInfo["last_name"] as? String{
                self.lastNameTxtField.text = last_name
            }
            
            
            if let age = userInfo["birthday"] as? String{
                self.ageTxtField.text = String(age)
            }
            
            if let city = userInfo["city"] as? String{
                self.cityTxtField.text = city
                locationLbl.text = city
            }
            
            if let state = userInfo["state"] as? String{
                stateId = state
            }
            
            if let country = userInfo["country"] as? String{
                countryId = country
            }
            
            if let genderval = userInfo["gender"] as? String{
                if genderval == "1"{
                    gender = genderval
                    maleBtn.setImage(UIImage(named:"tick_color"), for: .normal)
                }
                else if (genderval == "2"){
                    femaleBtn.setImage(UIImage(named:"tick_color"), for: .normal)
                    gender = genderval
                }
            }
            
            if let seekingVal = userInfo["seeking"] as? String{
                if (seekingVal == "1"){
                    maleSekkingBtn.setImage(UIImage(named:"tick_color"), for: .normal)
                    seeking = seekingVal
                }
                else if(seekingVal == "2") {
                    femaleSekkingBtn.setImage(UIImage(named:"tick_color"), for: .normal)
                    seeking = seekingVal
                }
                else {}
            }
            
            if let height = userInfo["height"] as? String{
                if (height == "0"){
                }
                else {
                    self.heightTxtField.text = height
                }
            }
            
            if let wight = userInfo["wight"] as? String{
                if (wight == "0"){
                    
                }
                else{
                    self.weightTxtField.text = wight
                }
            }
            
            if let skin = userInfo["skin"] as? String{
                self.skinTxtField.text = skin
            }
            
            if let eyes = userInfo["eyes"] as? String{
                self.eyesTxtField.text = eyes
            }
            
            if let children = userInfo["children"] as? String{
                if (children == "1"){
                    childrenYesBtn.setImage(UIImage(named:"tick_color"), for: .normal)
                    howMany.text = userInfo["many"] as? String
                    childrenVal = children
                }
                else if(children == "2") {
                    childrenNoBtn.setImage(UIImage(named:"tick_color"), for: .normal)
                }
                else {
                    
                }
                
            }
            
            if let religion = userInfo["religion"] as? String{
                self.religionTxtField.text = religion
            }
            
            if let comment = userInfo["comment"] as? String{
                self.aboutUsTextView.text = comment
            }
            
        }
    }
    
    func saveUserInfo(){
        
        var dict:[String:AnyObject] = [:]
        if (UserProfile.current.childern == "1"){
            
            dict = ["first_name":firstNameTxtField.text as AnyObject,"last_name":lastNameTxtField.text as AnyObject,"birthday":ageTxtField.text as AnyObject,"city":cityTxtField.text as AnyObject,"state":stateId as AnyObject,"country":countryId as AnyObject,"gender":gender as AnyObject,"phone":"" as AnyObject,"skin":skinTxtField.text as AnyObject,"eyes":eyesTxtField.text as AnyObject,"wight":weightTxtField.text as AnyObject,"height":heightTxtField.text as AnyObject,"religion":religionTxtField.text as AnyObject,"many":howMany.text as AnyObject,"comment": aboutUsTextView.text as AnyObject,"seeking":seeking as AnyObject,"children":childrenVal as AnyObject,"latitude":currentLatitude as AnyObject,"longitude":currentLongitude as AnyObject]
        }
        else {
            
            dict = ["first_name":firstNameTxtField.text as AnyObject,"last_name":lastNameTxtField.text as AnyObject,"birthday":ageTxtField.text as AnyObject,"city":cityTxtField.text as AnyObject,"state":stateId as AnyObject,"country":countryId as AnyObject,"gender":gender as AnyObject,"phone":"" as AnyObject,"skin":skinTxtField.text as AnyObject,"eyes":eyesTxtField.text as AnyObject,"wight":weightTxtField.text as AnyObject,"height":heightTxtField.text as AnyObject,"religion":religionTxtField.text as AnyObject as AnyObject,"comment": aboutUsTextView.text as AnyObject,"seeking":seeking as AnyObject,"children":childrenVal as AnyObject,"latitude":currentLatitude as AnyObject,"longitude":currentLongitude as AnyObject]
            
        }
        
        
        //add userinfo Api
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        callRegistartionApi(dict:dict, auth_key: Authorization_key)
    }
    
    // MARK:-determineMyCurrentLocation
    func checkMyCurrentLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                print("No access")
                
            case .restricted:
                break
                
            case .denied:
                
                let alertController = UIAlertController(title: NSLocalizedString("Allow", comment: ""), message: NSLocalizedString("Turn On Location Services to Allow to Determine Your Location", comment: ""), preferredStyle: .alert)
                
                //                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                    if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                        // DispatchQueue.main.async {
                        UIApplication.shared.openURL(settingsURL as URL)
                        // self.locationManager.startUpdatingLocation()
                        // }
                    }
                }
                // alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                return
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("hello")
                locationManager.startUpdatingLocation()
                saveUserInfo()
            }
        }
        else {
            
            let alertController = UIAlertController(title: NSLocalizedString("Allow", comment: ""), message: NSLocalizedString("Turn On Location Services to Allow to Determine Your Location", comment: ""), preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/com.cqlsys.DStash") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                //                UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                
                //                if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
                //                    if #available(iOS 10.0, *) {
                //                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //                    } else {
                //                        // Fallback on earlier versions
                //                    }
                //                }
                
                
                
            }
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }

}
