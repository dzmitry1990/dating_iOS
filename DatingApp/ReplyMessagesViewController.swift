
import UIKit

class ReplyMessagesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,hideMenu {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var menuBtn: UIButton!
    var notificationsArr:[Notifications] = []
    @IBOutlet var noTextFoundlbl: UILabel!
    var messageSubcription = false
    var userId = ""
    var statusSend = "down"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        tblView.estimatedRowHeight = 125 //minimum row height
        tblView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSubscription()
        getAllNotificationsApi()
    }
    
    
    //MARK:- CHECK SUSBSCRIPTION
    func checkSubscription(){
        
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            let message = userInfo["messageSubscription"] as? String
            let messageExpireDate = userInfo["messageSubscriptionExpireDate"] as? String
            userId = (userInfo["id"] as? String)!
            
            if (message != "" && message != nil){
                
                let prvDateDoubleVal = Double(messageExpireDate!)
                let currentDate = NSDate()
                let Prevoiusdate =  NSDate(timeIntervalSince1970: prvDateDoubleVal!)
                
                switch Prevoiusdate.compare(currentDate as Date) {
                case .orderedAscending:
                    self.messageSubcription = false
                    break
                case .orderedSame:
                    self.messageSubcription = true
                    break
                case .orderedDescending:
                    self.messageSubcription = true
                    break
                }
            }
            else {
                self.messageSubcription = false
            }
            
        }
        
    }
    
    //MARK:
    //MARK: - IBACTIONS
    @IBAction func menuBtNPresssed(_ sender: Any) {
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
    
    @IBAction func heartBtnPressed(_ sender: Any) {
        if (messageSubcription == false){
            
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AllMessagesViewController") as! AllMessagesViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func downBtnPressed(_ sender: UIButton) {
        
        let value = notificationsArr[sender.tag]
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            ApIManager.sharedInstance.deleteNotification(Id: value.id, auth_key: Authorization_key, completion: { (success) in
                if (success){
                    self.notificationsArr.remove(at: sender.tag)
                    //Utilities.toasterView(msg: "Notification deleted successfully")
                    if (self.notificationsArr.count == 0){
                        self.noTextFoundlbl.text = "No Notifications Found."
                    }
                    self.tblView.reloadData()
                    
                }
                else {
                    Utilities.alertView(controller: self, title: "Try Again", msg: "Server not working.")
                }
            })
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
    }
    @IBAction func perfectBtnPressed(_ sender: UIButton) {
        
        let values = notificationsArr[sender.tag]
        let userInfo = ["friend_id":values.sender_id,"type":"1"]
        print(userInfo)
        statusSend = "perfect"
        callLikesApi(userInfoDict: userInfo, indexPath: sender.tag)
        //        if (messageSubcription == false){
        //            alertView()
        //        }
        //        else {
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        //        let value = notificationsArr[sender.tag]
        //        nextViewController.friendID = value.sender_id
        //        self.navigationController?.pushViewController(nextViewController, animated: true)
        //        }
    }
    
    @IBAction func doubleHeartBtnPressed(_ sender: UIButton) {
        
        let values = notificationsArr[sender.tag]
        let userInfo = ["friend_id":values.sender_id,"type":"3"]
        print(userInfo)
        statusSend = "doubleheart"
        callLikesApi(userInfoDict: userInfo, indexPath: sender.tag)
        
        //        if (messageSubcription == false){
        //            alertView()
        //        }
        //        else {
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        //            let value = notificationsArr[sender.tag]
        //            nextViewController.friendID = value.sender_id
        //        self.navigationController?.pushViewController(nextViewController, animated: true)
        //        }
    }
    
    @IBAction func chatBtnPressed(_ sender: UIButton) {
        
        if (messageSubcription == true){
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
            let value = notificationsArr[sender.tag]
            nextViewController.friendID = value.sender_id
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else {
            alertView()
        }
        
    }
    @IBAction func userProfileBtnPressed(_ sender: UIButton) {
        
        let value = notificationsArr[sender.tag]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        nextViewController.id = value.sender_id
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    //MARK:- FUNCTIONS
    func getAllNotificationsApi(){
        
        var Authorization_key:String = ""
        if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
            Authorization_key = (userInfo["authorization_key"] as? String)!
        }
        
        if (Reachability.isConnectedToNetwork()){
            Utilities.showProgressView(view: self.view)
            ApIManager.sharedInstance.getAllNotifications(auth_key: Authorization_key, completion: { (value,success) in
                Utilities.hideProgressView(view: self.view)
                if (success){
                    if (value.count > 0){
                        self.noTextFoundlbl.text = ""
                        self.notificationsArr = value
                        self.tblView.reloadData()
                    }
                    else {
                        self.noTextFoundlbl.text = "No Notifications Found."
                    }
                    print("successfully get notifications")
                }
                else {
                    print("no geting notifications")
                }
            })
            
        }
        else {
            Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
        }
        
    }
    
    
    func callLikesApi(userInfoDict:[String:Any],indexPath:Int){
        Utilities.showProgressView(view: self.view)
        ApIManager.sharedInstance.userLikeStatusApi(userInfo: userInfoDict, completion: { (success) in
            Utilities.hideProgressView(view: self.view)
            if (success){
                if (self.statusSend == "perfect"){
                    Utilities.toasterView(msg: "Successfully send perfect")
                }
                else if (self.statusSend == "doubleheart"){
                    Utilities.toasterView(msg: "Successfully send double heart")
                }
                else {
                }
                
                self.notificationsArr.remove(at: indexPath)
                //Utilities.toasterView(msg: "Notification deleted successfully")
                if (self.notificationsArr.count == 0){
                    self.noTextFoundlbl.text = "No Notifications Found."
                }
                self.tblView.reloadData()
                print("success")
            }
            else {
                print("failure")
            }
        })
        
    }
    
    
    //MARK:
    //MARK: - TABLEVIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if (Constants.iphone5s == Constants.screenSize){
            return 125.0
        }
        else {
            return 150.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        if (indexPath.row == 0){
        //
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyMessagesTableViewCell", for: indexPath) as? ReplyMessagesTableViewCell
        //            cell?.selectionStyle = .none
        //            return cell!
        //        }
        //
        //        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiMessagesTableViewCell", for: indexPath) as? EmojiMessagesTableViewCell
        cell?.selectionStyle = .none
        cell?.downBtn.tag = indexPath.row
        cell?.perfectBtn.tag = indexPath.row
        cell?.doubleHeartBtn.tag = indexPath.row
        cell?.profileBtn.tag = indexPath.row
        cell?.chatBtn.tag = indexPath.row
        
        if (notificationsArr.count > 0){
            let value = notificationsArr[indexPath.row]
            let name = value.name
            cell?.profileBtn.setTitle("Tap here to view " + name + " Profile", for: .normal)
            cell?.nameLbl.text = "Return an Emoji " + name + "!"
            
            cell?.imgView.sd_setImage(with: URL(string:value.photo), placeholderImage: UIImage(named: "placeholderImg"))
            
        }
        
        return cell!
        
        /// }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            var Authorization_key:String = ""
            if let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String:Any]{
                Authorization_key = (userInfo["authorization_key"] as? String)!
            }
            let value = notificationsArr[indexPath.row]
            
            if (Reachability.isConnectedToNetwork()){
                ApIManager.sharedInstance.deleteNotification(Id: value.id, auth_key: Authorization_key, completion: { (success) in
                    if (success){
                        self.notificationsArr.remove(at: indexPath.row)
                        Utilities.toasterView(msg: "Notification deleted successfully")
                        if (self.notificationsArr.count == 0){
                            self.noTextFoundlbl.text = "No Notifications Found."
                        }
                        self.tblView.reloadData()
                        
                    }
                    else {
                        Utilities.alertView(controller: self, title: "Try Again", msg: "Server not working.")
                    }
                })
            }
            else {
                Utilities.alertView(controller: self, title: "Please Check", msg: "Please check internet connection")
            }
        }
    }
    
    func alertView(){
        // create the alert
        let alert = UIAlertController(title: "Subscription", message: "Please Purchase Subscription", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { (action: UIAlertAction!) in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
