
import UIKit

class DetailViewController: UIViewController,hideMenu,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewHeightConst: NSLayoutConstraint!
    @IBOutlet var saveProfileBtn: UIButton!
    @IBOutlet var howOftenBtn: [UIButton]!
    @IBOutlet var howManyBtn: [UIButton]!
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var dailyBtn: UIButton!
    @IBOutlet var weeklyBtn: UIButton!
    @IBOutlet var fortnightlyBtn: UIButton!
    @IBOutlet var monthlyBtn: UIButton!
    
    
    @IBOutlet var globallySwitchBtn: UISwitch!
    
    @IBOutlet var fiveBtn: UIButton!
    @IBOutlet var tenBtn: UIButton!
    @IBOutlet var fifteenBtn: UIButton!
    @IBOutlet var twentyBtn: UIButton!
    var message_Time:Int = 0
    var message_Limit:Int = 0
    
    var countriesArr:[Countrys] = []
    var statesArr:[States] = []
    var selectedPickerIndex = -1
    var countryPickerView = UIPickerView()
    var statePickerView = UIPickerView()
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    var countryId = "0"
    var stateId = "0"
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var withInkmTextField: UITextField!
    
    var positionSeleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GET COUNTRY
        getCountrys()
        countryPickerView.delegate = self
        statePickerView.delegate = self
        
        //GET VALUES DEFAULT
        setDefaultValue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //INCREASE HIGHT OF SCROLLVIEW
    override func viewDidLayoutSubviews() {
        viewHeightConst.constant = saveProfileBtn.frame.origin.y + saveProfileBtn.frame.size.height + 5
    }
    
    //GET COUNTRYS&STATES
    func getCountrys(){
        var auth_key = ""
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getCountryState(auth_key: Authorization_key) { (values, error, success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (values.count > 0){
                        self.countriesArr = values
                        let country = self.countriesArr.filter({$0.country_id == self.countryId})
                        print(country)
                        if (country.count > 0){
                            self.countryTextField.text = country[0].country_name
                            let states = country[0].states
                            let state = states.filter({$0.id == self.stateId})
                            if (states.count > 0){
                                self.stateTextField.text = state[0].state_name
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
    
    func setDefaultValue(){
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            message_Time = (userInfo["message_time"] as? Int)!
            message_Limit = (userInfo["message_limit"] as? Int)!
            cityTextField.text = (userInfo["prefer_city"] as? String)!
            countryId = (userInfo["prefer_country"] as? String)!
            stateId = (userInfo["prefer_state"] as? String)!
            let km = (userInfo["distance"] as? String)
            if (km != "0"){
                withInkmTextField.text = km
                globallySwitchBtn.isOn = false
            }
            else {
                globallySwitchBtn.isOn = true
                self.countryTextField.isEnabled = false
                self.stateTextField.isEnabled = false
                self.cityTextField.isEnabled = false
                self.withInkmTextField.isEnabled = false
            }
            
        }
        
        
        if (message_Limit != 0){
            
            if (message_Limit == 5){
                fiveBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
            else if (message_Limit == 10){
                tenBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
            else if (message_Limit == 15){
                fifteenBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
            else {
                twentyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
        }
        else {
            ///fiveBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
        
        if (message_Time != 0){
            if (message_Time == 86400){
                dailyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
            else if (message_Time == 604800){
                weeklyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
            else if (message_Time == 2592000){
                monthlyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
            else {
                fortnightlyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            }
        }
        else {
            dailyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        }
    }
    
    //MARK: - IBACTIONS
    @IBAction func menuBtnPressed(_ sender: Any) {
        menuBtn.isEnabled = false
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
    
    @IBAction func backPressed(_ sender: Any){
        Utilities.goBack(controller: self)
    }
    
    
    @IBAction func dailyBtnPressed(_ sender: Any) {
       // if (dailyBtn.isSelected == true){
          //  dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
           // weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
           // fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
          //  monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            //dailyBtn.isSelected = false
       // }
       // else {
            dailyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            let value = 60*60*24*1
            message_Time = value
            //dailyBtn.isSelected = true
       // }
    }
    
    @IBAction func weeklyBtnPressed(_ sender: Any) {
//        if (weeklyBtn.isSelected == true){
//            weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            weeklyBtn.isSelected = false
//        }
       // else {
            weeklyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            let value = 60*60*24*7
            message_Time = value
            //weeklyBtn.isSelected = true
       // }
        
    }
    
    @IBAction func fornightlyBtnPressed(_ sender: Any) {
//        if (fortnightlyBtn.isSelected == true){
//            fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            fortnightlyBtn.isSelected = false
//        }
        //else {
        fortnightlyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
        weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
        //fortnightlyBtn.isSelected = true
        //}
        
    }
    
    
    @IBAction func monthlyBtnPressed(_ sender: Any) {
//        if (monthlyBtn.isSelected == true){
//            fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            monthlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            monthlyBtn.isSelected = false
//        }
//        else {
            monthlyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            fortnightlyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            weeklyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            dailyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            let value = 60*60*24*30
            message_Time = value
            //monthlyBtn.isSelected = true
       // }
        
    }
    
    @IBAction func fiveBtnPressed(_ sender: Any) {
//        if (fiveBtn.isSelected == true){
//            fiveBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            fiveBtn.isSelected = false
//        }
//        else {
            fiveBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            tenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            fifteenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            twentyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            message_Limit = 5
             //fiveBtn.isSelected = true
       // }
    }
    
    @IBAction func tenBtnPressed(_ sender: Any) {
//        if (tenBtn.isSelected == true){
//            tenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            tenBtn.isSelected = false
//        }
        //else {
            tenBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            fiveBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            fifteenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            twentyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            message_Limit = 10
           // tenBtn.isSelected = true
        //}
    }
    
    @IBAction func fifteenBtnPressed(_ sender: Any) {
//        if (fifteenBtn.isSelected == true){
//            fifteenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
//            fifteenBtn.isSelected = false
//        }
        //else {
            fifteenBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            tenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            fiveBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            twentyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            message_Limit = 15
            //fifteenBtn.isSelected = true
       // }
    }
    @IBAction func twentyBtnPressed(_ sender: Any) {
        //if (twentyBtn.isSelected == true){
          //  twentyBtn.setImage(UIImage(named:"untick_color"), for: .normal)
          //  twentyBtn.isSelected = false
       // }
       // else {
            twentyBtn.setImage(UIImage(named:"tick_color"), for: .normal)
            fifteenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            tenBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            fiveBtn.setImage(UIImage(named:"untick_color"), for: .normal)
            message_Limit = 20
           // twentyBtn.isSelected = true
       // }
    }
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReplyMessagesViewController") as! ReplyMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    @IBAction func messageSaveBtnPressed(_ sender: Any) {
        let dic:[String:Any] = ["message_limit":message_Limit,"time":message_Time]
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.messageBank(messageInfo: dic, completion: { (error, success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if let data = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                        var dataVal = data
                        dataVal["message_time"] = self.message_Time
                        dataVal["message_limit"] = self.message_Limit
                        UserDefaults.standard.setValue(dataVal, forKey: "userInfo")
                    }
                    
                    Utilities.toasterView(msg: "Message's Setting is updated successfully")
                    Utilities.goBack(controller: self)
                }
                else {
                   Utilities.alertView(controller: self, title: "Please Check", msg: error)
                }
            })
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
    }
    
    @IBAction func saveProfileBtnPressed(_ sender: Any) {
        
        if (positionSeleted == true){
        
        if (countryTextField.text == ""){
            Utilities.alertView(controller: self, title: "Enter Country.", msg: "Please enter country.")
        }
        else if (stateTextField.text == ""){
            Utilities.alertView(controller: self, title: "Enter State.", msg: "Please enter state.")
        }
        else if (cityTextField.text == ""){
            Utilities.alertView(controller: self, title: "Enter City.", msg: "Please enter city.")
        }
        else {
            var dic:[String:Any] = [:]
            dic = ["prefer_country":countryId,"prefer_state":stateId,"prefer_city":cityTextField.text ?? "","distance":withInkmTextField.text ?? "","get_gobble":"0"]
            
           
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.messageBankPosition(messageInfo: dic, completion: { (error, success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
//                    if let data = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
//                        var dataVal = data
//                        dataVal["message_Time"] = self.message_Time
//                        dataVal["message_limit"] = self.message_Limit
//                        UserDefaults.standard.setValue(dataVal, forKey: "userInfo")
//                    }
                    self.setDefaultValue()
                    Utilities.toasterView(msg: "Message's Setting is updated successfully")
                    Utilities.goBack(controller: self)
                    
                }
                else {
                    Utilities.alertView(controller: self, title: "Please Check", msg: error)
                }
            })
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
            
        }
        }
        
        else {
            var dic:[String:Any] = [:]
            dic = ["prefer_country":"","prefer_state":"","prefer_city":"","distance":"","get_gobble":"1"]
            
            
            if (Reachability.isConnectedToNetwork()){
                Utilities.showProgressView(view: self.view)
                ApIManager.sharedInstance.messageBankPosition(messageInfo: dic, completion: { (error, success) in
                    Utilities.hideProgressView(view: self.view)
                    if (success){
                        //                    if let data = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                        //                        var dataVal = data
                        //                        dataVal["message_Time"] = self.message_Time
                        //                        dataVal["message_limit"] = self.message_Limit
                        //                        UserDefaults.standard.setValue(dataVal, forKey: "userInfo")
                        //                    }
                        self.setDefaultValue()
                        Utilities.toasterView(msg: "Message's Setting is updated successfully")
                        Utilities.goBack(controller: self)
                        
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Please Check", msg: error)
                    }
                })
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
            
        }
        
        
    }
    
    @IBAction func globallySwitchBtnPressed(_ sender: Any) {
        
        if (globallySwitchBtn.isOn == true){
            positionSeleted = false
            self.countryTextField.isEnabled = false
            self.stateTextField.isEnabled = false
            self.cityTextField.isEnabled = false
            self.withInkmTextField.isEnabled = false
        }
        else {
            positionSeleted = true
            self.countryTextField.isEnabled = true
            self.stateTextField.isEnabled = true
            self.cityTextField.isEnabled = true
            self.withInkmTextField.isEnabled = true
        }
        
        
    }
    
    
    //MARK:- FUNCTIONS
    func hide(){
        menuBtn.isEnabled = true
    }
    
    func getMessage(){
        
    }
    
    //MARK:- PICKERVIEW METHODS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (selectedPickerIndex == 0){
            return countriesArr.count
        }
        else {
            return statesArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (selectedPickerIndex == 0){
            return countriesArr[row].country_name as? String
        }
        else {
            return statesArr[row].state_name as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (selectedPickerIndex == 0){
            statesArr = countriesArr[row].states
            countryTextField.text = countriesArr[row].country_name
            countryId = countriesArr[row].country_id!
        }
        else  {
            stateTextField.text = statesArr[row].state_name
            stateId = statesArr[row].id!
        }
        
    }
    
    //MARK: - TEXTFIELD METHODS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == countryTextField){
            selectedPickerIndex = 0
            countryTextField.inputView = countryPickerView
        }
        else if (textField == stateTextField){
            if (statesArr.count == 0){
                Utilities.alertView(controller: self, title: "", msg: "Please select the country first")
            }
            else {
                selectedPickerIndex = 1
                stateTextField.inputView = statePickerView
            }
        }
    }
    
}
