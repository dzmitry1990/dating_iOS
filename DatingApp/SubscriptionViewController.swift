
import UIKit
import StoreKit

class SubscriptionViewController: UIViewController,hideMenu {
    
    
    @IBOutlet var subscriptionDetailView: UIView!
    @IBOutlet var onemonthBtn: UIButton!
    @IBOutlet var threeMonthBtn: UIButton!
    @IBOutlet var sixMonthBtn: UIButton!
    @IBOutlet var twelveMonthBtn: UIButton!
    @IBOutlet var fiveYearBtn: UIButton!
    @IBOutlet var backwardBtn: UIButton!
    @IBOutlet var autoRenewBtn: UIButton!
    @IBOutlet var menuBtn: UIButton!
    var subscriptionsArr:[Subscription] = []
    var autoRenew = "No"
    var subscriptionType = ""
    var subscriptionId = ""
    var backSubcriptionId = ""
    var messageSubcriptionId = ""
    var subscriptionPlan = ""
    var subscriptionPlanArr:[String] = []
    
    @IBOutlet var autoRenewableToggleBtn: UISwitch!
    //SUBSCPTION
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetSubscrptionPlanApi()
        getProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.succussPayment), name: NSNotification.Name(rawValue: "paymentsuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.noSuccussPayment), name: NSNotification.Name(rawValue: "noPaymentsuccess"), object: nil)
        
    }
    func getProducts() {
        products = []
        Utilities.showProgressView(view: self.view)
        //ActivityIndicator.shared.show(self.view)
        RageProducts.store.requestProducts{success, products in
            Utilities.hideProgressView(view: self.view)
            if success {
                self.products = products!
            }
            else{
            }
        }
    }
    
    func succussPayment(notification: Notification){
        DispatchQueue.main.async {
            Utilities.hideProgressView(view: self.view)
        }
        let userInfo = notification.object as? [AnyHashable: Any]
        print(userInfo)
        var buyInfo:[String:Any] = [:]
        buyInfo["transaction"] = userInfo!["transaction"] as? String
        buyInfo["subscription_id"] = subscriptionId
        
        if (subscriptionId == "25"){
            buyInfo["is_back"] = "1"
            buyInfo["auto_renew"] = "0"
        }
        else {
            if (autoRenew == "Yes"){
                buyInfo["auto_renew"] = "1"
            }
            else {
                buyInfo["auto_renew"] = "0"
            }
            buyInfo["is_back"] = "0"
        }
        
        buyProductApi(buyInfo: buyInfo)
        
    }
    
    
    func noSuccussPayment(notification: Notification){
        
        DispatchQueue.main.async {
            Utilities.hideProgressView(view: self.view)
        }
        let userInfo = notification.object as? [AnyHashable: Any]
        let error = userInfo!["error"] as? String
        Utilities.alertView(controller: self, title: "Try Again", msg: error!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSubscriptionPlans()
        menuBtn.isEnabled = true
    }
    
    
    //MARK:- FUNCTIONS
    func hide() {
        menuBtn.isEnabled = true
    }
    
    func callGetSubscrptionPlanApi(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            //Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getSubscriptionPlan(authKey: Authorization_key) { (value, success) in
                //Utilities.hideProgressView(view: self.view)
                if (success){
                    if (value.count > 0){
                        self.subscriptionsArr = value
                    }
                    else {
                        // Utilities.alertView(controller: self, title: "Try Again", msg: "Server Not Working")
                    }
                }
                else {
                    //Utilities.alertView(controller: self, title: "Try Again", msg: "Server Not Working")
                }
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
    }
    
    func buyProductApi(buyInfo:[String:Any]){
        
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.buySubscriptionPlan(buyInfo: buyInfo, completion: { (error,values,success) in
                Utilities.hideProgressView(view: self.view)
                if (error == ""){
                    print(values)
                    
                    if (values.count > 0){
                        for value in values{
                            let subscription_id = value["subscription_id"] as! String
                            if (subscription_id == "25"){
                                var userInfo:[String:Any] = [:]
                                if let userInfos = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                                    userInfo = userInfos
                                    userInfo["backWardSubscription"] = subscription_id
                                    userInfo["backWardSubscriptionExpireDate"] = value["expire_time"]
                                    UserDefaults.standard.setValue(userInfo, forKey: "userInfo")
                                    
                                }
                            }
                            else {
                                var userInfo:[String:Any] = [:]
                                if let userInfos = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                                    userInfo = userInfos
                                    if (self.autoRenew == "Yes"){
                                        userInfo["autoRenew"] = "1"
                                    }
                                    else {
                                        userInfo["autoRenew"] = "0"
                                    }
                                    userInfo["messageSubscription"] = subscription_id
                                    userInfo["messageSubscriptionExpireDate"] = value["expire_time"]
                                    UserDefaults.standard.setValue(userInfo, forKey: "userInfo")
                                    
                                }
                            }
                        }
                    }
                    self.checkSubscriptionPlans()
                    Utilities.toasterView(msg: "Plan parchased thanks you")
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
    
    func checkSubscriptionPlans(){
        
        if let userInfos = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            
            let backWard = userInfos["backWardSubscription"] as? String
            if (backWard != "" && backWard != nil){
                backwardBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
                backwardBtn.isEnabled = false
                backSubcriptionId = backWard!
            }
            else {
                backwardBtn.isEnabled = true
            }
            let message = userInfos["messageSubscription"] as? String
            let autoRenew = userInfos["autoRenew"] as? String
            
            if (autoRenew == "1"){
                autoRenewBtn.setBackgroundImage(UIImage(named:"tick_1"), for: .normal)
            }
            else {
                autoRenewBtn.setBackgroundImage(UIImage(named:"untick"), for: .normal)
            }
            
            if (message != "" && message != nil){
                autoRenewBtn.isEnabled = false
                messageSubcriptionId = message!
                if (message == "19"){
                    onemonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
                    onemonthBtn.isEnabled = false
                    //threeMonthBtn.isEnabled = false
                    //sixMonthBtn.isEnabled = false
                    //twelveMonthBtn.isEnabled = false
                    //fiveYearBtn.isEnabled = false
                }
                else if (message == "20"){
                    threeMonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
                    threeMonthBtn.isEnabled = false
                    //onemonthBtn.isEnabled = false
                    //sixMonthBtn.isEnabled = false
                    //twelveMonthBtn.isEnabled = false
                    //fiveYearBtn.isEnabled = false
                    
                }
                else if (message == "21"){
                    sixMonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
                    sixMonthBtn.isEnabled = false
                    //onemonthBtn.isEnabled = false
                    //threeMonthBtn.isEnabled = false
                    //twelveMonthBtn.isEnabled = false
                    //fiveYearBtn.isEnabled = false
                }
                else if (message == "22"){
                    twelveMonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
                    twelveMonthBtn.isEnabled = false
                    //onemonthBtn.isEnabled = false
                    //threeMonthBtn.isEnabled = false
                    //sixMonthBtn.isEnabled = false
                    //fiveYearBtn.isEnabled = false
                }
                else {
                    fiveYearBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
                    fiveYearBtn.isEnabled = false
                    //onemonthBtn.isEnabled = false
                    //threeMonthBtn.isEnabled = false
                    //sixMonthBtn.isEnabled = false
                    //twelveMonthBtn.isEnabled = false
                }
            }
            else {
                autoRenewBtn.isEnabled = true
            }
            
        }
        
    }
    
    
    //MARK:- IBACTIONS
    @IBAction func menuBtnPressed(_ sender: Any) {
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuBtn.isEnabled = false
        menuVC.hideMenus = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func onemonthBtnPressed(_ sender: Any) {
        
        if (messageSubcriptionId != ""){
                Utilities.alertView(controller: self, title: "Already Purchased", msg: "Subscription already purchased.")
        }
        else {
            onemonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
            threeMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
            sixMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
            twelveMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
            fiveYearBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
            autoRenewBtn.isEnabled = true
            if (backSubcriptionId != ""){
            }
            else {
                backwardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
            }
            subscriptionType = "1Month"
            subscriptionId = subscriptionsArr[0].id
        }
        
        
        
        
    }
    
    @IBAction func backwardsBtnPressed(_ sender: Any) {
        
        //        if (backwardBtn.imageView?.image == UIImage(named:"circle_selected")){
        //            backwardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        //            //backSubcriptionId = ""
        //        }
        //        else {
        
        if (messageSubcriptionId != ""){
            backwardBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
            subscriptionType = "backWard"
            autoRenewBtn.isEnabled = false
            subscriptionId = subscriptionsArr[5].id
        }
        else {
        backwardBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        onemonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        threeMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        sixMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        twelveMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        fiveYearBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        //backSubcriptionId = subscriptionsArr[5].id
        subscriptionType = "backWard"
        autoRenewBtn.isEnabled = false
        subscriptionId = subscriptionsArr[5].id
        }
        //}
        
        
    }
    
    @IBAction func threeMonthBtnPressed(_ sender: Any) {
        
        if (messageSubcriptionId != ""){
            Utilities.alertView(controller: self, title: "Already Purchased", msg: "Subscription already purchased.")
        }
        else {
        threeMonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        sixMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        twelveMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        fiveYearBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        onemonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        autoRenewBtn.isEnabled = true
        if (backSubcriptionId != ""){
        }
        else {
            backwardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        }
        subscriptionType = "3Month"
        subscriptionId = subscriptionsArr[1].id
        }
        
        
    }
    @IBAction func fiveYearBtnPressed(_ sender: Any) {
        
        if (messageSubcriptionId != ""){
            Utilities.alertView(controller: self, title: "Already Purchased", msg: "Subscription already purchased.")
        }
        else {
        fiveYearBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        sixMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        twelveMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        threeMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        onemonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        autoRenewBtn.isEnabled = true
        if (backSubcriptionId != ""){
        }
        else {
            backwardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        }
        subscriptionType = "5Year"
        subscriptionId = subscriptionsArr[4].id
        }
        
    }
    
    @IBAction func twelveMonthBtnPressed(_ sender: Any) {
        
        if (messageSubcriptionId != ""){
            Utilities.alertView(controller: self, title: "Already Purchased", msg: "Subscription already purchased.")
        }
        else {
        twelveMonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        sixMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        fiveYearBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        threeMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        onemonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        autoRenewBtn.isEnabled = true
        if (backSubcriptionId != ""){
        }
        else {
            backwardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        }
        subscriptionType = "12Month"
        subscriptionId = subscriptionsArr[3].id
        }
        
    }
    
    @IBAction func sixMonthBtnPressed(_ sender: Any) {
        
        if (messageSubcriptionId != ""){
            Utilities.alertView(controller: self, title: "Already Purchased", msg: "Subscription already purchased.")
        }
        else {
        sixMonthBtn.setImage(UIImage(named:"circle_selected"), for: .normal)
        twelveMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        fiveYearBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        threeMonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        onemonthBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        autoRenewBtn.isEnabled = true
        if (backSubcriptionId != ""){
        }
        else {
            backwardBtn.setImage(UIImage(named:"circle_unselected"), for: .normal)
        }
        subscriptionType = "6Month"
        subscriptionId = subscriptionsArr[2].id
        }
        
    }
    
    @IBAction func autoRenewBtnPresssed(_ sender: Any) {
        
        if (subscriptionType != "backWard"){
            
            if (autoRenewBtn.isSelected){
                autoRenewBtn.isSelected = false
                autoRenew = "No"
                autoRenewBtn.setBackgroundImage(UIImage(named:"untick"), for: .normal)
            }
            else {
                autoRenewBtn.isSelected = true
                autoRenew = "Yes"
                autoRenewBtn.setBackgroundImage(UIImage(named:"tick_1"), for: .normal)
                
            }
        }
        else {
            Utilities.alertView(controller: self, title: "Not Applied", msg: "Backwards only one time fee paid.")
        }
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if (subscriptionType == ""){
            if (backSubcriptionId != "" && messageSubcriptionId != ""){
                Utilities.alertView(controller: self, title: "Already Purchased", msg: "All plans purchased")
            }
            else {
                Utilities.alertView(controller: self, title: "Selcet Plan", msg: "Please select plan")
            }
        }
        else if (backSubcriptionId != "" && messageSubcriptionId != ""){
            Utilities.alertView(controller: self, title: "Already Purchased", msg: "All plans purchased")
        }
        else {
            
            if (autoRenew == "Yes"){
                
                if (subscriptionType == "1Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.AutoRenewing.1Month")
                }
                else if (subscriptionType == "3Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.AutoRenewing.3Month")
                }
                else if (subscriptionType == "6Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.AutoRenewing.6Month")
                }
                else if (subscriptionType == "12Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.AutoRenewing.12Month")
                }
                else if (subscriptionType == "5Year"){
                    subscriptionPlanArr.append("com.app.Mydateapp.AutoRenewing.5Year")
                }
                else if (subscriptionType == "backWard"){
                    subscriptionPlanArr.append("com.app.Mydateapp.LifeTimeSubscription")
                }
            }
            else {
                
                if (subscriptionType == "1Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.NonRenewing.1Month")
                }
                else if (subscriptionType == "3Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.NonRenewing.3Month")
                }
                else if (subscriptionType == "6Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.NonRenewing.6Month")
                }
                else if (subscriptionType == "12Month"){
                    subscriptionPlanArr.append("com.app.Mydateapp.NonRenewing.12Month")
                }
                else if (subscriptionType == "5Year"){
                    subscriptionPlanArr.append("com.app.Mydateapp.NonRenewing.5Year")
                    //subscriptionPlanArr.append("com.app.Mydateapp.LifeTimeSubscriptions")
                }
                else if (subscriptionType == "backWard"){
                    subscriptionPlanArr.append("com.app.Mydateapp.LifeTimeSubscription")
                }
            }
            
            //        if (backSubcriptionId != ""){
            //            subscriptionPlanArr.append("com.app.Mydateapp.LifeTimeSubscription")
            //        }
            
            //var productPlanChoose = [SKProduct]()
            var productPlanChoose = SKProduct()
            for p in products {
                print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                if (subscriptionPlanArr.contains(p.productIdentifier)){
                    productPlanChoose = p
                }
            }
            
            self.subscriptionAPI(productPlanChoose)
            
//            var alertMsg = ""
//            let autoRenewVal = autoRenew
//            if (subscriptionId == "25"){
//                alertMsg = "Life time subscription for see the back or prevoius users. Lenght -: Life Time(Infinite)"
//            }
//            else if (subscriptionId == "19"){
//
//                if (autoRenewVal == "Yes"){
//                    alertMsg = "Send message to users(Chat) and automatically renew after 1 month(for more info plz click on check susbscription detail). Lenght -: 1 Month"
//                }
//                else {
//                    alertMsg = "Send message to users(Chat). Lenght -: One Month"
//                }
//            }
//            else if (subscriptionId == "20"){
//                if (autoRenewVal == "Yes"){
//                    alertMsg = "Send message to users(Chat) and automatically renew after 3 month(for more info plz click on check susbscription detail). Lenght -: 3 Month"
//                }
//                else {
//                    alertMsg = "Send message to users(Chat). Lenght -: 3 Month"
//                }
//            }
//            else if (subscriptionId == "21"){
//                if (autoRenewVal == "Yes"){
//                    alertMsg = "Send message to users(Chat) and automatically renew after 6 month(for more info plz click on check susbscription detail). Lenght -: 6 Month"
//                }
//                else {
//                    alertMsg = "Send message to users(Chat). Lenght -: 6 Month"
//                }
//            }
//            else if (subscriptionId == "22"){
//                if (autoRenewVal == "Yes"){
//                    alertMsg = "Send message to users(Chat) and automatically renew after 12 month(for more info plz click on check susbscription detail). Lenght -: 12 Month"
//                }
//                else {
//                    alertMsg = "Send message to users(Chat). Lenght -: 12 Month"
//                }
//            }
//            else if (subscriptionId == "23"){
//                if (autoRenewVal == "Yes"){
//                    alertMsg = "Send message to users(Chat) and automatically renew after 5 Years(for more info plz click on check susbscription detail). Lenght -: 5 Years"
//                }
//                else {
//                    alertMsg = "Send message to users(Chat). Lenght -: 5 Years"
//                }
//            }
//
//            let actionSheetController = UIAlertController (title: "Subscription Detail", message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
//
//            //Add Cancel-Action
//            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
//
//
//            //Add Save-Action
//            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
//                self.subscriptionAPI(productPlanChoose)
//            })
//            actionSheetController.addAction(cancel);
//            actionSheetController.addAction(ok);
//            //present actionSheetController
//            present(actionSheetController, animated: true, completion: nil)
            
            
            
        }
        
    }
    @IBAction func subcriptionDetailBtnPressed(_ sender: Any) {
        self.subscriptionDetailView.isHidden = false
    }
    
    @IBAction func crossBtnPressed(_ sender: Any) {
        self.subscriptionDetailView.isHidden = true
    }
    func subscriptionAPI(_ objProduct : SKProduct)
    {
        Utilities.showProgressView(view: self.view)
        RageProducts.store.buyProduct(objProduct)
    }
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func policyBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        nextViewController.flag = 3
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    @IBAction func termsBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        nextViewController.flag = 5
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func autoRenewableToggleBtnPressed(_ sender: Any) {
        
        if (subscriptionType != "backWard"){
            
            if (autoRenewBtn.isSelected){
                autoRenewableToggleBtn.isOn = false
                autoRenewBtn.isSelected = false
                autoRenew = "No"
                autoRenewBtn.setBackgroundImage(UIImage(named:"untick"), for: .normal)
            }
            else {
                
//                if (autoRenewableToggleBtn.isOn){
//                    autoRenewableToggleBtn.isOn = false
//                }
//                else {
                    autoRenewableToggleBtn.isOn = true
                //}
                
                autoRenewBtn.isSelected = true
                
                autoRenew = "Yes"
                autoRenewBtn.setBackgroundImage(UIImage(named:"tick_1"), for: .normal)
                
            }
        }
        else {
            autoRenewableToggleBtn.isOn = false
            Utilities.alertView(controller: self, title: "Not Applied", msg: "Backwards only one time fee paid.")
        }
    }
}
