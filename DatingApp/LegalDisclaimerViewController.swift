import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class LegalDisclaimerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,hideMenu {
    
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        
    }
    
    
    //MARK-: IBACTION
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
    
    func hide(){
        menuBtn.isEnabled = true
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Utilities.goBack(controller: self)
    }
    
    @IBAction func doubleHeartBtnPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    //MARK: - TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LegalTableViewCell", for: indexPath) as?
        LegalTableViewCell
        cell?.selectionStyle = .none
        
        if (indexPath.row == 0){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.lbl.text = "Faq"
        }
            
        else if (indexPath.row == 1){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.lbl.text = "Terms & Conditions"
        }
            
        else if (indexPath.row == 2){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.lbl.text = "Privacy & Policy"
        }
         
        else if (indexPath.row == 3){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.lbl.text = "Terms of Subscription"
        }
            
        else if (indexPath.row == 4){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.lbl.text = "Refund"
        }
            
        else if (indexPath.row == 5) {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.lbl.text = "Support"
        }
        else {
            cell?.lbl.text = "Delete Account"
        }
        
        return cell!
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FaqViewController") as! FaqViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
            
        else if (indexPath.row == 1){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            nextViewController.flag = 1
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
            
        else if (indexPath.row == 2){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            nextViewController.flag = 2
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        else if (indexPath.row == 3){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            nextViewController.flag = 3
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
            
        else if (indexPath.row == 4){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            nextViewController.flag = 0
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        
        else if (indexPath.row == 5) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            nextViewController.flag = 6
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
//            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        else if (indexPath.row == 6) {
            let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want to delete account?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.deleteAccount()
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
    
    }
    
    func deleteAccount(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        Utilities.showProgressView(view: self.view)
        ApIManager.sharedInstance.deleteAccount(auth_key: Authorization_key) { (success) in
            Utilities.hideProgressView(view: self.view)
            if (success){
                
                Utilities.toasterView(msg: "Account Deleted Successfully")
                let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                fbLoginManager.logOut()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.swipeItems = []
                UserDefaults.standard.setValue("0", forKey: "UserExist")
                let secondViewController = (self.storyboard?.instantiateViewController(withIdentifier: "IntialVC"))! as UIViewController
                self.view.window?.rootViewController = secondViewController
                
            }
            else {
                Utilities.alertView(controller: self, title: "Server Issue", msg: "Please try again later")
            }
        }
        
        
    }
}
