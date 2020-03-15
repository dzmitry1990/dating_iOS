
import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import TwitterKit
import SafariServices

protocol hideMenu {
    func hide()
}

class MenuViewController : UIViewController,SFSafariViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var profileUserNameLbl: UILabel!
    var hideMenus:hideMenu?
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var firstName = ""
        var lastName = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            
            if let pic = userInfo["photo"] as? String{
                self.profileImg.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "user-Profile"))
            }
            
            if let firName = userInfo["first_name"] as? String{
                firstName = firName
            }
            
            if let lasName = userInfo["last_name"] as? String{
                lastName = lasName
            }
            
            self.profileUserNameLbl.text = firstName + " " + lastName
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.profileImg.layer.cornerRadius = self.profileImg.frame.height / 2
    }
    
    //MARK:- IBACTIONS
    @IBAction func backBtn(_ sender: Any) {
        hideMenus?.hide()
        closeMenu()
    }
    
    @IBAction func legalDiscription(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        nextViewController.flag = 4
        self.navigationController?.pushViewController(nextViewController, animated: true)
        closeMenu()
        
    }
    
    //MARK:- SHARING APP
    @IBAction func facebookShareBtnPressed(_ sender: Any) {
        
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        //vc.add(imageView.image!)
        vc?.add(URL(string: "https://itunes.apple.com/us/app/mydateapp/id1343073121?mt=8"))
        vc?.setInitialText("Mydateapp")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func twiiterShareBtnPressed(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        //vc.add(imageView.image!)
        vc?.add(URL(string: "https://itunes.apple.com/us/app/mydateapp/id1343073121?mt=8"))
        vc?.setInitialText("Mydateapp")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func googleShareBtnPressed(_ sender: Any) {
        var urlComponents = URLComponents(string: "https://plus.google.com/share")
        //let queryItem = URLQueryItem(name: "url", value: "https://itunes.apple.com/us/app/ceedpage/id1306576035?ls=1&mt=8")
        let queryItem = URLQueryItem(name: "url", value: "www.google.com")
        let queryItem1 = URLQueryItem(name: "Mydateapp", value: "https://itunes.apple.com/us/app/mydateapp/id1343073121?mt=8")
        urlComponents?.queryItems = [queryItem1, queryItem]
        let url: URL? = urlComponents?.url
        let safariVC = SFSafariViewController(url: url!)
        safariVC.delegate = self
        present(safariVC, animated: true) {() -> Void in }
    }
    
    @IBAction func linkedShareBtnPressed(_ sender: Any) {
        let text = "https://itunes.apple.com/us/app/mydateapp/id1343073121?mt=8"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- FUNCTIONS
    func closeMenu(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
}

extension MenuViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell
        
        cell?.selectionStyle = .none
        
        cell?.imgView.image = Constants.menuImgArray[indexPath.row]
        
        cell?.titleLbl.text = Constants.menuArray[indexPath.row]
        
        return cell!
    }
    
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 0){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            nextViewController.backButtonFlag = true
            nextViewController.imagePick = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
            closeMenu()
            
        }
            
        else if (indexPath.row == 1){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            closeMenu()
            
        }
        else if (indexPath.row == 2){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SuggestionsViewController") as! SuggestionsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            closeMenu()
            
            
        }
            
        else if (indexPath.row == 3){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            closeMenu()
            
            
        }
        
        else if(indexPath.row == 4){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            closeMenu()
            
        }
            
//        else if (indexPath.row == 4){
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//            closeMenu()
//        }
//        else if (indexPath.row == 6){
//
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//            closeMenu()
//        }
        else if (indexPath.row == 5){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LegalDisclaimerViewController") as! LegalDisclaimerViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            closeMenu()
            
        }
        else if (indexPath.row == 6){
            //Utilities.toasterView(msg: "Design in progress")
            let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
                let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
                fbLoginManager.logOut()
                var appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.swipeItems = []
                UserDefaults.standard.setValue("0", forKey: "UserExist")
                let secondViewController = (self.storyboard?.instantiateViewController(withIdentifier: "IntialVC"))! as UIViewController
                self.view.window?.rootViewController = secondViewController
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
    }
}
